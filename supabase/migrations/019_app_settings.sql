-- Migration 019: tabel app_settings (konfigurasi operasional admin).
-- Referensi: docs/PRD_ADMIN.md bagian 6.6, docs/DATABASE_SCHEMA.md 3.8.
-- Idempoten: aman dijalankan ulang; seed tidak menimpa perubahan admin
-- (ON CONFLICT DO NOTHING).
--
-- Nilai dibaca semua orang (anon + authenticated) agar berlaku sebelum
-- login; tulis hanya admin. Klien memakai fallback AppValues bila tabel
-- belum ada/belum di-push atau offline.

create table if not exists public.app_settings (
  key text primary key,
  value text not null,
  description text,
  updated_at timestamptz not null default timezone('utc', now())
);

comment on table public.app_settings is 'Konfigurasi operasional Go Green yang bisa diubah admin.';

alter table public.app_settings enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'app_settings_read_all'
  ) then
    create policy "app_settings_read_all"
      on public.app_settings for select
      using (true);
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'app_settings_write_admin'
  ) then
    create policy "app_settings_write_admin"
      on public.app_settings for all
      using (public.is_admin())
      with check (public.is_admin());
  end if;
end $$;

-- Seed default (sama dengan AppValues); tidak menimpa nilai admin.
insert into public.app_settings (key, value, description) values
  ('gps_radius_meters', '100', 'Radius GPS default checkpoint (meter).'),
  ('enforce_gps_radius', 'true', 'Penegakan blokir radius GPS (true/false).'),
  ('max_waste_logs_per_day', '5', 'Batas setoran sampah per user per hari.'),
  ('weekly_mission_target', '5', 'Target buang sampah per minggu (kali).'),
  ('max_photo_mb', '5', 'Ukuran maksimal foto bukti (MB).')
on conflict (key) do nothing;
