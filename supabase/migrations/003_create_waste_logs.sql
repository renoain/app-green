-- Migration 003: tabel waste_logs + RLS.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.3.

-- ============ WASTE_LOGS ============
create table if not exists public.waste_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  checkpoint_id uuid references public.checkpoints (id) on delete set null,
  category text not null
    check (category in ('organik', 'anorganik', 'b3', 'daur_ulang')),
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
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.waste_logs is 'Bukti pembuangan sampah dengan anti-kecurangan.';

create index if not exists waste_logs_user_id_idx
  on public.waste_logs (user_id);

create index if not exists waste_logs_checkpoint_id_idx
  on public.waste_logs (checkpoint_id);

-- Query admin/petugas menampilkan log pending berdasarkan urutan waktu.
create index if not exists waste_logs_status_created_at_idx
  on public.waste_logs (status, created_at);

-- Cek duplikat hash anti-kecurangan.
create index if not exists waste_logs_hash_idx
  on public.waste_logs (hash);

-- ============ RLS: WASTE_LOGS ============
alter table public.waste_logs enable row level security;

-- User bisa baca log miliknya.
create policy "waste_logs_select_own"
  on public.waste_logs for select
  using (auth.uid() = user_id);

-- Admin dan petugas bisa baca semua log.
create policy "waste_logs_select_all_staff"
  on public.waste_logs for select
  using (public.is_admin_or_petugas());

-- User bisa insert log miliknya.
create policy "waste_logs_insert_own"
  on public.waste_logs for insert
  with check (auth.uid() = user_id);

-- Admin dan petugas yang memverifikasi log (update status).
create policy "waste_logs_update_staff"
  on public.waste_logs for update
  using (public.is_admin_or_petugas());