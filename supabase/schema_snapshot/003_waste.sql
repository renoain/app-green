-- Baseline 003: waste_logs + verifikasi otomatis (final dari 003+010+016+023+025).
-- Jalankan setelah 002. Idempoten.
-- Referensi: docs/DATABASE_SCHEMA.md 3.3, docs/SECURITY_AND_VALIDATION.md.

create table if not exists public.waste_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  checkpoint_id uuid references public.checkpoints (id) on delete set null,
  category text not null
    check (category in ('organik', 'anorganik', 'b3', 'daur_ulang')),
  item_type text,
  photo_url text,
  hash text,
  latitude double precision,
  longitude double precision,
  server_timestamp timestamptz not null default timezone('utc', now()),
  status text not null default 'pending'
    check (status in ('pending', 'verified', 'rejected')),
  verified_by uuid references auth.users (id) on delete set null,
  verified_at timestamptz,
  notes text,
  source text not null default 'manual'
    check (source in ('qr_scan', 'manual', 'nfc')),
  risk_score integer,
  exif_ok boolean,
  risk_detail text,
  rejection_reason text,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.waste_logs is 'Bukti pembuangan sampah dengan anti-kecurangan.';
comment on column public.waste_logs.item_type is 'Sub-jenis atau keterangan kategori sampah.';
comment on column public.waste_logs.source is 'Asal data: qr_scan (scan QR), manual (pilih manual), nfc (ketuk NFC, fase 2).';
comment on column public.waste_logs.risk_score is 'Skor risiko forensik 0-100 (null = belum dinilai).';
comment on column public.waste_logs.exif_ok is 'Apakah foto punya EXIF kamera utuh.';
comment on column public.waste_logs.risk_detail is 'Kode sinyal risiko koma-dipisah (mis. no_exif,far_gps).';
comment on column public.waste_logs.rejection_reason is 'Alasan penolakan otomatis trigger (belum diverifikasi admin).';

-- Pengaman kolom bila tabel sudah ada dari DB lama.
alter table public.waste_logs
  add column if not exists item_type text;
alter table public.waste_logs
  add column if not exists source text not null default 'manual'
    check (source in ('qr_scan', 'manual', 'nfc'));
alter table public.waste_logs
  add column if not exists risk_score integer,
  add column if not exists exif_ok boolean,
  add column if not exists risk_detail text;
alter table public.waste_logs
  add column if not exists rejection_reason text;

create index if not exists waste_logs_user_id_idx
  on public.waste_logs (user_id);
create index if not exists waste_logs_checkpoint_id_idx
  on public.waste_logs (checkpoint_id);
create index if not exists waste_logs_status_created_at_idx
  on public.waste_logs (status, created_at);
create index if not exists waste_logs_hash_idx
  on public.waste_logs (hash);

-- Trigger verifikasi otomatis versi final (dari 025, menggantikan 024).
-- Aturan: tolak hash duplikat, rate limit 5/hari, GPS radius, checkpoint aktif,
-- batas remaining_uses, kategori valid. Lolos = verified, gagal = pending + alasan.
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

  select exists (
    select 1 from public.waste_logs
    where hash = new.hash
  ) into v_duplicate;
  if v_duplicate then
    v_rejection_reason := 'duplicate_hash';
  end if;

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

  if v_rejection_reason = '' then
    select exists (
      select 1 from unnest(array['organik','anorganik','b3','daur_ulang']) as cat
      where cat = new.category
    ) into v_category_valid;
    if not v_category_valid then
      v_rejection_reason := 'invalid_category';
    end if;
  end if;

  if v_rejection_reason = '' then
    new.status := 'verified';
    new.verified_at := now();
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

drop function if exists public.update_checkpoint_uses_trigger();

-- RLS waste_logs final.
alter table public.waste_logs enable row level security;

drop policy if exists "waste_logs_select_own" on public.waste_logs;
create policy "waste_logs_select_own"
  on public.waste_logs for select
  using (auth.uid() = user_id);

drop policy if exists "waste_logs_select_all_staff" on public.waste_logs;
create policy "waste_logs_select_all_staff"
  on public.waste_logs for select
  using (public.is_admin_or_petugas());

drop policy if exists "waste_logs_insert_own" on public.waste_logs;
create policy "waste_logs_insert_own"
  on public.waste_logs for insert
  with check (auth.uid() = user_id);

drop policy if exists "waste_logs_update_staff" on public.waste_logs;
create policy "waste_logs_update_staff"
  on public.waste_logs for update
  using (public.is_admin_or_petugas());
