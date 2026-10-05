-- Migration 025: batas penggunaan checkpoint + voucher code.
-- Referensi: docs/ARCHITECTURE.md, docs/DATABASE_SCHEMA.md.

-- CHECKPOINTS: max_uses + remaining_uses
alter table public.checkpoints
  add column if not exists max_uses integer,
  add column if not exists remaining_uses integer;

comment on column public.checkpoints.max_uses is
  'Maksimal buang sampah per checkpoint (null = tidak terbatas).';
comment on column public.checkpoints.remaining_uses is
  'Sisa buang sampah yang masih diperbolehkan (null = tidak terbatas).';

create index if not exists checkpoints_remaining_uses_idx
  on public.checkpoints (remaining_uses)
  where remaining_uses is not null and remaining_uses > 0;

-- REDEMPTIONS: voucher_code
alter table public.redemptions
  add column if not exists voucher_code text;

create index if not exists redemptions_voucher_code_idx
  on public.redemptions (voucher_code)
  where voucher_code is not null;

comment on column public.redemptions.voucher_code is
  'Kode voucher unik untuk klaim reward oleh user.';

-- FUNGSI BANTU: generate voucher code
create or replace function public.generate_voucher_code()
returns text
language plpgsql
as $$
declare
  v_code text;
  v_exists boolean;
begin
  loop
    v_code := upper(substring(md5(random()::text) from 1 for 8));
    select exists (
      select 1 from public.redemptions where voucher_code = v_code
    ) into v_exists;
    exit when not v_exists;
  end loop;
  return v_code;
end;
$$;

-- AUTO-VERIFY TRIGGER: check + decrement remaining_uses
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
  v_remaining_uses integer;
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

  -- c. Cek GPS radius dan remaining_uses.
  if v_rejection_reason = '' then
    select c.latitude, c.longitude, c.radius, c.is_active,
           c.remaining_uses
    into v_checkpoint_latitude, v_checkpoint_longitude,
         v_checkpoint_radius, v_checkpoint_is_active, v_remaining_uses
    from public.checkpoints c
    where c.id = new.checkpoint_id;

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

    if v_rejection_reason = '' and v_remaining_uses is not null then
      if v_remaining_uses <= 0 then
        v_rejection_reason := 'checkpoint_limit_reached';
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
    -- Kurangi remaining_uses.
    if v_remaining_uses is not null then
      update public.checkpoints
      set remaining_uses = greatest(0, remaining_uses - 1)
      where id = new.checkpoint_id;
    end if;
  else
    new.status := 'pending';
    new.rejection_reason := v_rejection_reason;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_auto_verify_waste on public.waste_logs;
create trigger trg_auto_verify_waste
  before insert on public.waste_logs
  for each row
  execute function public.auto_verify_waste_trigger();

-- Drop fungsi bantuan yang tidak terpakai lagi.
drop function if exists public.update_checkpoint_uses_trigger();

