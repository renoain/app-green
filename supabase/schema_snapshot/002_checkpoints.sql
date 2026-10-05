-- Baseline 002: checkpoints (state final dari 002+010+017+021+025).
-- Jalankan setelah 001. Idempoten.
-- Referensi: docs/DATABASE_SCHEMA.md 3.2, docs/PRD_ADMIN.md 6.2.

create table if not exists public.checkpoints (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  latitude double precision not null,
  longitude double precision not null,
  radius integer not null default 100 check (radius > 0),
  qr_code text unique,
  code text,
  province_code text,
  city_code text,
  district_code text,
  subdistrict text,
  is_active boolean not null default true,
  max_uses integer,
  remaining_uses integer,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.checkpoints is 'Lokasi pembuangan sampah terdaftar.';
comment on column public.checkpoints.code is 'Kode TPS unik format KOTA-KEC-NOMOR.';
comment on column public.checkpoints.province_code is 'ID provinsi (API wilayah Indonesia).';
comment on column public.checkpoints.city_code is 'ID kota/kabupaten (API wilayah Indonesia).';
comment on column public.checkpoints.district_code is 'ID kecamatan (API wilayah Indonesia).';
comment on column public.checkpoints.subdistrict is 'Kelurahan (opsional).';
comment on column public.checkpoints.is_active is 'Status aktif TPS (soft-delete admin).';
comment on column public.checkpoints.max_uses is 'Maksimal buang sampah per checkpoint (null = tidak terbatas).';
comment on column public.checkpoints.remaining_uses is 'Sisa buang sampah yang masih diperbolehkan (null = tidak terbatas).';

-- Pengaman kolom bila tabel sudah ada dari DB lama.
alter table public.checkpoints
  add column if not exists code text,
  add column if not exists province_code text,
  add column if not exists city_code text,
  add column if not exists district_code text,
  add column if not exists subdistrict text,
  add column if not exists is_active boolean not null default true,
  add column if not exists max_uses integer,
  add column if not exists remaining_uses integer;

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'checkpoints_code_key'
  ) then
    alter table public.checkpoints add constraint checkpoints_code_key unique (code);
  end if;
end $$;

create index if not exists checkpoints_name_idx
  on public.checkpoints (name);
create index if not exists checkpoints_city_code_idx
  on public.checkpoints (city_code);
create index if not exists checkpoints_district_code_idx
  on public.checkpoints (district_code);
create index if not exists checkpoints_code_idx
  on public.checkpoints (code);
create index if not exists checkpoints_is_active_idx
  on public.checkpoints (is_active);
create index if not exists checkpoints_remaining_uses_idx
  on public.checkpoints (remaining_uses)
  where remaining_uses is not null and remaining_uses > 0;

-- RLS checkpoints final.
alter table public.checkpoints enable row level security;

drop policy if exists "checkpoints_read_all" on public.checkpoints;
create policy "checkpoints_read_all"
  on public.checkpoints for select
  using (true);

drop policy if exists "checkpoints_insert_admin" on public.checkpoints;
create policy "checkpoints_insert_admin"
  on public.checkpoints for insert
  with check (public.is_admin());

drop policy if exists "checkpoints_update_admin" on public.checkpoints;
create policy "checkpoints_update_admin"
  on public.checkpoints for update
  using (public.is_admin());

drop policy if exists "checkpoints_delete_admin" on public.checkpoints;
create policy "checkpoints_delete_admin"
  on public.checkpoints for delete
  using (public.is_admin());
