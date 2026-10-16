-- Migration 028: verified_at wajib dari jam server + RPC hitung log harian.
-- Referensi: docs/ARCHITECTURE.md, docs/SECURITY_AND_VALIDATION.md, AGENTS.md bagian 12.
--
-- Latar belakang: klien dulu mengirim verified_at dari jam device saat admin
-- memverifikasi waste log. Jam device bisa salah dimanipulasi, sehingga waktu
-- verifikasi tidak tepercaya. Sesuai aturan anti-kecurangan, timestamp harus
-- berasal dari server.

-- Trigger: paksa verified_at memakai jam server saat status berubah menjadi
-- verified atau rejected. Nilai dari klien diabaikan.
create or replace function public.set_verified_at_trigger()
returns trigger
language plpgsql
as $$
begin
  if new.status in ('verified', 'rejected')
     and (tg_op = 'INSERT' or old.status is distinct from new.status) then
    new.verified_at := now();
    new.verified_by := coalesce(new.verified_by, auth.uid());
  end if;
  return new;
end;
$$;

drop trigger if exists trg_set_verified_at_insert on public.waste_logs;
create trigger trg_set_verified_at_insert
  before insert on public.waste_logs
  for each row
  execute function public.set_verified_at_trigger();

drop trigger if exists trg_set_verified_at_update on public.waste_logs;
create trigger trg_set_verified_at_update
  before update on public.waste_logs
  for each row
  execute function public.set_verified_at_trigger();

comment on function public.set_verified_at_trigger() is
  'Memaksa verified_at memakai jam server saat status waste_logs menjadi verified atau rejected.';

-- RPC: hitung jumlah waste log user sejak awal hari server. Dipakai klien untuk
-- pesan batas harian. Memakai current_date agar batasnya sama dengan trigger
-- auto_verify_waste_trigger yang juga memakai current_date.
create or replace function public.count_today_waste_logs(p_user_id uuid)
returns integer
language sql
stable
security definer
set search_path = public
as $$
  select count(*)::integer
  from public.waste_logs
  where user_id = p_user_id
    and created_at >= current_date;
$$;

revoke all on function public.count_today_waste_logs(uuid) from public;
grant execute on function public.count_today_waste_logs(uuid) to authenticated;