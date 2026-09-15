-- Migration 005: tabel rewards + RLS.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.5.

-- ============ REWARDS ============
create table if not exists public.rewards (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  points_cost integer not null check (points_cost > 0),
  stock integer not null default 0 check (stock >= 0),
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.rewards is 'Katalog hadiah yang bisa ditukar poin.';

create index if not exists rewards_is_active_idx
  on public.rewards (is_active);

-- ============ RLS: REWARDS ============
alter table public.rewards enable row level security;

-- Semua user hanya bisa membaca reward yang aktif.
create policy "rewards_read_active"
  on public.rewards for select
  using (is_active = true);

-- Hanya admin yang boleh mengelola katalog reward.
create policy "rewards_insert_admin"
  on public.rewards for insert
  with check (public.is_admin());

create policy "rewards_update_admin"
  on public.rewards for update
  using (public.is_admin());

create policy "rewards_delete_admin"
  on public.rewards for delete
  using (public.is_admin());