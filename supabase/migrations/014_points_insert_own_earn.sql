-- Migration 014: izinkan klien mencatat poin earn sendiri (MVP).
--
-- Latar: SubmitWasteUsecase menghitung estimasi poin tapi tidak pernah
-- menulis ke public.points (tidak ada policy insert klien), sehingga user
-- tidak pernah dapat poin. Pilihan MVP: poin langsung saat submit.
-- Batasan anti-kecurangan sementara: hanya type 'earn', amount 1-50
-- (maksimum formula: base 25 + bonus kategori 15 + streak 10).
-- Pengerasan fase lanjut: trigger/RPC sisi server saat status verified
-- + UI verifikasi admin (lihat docs/ARCHITECTURE.md 10.4).

create policy "points_insert_own_earn"
  on public.points for insert
  with check (
    auth.uid() = user_id
    and type = 'earn'
    and amount >= 1
    and amount <= 50
  );
