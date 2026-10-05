-- Baseline 005: pengaturan dan audit admin (final dari 019+020+022).
-- Jalankan setelah 004. Idempoten, seed tidak menimpa nilai admin.
-- Referensi: docs/PRD_ADMIN.md 6.6, docs/DATABASE_SCHEMA.md 3.8/3.9.

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

-- Seed default operasional (dari 019).
insert into public.app_settings (key, value, description) values
  ('gps_radius_meters', '100', 'Radius GPS default checkpoint (meter).'),
  ('enforce_gps_radius', 'true', 'Penegakan blokir radius GPS (true/false).'),
  ('max_waste_logs_per_day', '5', 'Batas setoran sampah per user per hari.'),
  ('weekly_mission_target', '5', 'Target buang sampah per minggu (kali).'),
  ('max_photo_mb', '5', 'Ukuran maksimal foto bukti (MB).')
on conflict (key) do nothing;

-- Seed bonus kategori (dari 022).
insert into public.app_settings (key, value, description) values
  ('bonus_organik', '0', 'Bonus poin kategori organik.'),
  ('bonus_anorganik', '5', 'Bonus poin kategori anorganik.'),
  ('bonus_daur_ulang', '10', 'Bonus poin kategori daur ulang.'),
  ('bonus_b3', '15', 'Bonus poin kategori B3.')
on conflict (key) do nothing;

-- Audit admin (dari 020, append-only: baca + insert admin saja).
create table if not exists public.admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users (id) on delete set null,
  action text not null,
  entity text not null,
  entity_id text,
  detail text,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.admin_audit_logs is 'Jejak aksi admin (tambah/ubah/hapus/verifikasi).';

create index if not exists admin_audit_logs_created_at_idx
  on public.admin_audit_logs (created_at desc);
create index if not exists admin_audit_logs_actor_idx
  on public.admin_audit_logs (actor_id);

alter table public.admin_audit_logs enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'admin_audit_logs_select_admin'
  ) then
    create policy "admin_audit_logs_select_admin"
      on public.admin_audit_logs for select
      using (public.is_admin());
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'admin_audit_logs_insert_admin'
  ) then
    create policy "admin_audit_logs_insert_admin"
      on public.admin_audit_logs for insert
      with check (public.is_admin());
  end if;
end $$;
