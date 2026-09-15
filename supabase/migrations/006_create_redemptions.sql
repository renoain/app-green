-- Migration 006: tabel redemptions + RLS.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.6.

-- ============ REDEMPTIONS ============
create table if not exists public.redemptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  reward_id uuid references public.rewards (id) on delete set null,
  status text not null default 'pending'
    check (status in ('pending', 'approved', 'rejected', 'claimed')),
  qr_code text unique,
  created_at timestamptz not null default timezone('utc', now()),
  claimed_at timestamptz
);

comment on table public.redemptions is 'Riwayat penukaran hadiah oleh user.';

create index if not exists redemptions_user_id_idx
  on public.redemptions (user_id);

create index if not exists redemptions_reward_id_idx
  on public.redemptions (reward_id);

create index if not exists redemptions_status_idx
  on public.redemptions (status);

-- ============ RLS: REDEMPTIONS ============
alter table public.redemptions enable row level security;

-- User bisa baca redemption miliknya.
create policy "redemptions_select_own"
  on public.redemptions for select
  using (auth.uid() = user_id);

-- User bisa mengajukan redemption sendiri.
create policy "redemptions_insert_own"
  on public.redemptions for insert
  with check (auth.uid() = user_id);

-- Admin dan petugas bisa baca/update semua redemption.
create policy "redemptions_select_all_staff"
  on public.redemptions for select
  using (public.is_admin_or_petugas());

create policy "redemptions_update_staff"
  on public.redemptions for update
  using (public.is_admin_or_petugas());