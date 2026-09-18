-- Migration 013: normalisasi username lama ke lowercase (idempoten).
--
-- Latar: trigger 007 tidak me-lower() username sehingga akun yang dibuat
-- sebelum migration 011 bisa menyimpan kapital/spasi (mis. dari insert
-- manual era AuthService atau metadata lama). Login selalu me-lower()
-- input dan RPC membandingkan case-insensitive, tetapi nilai ber-spasi
-- atau ber-kapital tetap tidak cocok dengan username yang diketik user
-- sehingga login username gagal dengan invalidCredentials padahal
-- password benar (login email tetap bisa).
--
-- Baris yang akan tabrakan unique constraint setelah di-lower() DILEWATI
-- agar migrasi tidak gagal; perbaiki manual per akun bila terjadi.
--
-- Referensi skema: docs/DATABASE_SCHEMA.md.

update public.profiles p
set username = lower(p.username)
where p.username <> lower(p.username)
  and not exists (
    select 1
    from public.profiles q
    where q.username = lower(p.username)
      and q.id <> p.id
  );
