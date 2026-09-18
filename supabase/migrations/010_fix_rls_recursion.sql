-- Migration 010: perbaikan infinite recursion pada policy RLS.
--
-- Gejala: query SELECT pada public.profiles dan public.checkpoints gagal
-- dengan error "infinite recursion detected in policy for relation
-- \"profiles\"" (SQLSTATE 42P17), padahal fungsi role pengecekan sudah
-- security definer (terbukti aman di tabel points/redemptions).
--
-- Penyebab: ada policy di luar definisi kanonik (kemungkinan hasil
-- eksperimen manual di SQL Editor) yang membuat referensi melingkar ke
-- public.profiles.
--
-- Strategi:
-- 1. Hapus SEMUA policy pada tabel publik milik Go Green, lalu buat ulang
--    hanya policy kanonik dari migration 001-006 (idempoten, aman).
-- 2. Buat ulang fungsi bantu role sebagai security definer.
-- 3. Pastikan RLS aktif untuk semua tabel tersebut.
--
-- Referensi: docs/DATABASE_SCHEMA.md.

-- ============ BERSIHKAN SEMUA POLICY TABEL PUBLIK ============
do $$
declare
  rec record;
begin
  for rec in
    select c.oid::regclass::text as tbl, p.polname
    from pg_policy p
    join pg_class c on c.oid = p.polrelid
    where c.oid in (
      'public.profiles'::regclass,
      'public.checkpoints'::regclass,
      'public.waste_logs'::regclass,
      'public.points'::regclass,
      'public.rewards'::regclass,
      'public.redemptions'::regclass
    )
  loop
    execute format('drop policy %I on %s', rec.polname, rec.tbl);
  end loop;
end $$;

-- ============ FUNGSI BANTU ROLE (SECURITY DEFINER) ============
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

create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_select_all_admin"
  on public.profiles for select
  using (public.is_admin());

create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (
    auth.uid() = id
    and coalesce(public.get_role(id), 'user') = role
  );

-- ============ RLS: CHECKPOINTS ============
alter table public.checkpoints enable row level security;

create policy "checkpoints_read_all"
  on public.checkpoints for select
  using (true);

create policy "checkpoints_insert_admin"
  on public.checkpoints for insert
  with check (public.is_admin());

create policy "checkpoints_update_admin"
  on public.checkpoints for update
  using (public.is_admin());

create policy "checkpoints_delete_admin"
  on public.checkpoints for delete
  using (public.is_admin());

-- ============ RLS: WASTE_LOGS ============
alter table public.waste_logs enable row level security;

create policy "waste_logs_select_own"
  on public.waste_logs for select
  using (auth.uid() = user_id);

create policy "waste_logs_select_all_staff"
  on public.waste_logs for select
  using (public.is_admin_or_petugas());

create policy "waste_logs_insert_own"
  on public.waste_logs for insert
  with check (auth.uid() = user_id);

create policy "waste_logs_update_staff"
  on public.waste_logs for update
  using (public.is_admin_or_petugas());

-- ============ RLS: POINTS ============
alter table public.points enable row level security;

create policy "points_select_own"
  on public.points for select
  using (auth.uid() = user_id);

create policy "points_select_all_admin"
  on public.points for select
  using (public.is_admin());

-- ============ RLS: REWARDS ============
alter table public.rewards enable row level security;

create policy "rewards_read_active"
  on public.rewards for select
  using (is_active = true);

create policy "rewards_insert_admin"
  on public.rewards for insert
  with check (public.is_admin());

create policy "rewards_update_admin"
  on public.rewards for update
  using (public.is_admin());

create policy "rewards_delete_admin"
  on public.rewards for delete
  using (public.is_admin());

-- ============ RLS: REDEMPTIONS ============
alter table public.redemptions enable row level security;

create policy "redemptions_select_own"
  on public.redemptions for select
  using (auth.uid() = user_id);

create policy "redemptions_insert_own"
  on public.redemptions for insert
  with check (auth.uid() = user_id);

create policy "redemptions_select_all_staff"
  on public.redemptions for select
  using (public.is_admin_or_petugas());

create policy "redemptions_update_staff"
  on public.redemptions for update
  using (public.is_admin_or_petugas());