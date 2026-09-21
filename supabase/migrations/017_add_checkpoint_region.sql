-- Migration 017: kolom wilayah + kode TPS di checkpoints.
-- Referensi: docs/PRD_ADMIN.md bagian 6.2, docs/DATABASE_SCHEMA.md 3.2.
-- Idempoten: aman dijalankan ulang; baris lama dibiarkan null.

alter table public.checkpoints
  add column if not exists code text,
  add column if not exists province_code text,
  add column if not exists city_code text,
  add column if not exists district_code text,
  add column if not exists subdistrict text;

-- Kode TPS unik format <KOTA>-<KEC>-<NOMOR> (mis. SBY-KTT-01).
-- Constraint ditambah kondisional agar migrasi tidak gagal bila sudah ada.
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'checkpoints_code_key'
  ) then
    alter table public.checkpoints add constraint checkpoints_code_key unique (code);
  end if;
end $$;

create index if not exists checkpoints_city_code_idx
  on public.checkpoints (city_code);

create index if not exists checkpoints_district_code_idx
  on public.checkpoints (district_code);

create index if not exists checkpoints_code_idx
  on public.checkpoints (code);

comment on column public.checkpoints.code is 'Kode TPS unik format KOTA-KEC-NOMOR.';
comment on column public.checkpoints.province_code is 'ID provinsi (API wilayah Indonesia).';
comment on column public.checkpoints.city_code is 'ID kota/kabupaten (API wilayah Indonesia).';
comment on column public.checkpoints.district_code is 'ID kecamatan (API wilayah Indonesia).';
comment on column public.checkpoints.subdistrict is 'Kelurahan (opsional).';
