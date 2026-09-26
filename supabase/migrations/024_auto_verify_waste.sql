-- Migration 024: Auto-verify waste_logs via BEFORE INSERT trigger.
-- Referensi: docs/SECURITY_AND_VALIDATION.md (auto-approve),
-- docs/DATABASE_SCHEMA.md 3.3, 6.
-- Idempoten: drop trigger/function if exists, create or replace.
--
-- Aturan:
--   a. Hash unik (tidak duplikat)
--   b. Rate limit: max 5 per user per hari
--   c. GPS radius: haversine ke checkpoint <= radius checkpoint
--   d. Kategori valid (organik, anorganik, b3, daur_ulang)
--   e. Checkpoint aktif (is_active = true)
--
-- Lolos semua: status = 'verified', verified_at = now()
-- Gagal salah satu: status = 'pending', rejection_reason diisi
-- (bukan rejected, biar admin bisa review).
--
-- JANGAN ubah kolom yang sudah ada. Kolom rejection_reason
-- ditambah di migration ini jika belum ada.

-- Tambahkan kolom rejection_reason jika belum ada.
alter table public.waste_logs
  add column if not exists rejection_reason text;

comment on column public.waste_logs.rejection_reason is
  'Alasan penolakan otomatis trigger (belum diverifikasi admin).';

-- Drop trigger dan function lama jika ada (idempoten).
drop trigger if exists trg_auto_verify_waste on public.waste_logs;
drop function if exists public.auto_verify_waste_trigger();

-- Fungsi trigger BEFORE INSERT.
create or replace function public.auto_verify_waste_trigger()
returns trigger
language plpgsql
security definer
as $$
declare
  v_checkpoint_latitude double precision;
  v_checkpoint_longitude double precision;
  v_checkpoint_radius integer;
  v_checkpoint_is_active boolean;
  v_today_count integer;
  v_distance_meters double precision;
  v_duplicate boolean;
  v_category_valid boolean;
  v_rejection_reason text;
begin
  v_rejection_reason := '';

  -- a. Cek hash duplikat.
  select exists (
    select 1 from public.waste_logs
    where hash = new.hash
  ) into v_duplicate;
  if v_duplicate then
    v_rejection_reason := 'duplicate_hash';
  end if;

  -- b. Cek rate limit: max 5 per user per hari.
  if v_rejection_reason = '' then
    select count(*)::integer
    into v_today_count
    from public.waste_logs
    where user_id = new.user_id
      and created_at >= current_date;
    if v_today_count >= 5 then
      v_rejection_reason := 'rate_limit_exceeded';
    end if;
  end if;

  -- c. Cek GPS radius: haversine ke checkpoint <= radius.
  if v_rejection_reason = '' then
    select c.latitude, c.longitude, c.radius, c.is_active
    into v_checkpoint_latitude, v_checkpoint_longitude,
         v_checkpoint_radius, v_checkpoint_is_active
    from public.checkpoints c
    where c.id = new.checkpoint_id;

    -- Checkpoint harus aktif.
    if not v_checkpoint_is_active then
      v_rejection_reason := 'checkpoint_inactive';
    else
      v_distance_meters := 6371000.0 * 2.0 * asin(
        sqrt(
          sin(radians(new.latitude - v_checkpoint_latitude) / 2.0) ^ 2 +
          cos(radians(v_checkpoint_latitude)) *
          cos(radians(new.latitude)) *
          sin(radians(new.longitude - v_checkpoint_longitude) / 2.0) ^ 2
        )
      );
      if v_distance_meters > v_checkpoint_radius::double precision then
        v_rejection_reason := 'gps_out_of_range';
      end if;
    end if;
  end if;

  -- d. Cek kategori valid.
  if v_rejection_reason = '' then
    select exists (
      select 1 from unnest(array['organik','anorganik','b3','daur_ulang']) as cat
      where cat = new.category
    ) into v_category_valid;
    if not v_category_valid then
      v_rejection_reason := 'invalid_category';
    end if;
  end if;

  -- Tentukan status akhir.
  if v_rejection_reason = '' then
    new.status := 'verified';
    new.verified_at := now();
  else
    new.status := 'pending';
    new.rejection_reason := v_rejection_reason;
  end if;

  return new;
end;
$$;

-- Buat trigger BEFORE INSERT pada waste_logs.
create trigger trg_auto_verify_waste
  before insert on public.waste_logs
  for each row
  execute function public.auto_verify_waste_trigger();
