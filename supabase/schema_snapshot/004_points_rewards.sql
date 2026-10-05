-- Baseline 004: poin, reward, penukaran, artikel (final dari 004+005+006+010+015+018+025+027).
-- Jalankan setelah 003. Idempoten. Seed data ada di 007.

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

create table if not exists public.redemptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  reward_id uuid references public.rewards (id) on delete set null,
  status text not null default 'pending'
    check (status in ('pending', 'approved', 'rejected', 'claimed')),
  qr_code text unique,
  voucher_code text,
  created_at timestamptz not null default timezone('utc', now()),
  claimed_at timestamptz
);

comment on table public.redemptions is 'Riwayat penukaran hadiah oleh user.';
comment on column public.redemptions.voucher_code is 'Kode voucher unik untuk klaim reward oleh user.';

create index if not exists redemptions_user_id_idx
  on public.redemptions (user_id);
create index if not exists redemptions_reward_id_idx
  on public.redemptions (reward_id);
create index if not exists redemptions_status_idx
  on public.redemptions (status);
create index if not exists redemptions_voucher_code_idx
  on public.redemptions (voucher_code)
  where voucher_code is not null;

alter table public.redemptions
  add column if not exists voucher_code text;

create table if not exists public.articles (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  excerpt text,
  content text not null,
  cover_url text,
  published_at timestamptz not null default timezone('utc', now()),
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.articles is 'Artikel edukasi lingkungan.';

create index if not exists articles_published_at_idx
  on public.articles (published_at desc);

-- Fungsi voucher (dari 025).
create or replace function public.generate_voucher_code()
returns text
language plpgsql
as $$
declare
  v_code text;
  v_exists boolean;
begin
  loop
    v_code := upper(substring(md5(random()::text) from 1 for 8));
    select exists (
      select 1 from public.redemptions where voucher_code = v_code
    ) into v_exists;
    exit when not v_exists;
  end loop;
  return v_code;
end;
$$;

-- RLS points final (policy 015, menggantikan 014).
alter table public.points enable row level security;

drop policy if exists "points_select_own" on public.points;
create policy "points_select_own"
  on public.points for select
  using (auth.uid() = user_id);

drop policy if exists "points_select_all_admin" on public.points;
create policy "points_select_all_admin"
  on public.points for select
  using (public.is_admin());

drop policy if exists "points_insert_own_earn" on public.points;
drop policy if exists "points_insert_own" on public.points;
create policy "points_insert_own"
  on public.points for insert
  with check (
    auth.uid() = user_id
    and amount >= 1
    and amount <= 50
    and type in ('earn', 'redeem')
  );

comment on policy "points_insert_own" on public.points is
  'MVP: klien boleh insert earn/redeem milik sendiri (amount 1-50). Pengerasan fase lanjut: approval server (docs/ARCHITECTURE.md 10.4).';

-- RLS rewards final (kanonik 010 + tambahan admin 018).
alter table public.rewards enable row level security;

drop policy if exists "rewards_read_active" on public.rewards;
create policy "rewards_read_active"
  on public.rewards for select
  using (is_active = true);

drop policy if exists "rewards_select_all_admin" on public.rewards;
create policy "rewards_select_all_admin"
  on public.rewards for select
  using (public.is_admin());

drop policy if exists "rewards_insert_admin" on public.rewards;
create policy "rewards_insert_admin"
  on public.rewards for insert
  with check (public.is_admin());

drop policy if exists "rewards_update_admin" on public.rewards;
create policy "rewards_update_admin"
  on public.rewards for update
  using (public.is_admin());

drop policy if exists "rewards_delete_admin" on public.rewards;
create policy "rewards_delete_admin"
  on public.rewards for delete
  using (public.is_admin());

-- RLS redemptions final.
alter table public.redemptions enable row level security;

drop policy if exists "redemptions_select_own" on public.redemptions;
create policy "redemptions_select_own"
  on public.redemptions for select
  using (auth.uid() = user_id);

drop policy if exists "redemptions_insert_own" on public.redemptions;
create policy "redemptions_insert_own"
  on public.redemptions for insert
  with check (auth.uid() = user_id);

drop policy if exists "redemptions_select_all_staff" on public.redemptions;
create policy "redemptions_select_all_staff"
  on public.redemptions for select
  using (public.is_admin_or_petugas());

drop policy if exists "redemptions_update_staff" on public.redemptions;
create policy "redemptions_update_staff"
  on public.redemptions for update
  using (public.is_admin_or_petugas());

-- RLS articles final (dari 015).
alter table public.articles enable row level security;

drop policy if exists "articles_read_all" on public.articles;
create policy "articles_read_all"
  on public.articles for select
  using (true);

drop policy if exists "articles_insert_admin" on public.articles;
create policy "articles_insert_admin"
  on public.articles for insert
  with check (public.is_admin());

drop policy if exists "articles_update_admin" on public.articles;
create policy "articles_update_admin"
  on public.articles for update
  using (public.is_admin());

drop policy if exists "articles_delete_admin" on public.articles;
create policy "articles_delete_admin"
  on public.articles for delete
  using (public.is_admin());
