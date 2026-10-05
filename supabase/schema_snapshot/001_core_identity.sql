-- Baseline 001: identitas user (state final dari 001+010+011+018+026).
-- Jalankan pertama. Idempoten: aman diulang di DB baru.
-- Referensi: docs/DATABASE_SCHEMA.md 3.1.

-- Tabel profiles final (termasuk username unik dan fcm_token).
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  username text unique,
  role text not null default 'user'
    check (role in ('user', 'admin', 'petugas')),
  fcm_token text,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.profiles is 'Data profil dan role user Go Green.';
comment on column public.profiles.fcm_token is 'Token FCM perangkat untuk push notification.';

-- Pengaman: unique username bila tabel sudah ada dari DB lama.
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'profiles_username_key'
  ) then
    alter table public.profiles
      add constraint profiles_username_key unique (username);
  end if;
end $$;

-- Fungsi role (security definer agar policy tidak rekrursif).
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

-- RPC login username: cari email dari username (dipanggil sebelum login).
create or replace function public.get_email_by_username(p_username text)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select au.email
  from auth.users au
  join public.profiles p on p.id = au.id
  where lower(p.username) = lower(p_username)
  limit 1;
$$;

comment on function public.get_email_by_username(text) is
  'Mencari email auth dari username untuk login username (MVP).';

grant execute on function public.get_email_by_username(text)
  to anon, authenticated;

-- Trigger pembuatan profil saat user auth baru (versi final: lowercase).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, username)
  values (
    new.id,
    coalesce(new.email, ''),
    lower(coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'username'), ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ))
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Normalisasi sekali-jalan untuk username lama (dari 013).
update public.profiles p
set username = lower(p.username)
where p.username <> lower(p.username)
  and not exists (
    select 1
    from public.profiles q
    where q.username = lower(p.username)
      and q.id <> p.id
  );

-- RLS profiles final.
alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

drop policy if exists "profiles_select_all_admin" on public.profiles;
create policy "profiles_select_all_admin"
  on public.profiles for select
  using (public.is_admin());

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (
    auth.uid() = id
    and coalesce(public.get_role(id), 'user') = role
  );

drop policy if exists "profiles_update_role_admin" on public.profiles;
create policy "profiles_update_role_admin"
  on public.profiles for update
  using (public.is_admin())
  with check (public.is_admin());
