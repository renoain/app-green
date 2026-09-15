-- Migration 004: tabel points + RLS.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.4.
-- Catatan: pencatatan poin (earn saat verifikasi, redeem saat klaim)
-- dilakukan sisi server (trigger/RPC fase lanjut), sehingga tidak ada
-- policy insert untuk klien.

-- ============ POINTS ============
create table if not exists public.points (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  amount integer not null,
  type text not null check (type in ('earn', 'redeem')),
  reference_id uuid,
  description text,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.points is 'Riwayat poin user.';

create index if not exists points_user_id_idx
  on public.points (user_id);

create index if not exists points_user_created_at_idx
  on public.points (user_id, created_at desc);

-- ============ RLS: POINTS ============
alter table public.points enable row level security;

-- User bisa baca riwayat poin miliknya.
create policy "points_select_own"
  on public.points for select
  using (auth.uid() = user_id);

-- Admin bisa baca semua riwayat poin.
create policy "points_select_all_admin"
  on public.points for select
  using (public.is_admin());