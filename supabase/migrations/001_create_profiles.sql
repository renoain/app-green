-- Migration 001: tabel profiles + RLS.
-- Fungsi role dipakai bersama oleh migration lain untuk policy admin/petugas.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.1.

-- ============ PROFILES ============
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  username text unique,
  role text not null default 'user'
    check (role in ('user', 'admin', 'petugas')),
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.profiles is 'Data profil dan role user Go Green.';

-- ============ FUNGSI BANTU ROLE ============
-- Security definer agar bisa membaca profiles dari dalam policy tanpa
-- memicu rekrursif RLS pada tabel yang sama.

create or replace function public.get_role(_user_id uuid)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select p.role from public.profiles p where p.id = _user_id;
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.get_role(auth.uid()) = 'admin';
$$;

create or replace function public.is_petugas()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.get_role(auth.uid()) = 'petugas';
$$;

create or replace function public.is_admin_or_petugas()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.get_role(auth.uid()), '') in ('admin', 'petugas');
$$;

-- ============ RLS: PROFILES ============
alter table public.profiles enable row level security;

-- User bisa baca profil sendiri.
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

-- Admin bisa baca semua profil.
create policy "profiles_select_all_admin"
  on public.profiles for select
  using (public.is_admin());

-- User bisa update profil sendiri, tetapi role tidak boleh berubah.
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (
    auth.uid() = id
    and coalesce(public.get_role(id), 'user') = role
  );