-- Migration 002: tabel checkpoints + RLS.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.2.

-- ============ CHECKPOINTS ============
create table if not exists public.checkpoints (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  latitude double precision not null,
  longitude double precision not null,
  radius integer not null default 100 check (radius > 0),
  qr_code text unique,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.checkpoints is 'Lokasi pembuangan sampah terdaftar.';

create index if not exists checkpoints_name_idx
  on public.checkpoints (name);

-- ============ RLS: CHECKPOINTS ============
alter table public.checkpoints enable row level security;

-- Semua user (dan guest) bisa membaca daftar checkpoint.
create policy "checkpoints_read_all"
  on public.checkpoints for select
  using (true);

-- Hanya admin yang boleh menambah/mengubah/menghapus checkpoint.
create policy "checkpoints_insert_admin"
  on public.checkpoints for insert
  with check (public.is_admin());

create policy "checkpoints_update_admin"
  on public.checkpoints for update
  using (public.is_admin());

create policy "checkpoints_delete_admin"
  on public.checkpoints for delete
  using (public.is_admin());