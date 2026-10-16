-- Migration 029: crediting poin dipindahkan ke trigger server.
--
-- Latar belakang: policy points_insert_own (migration 015) mengizinkan klien
-- insert baris earn milik sendiri dengan amount 1-50 tanpa batas jumlah baris
-- dan tanpa syarat waste log terverifikasi. Akibatnya user bisa mencetak poin
-- tanpa buang sampah dengan memanggil REST API secara langsung.
--
-- Perbaikan: poin earn hanya dicatat server lewat trigger yang menyala saat
-- waste log berstatus verified. Insert earn dari klien dihapus; klien tetap
-- boleh membuat baris redeem karena arahnya mengurangi saldo sendiri.
--
-- Formula poin dicerminkan dari CalculatePointsUsecase:
--   base_points_per_waste + bonus_kategori (app_settings) + bonus_streak
-- supaya nilai di server sama dengan estimasi di aplikasi.

-- Helper: baca nilai numerik dari app_settings dengan fallback.
create or replace function public.get_setting_number(p_key text, p_fallback integer)
returns integer
language plpgsql
stable
as $$
declare
  v_value integer;
begin
  select value::integer
  into v_value
  from public.app_settings
  where key = p_key;

  if v_value is null then
    return p_fallback;
  end if;
  return v_value;
exception
  when others then
    return p_fallback;
end;
$$;

comment on function public.get_setting_number(text, integer) is
  'Baca nilai numerik dari app_settings; memakai fallback bila key hilang atau tidak bisa diparse.';

-- Helper: apakah user cukup poin dan reward masih tersedia untuk ditukar.
create or replace function public.can_redeem_reward(p_reward_id uuid, p_amount integer)
returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_stock integer;
  v_balance integer;
begin
  select stock into v_stock
  from public.rewards
  where id = p_reward_id and is_active = true;

  if v_stock is null or v_stock <= 0 then
    return false;
  end if;

  select coalesce(sum(amount), 0) into v_balance
  from public.points
  where user_id = auth.uid();

  return v_balance >= p_amount;
end;
$$;

comment on function public.can_redeem_reward(uuid, integer) is
  'True bila reward aktif dan stoknya tersedia serta saldo user cukup.';

-- Trigger: catat poin earn saat waste log menjadi verified.
create or replace function public.credit_points_on_verified_waste()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_base integer;
  v_bonus integer;
  v_streak_bonus integer;
  v_threshold integer;
  v_streak_points integer;
  v_amount integer;
  v_streak_days integer;
  v_description text;
begin
  -- Hanya jalan saat baris terverifikasi.
  if new.status <> 'verified' then
    return new;
  end if;

  -- Jangan dobelkan poin saat status di-update dari verified ke verified.
  if tg_op = 'UPDATE' and old.status = 'verified' then
    return new;
  end if;

  -- Penjaga tambahan: satu baris poin earn per waste log.
  if exists (
    select 1 from public.points
    where reference_id = new.id and type = 'earn'
  ) then
    return new;
  end if;

  v_base := public.get_setting_number('base_points_per_waste', 25);
  v_threshold := public.get_setting_number('streak_bonus_threshold', 3);
  v_streak_points := public.get_setting_number('streak_bonus_points', 10);

  v_bonus := case new.category
    when 'organik' then public.get_setting_number('bonus_organik', 0)
    when 'anorganik' then public.get_setting_number('bonus_anorganik', 5)
    when 'daur_ulang' then public.get_setting_number('bonus_daur_ulang', 10)
    when 'b3' then public.get_setting_number('bonus_b3', 15)
    else 0
  end;

  -- Streak: hitung hari beruntun terverifikasi user dalam 7 hari terakhir.
  select count(distinct (created_at at time zone 'utc')::date)
  into v_streak_days
  from public.waste_logs
  where user_id = new.user_id
    and status = 'verified'
    and (created_at at time zone 'utc')::date
      between (new.created_at at time zone 'utc')::date - 6
          and (new.created_at at time zone 'utc')::date;

  v_streak_bonus := case when v_streak_days >= v_threshold
    then v_streak_points
    else 0
  end;

  v_amount := v_base + v_bonus + v_streak_bonus;

  v_description := 'Buang sampah ' || new.category || ' di '
    || coalesce(
      (select name from public.checkpoints where id = new.checkpoint_id),
      'checkpoint'
    );

  insert into public.points (user_id, amount, type, reference_id, description)
  values (new.user_id, v_amount, 'earn', new.id, v_description);

  return new;
end;
$$;

drop trigger if exists trg_credit_points_verified on public.waste_logs;
create trigger trg_credit_points_verified
  after insert or update of status on public.waste_logs
  for each row
  execute function public.credit_points_on_verified_waste();

comment on function public.credit_points_on_verified_waste() is
  'Mencatat poin earn di tabel points saat waste log berstatus verified. Satu baris poin per waste log.';

-- Seed konfigurasi poin agar bisa diubah admin tanpa deploy ulang.
insert into public.app_settings (key, value, description) values
  ('base_points_per_waste', '25', 'Poin dasar per setoran terverifikasi.'),
  ('streak_bonus_threshold', '3', 'Jumlah hari beruntun minimal untuk bonus streak.'),
  ('streak_bonus_points', '10', 'Bonus poin saat streak melewati ambang.')
on conflict (key) do nothing;

-- Cabut hak insert earn dari klien. Klien hanya boleh membuat baris redeem
-- untuk mengurangi saldo sendiri.
drop policy if exists "points_insert_own" on public.points;
drop policy if exists "points_insert_own_earn" on public.points;

create policy "points_insert_redeem_own"
  on public.points for insert
  with check (
    auth.uid() = user_id
    and type = 'redeem'
    and amount < 0
    and reference_id is not null
    and public.can_redeem_reward(reference_id, -amount)
  );

comment on policy "points_insert_redeem_own" on public.points is
  'Klien boleh membuat baris redeem untuk mengurangi saldo sendiri bila reward masih tersedia dan saldo cukup.';

-- Catatan: tidak perlu backfill. Waste log lama sudah punya baris points dari
-- jalur klien sebelum migration ini, dan trigger di atas memakai penjaga
-- "satu baris earn per waste log" sehingga log lama tidak akan dobel poin.