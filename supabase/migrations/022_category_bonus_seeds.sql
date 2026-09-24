-- Migration 022: seed bonus poin kategori di app_settings.
-- Referensi: docs/PRD_ADMIN.md bagian 6.6.
-- Idempoten: tidak menimpa perubahan admin (ON CONFLICT DO NOTHING).
--
-- Daftar kategori (organik/anorganik/b3/daur_ulang) tetap di check
-- constraint waste_logs + enum kode; yang bisa diubah admin adalah
-- bonus poin tiap kategori (berlaku live via AppConfig).

insert into public.app_settings (key, value, description) values
  ('bonus_organik', '0', 'Bonus poin kategori organik.'),
  ('bonus_anorganik', '5', 'Bonus poin kategori anorganik.'),
  ('bonus_daur_ulang', '10', 'Bonus poin kategori daur ulang.'),
  ('bonus_b3', '15', 'Bonus poin kategori B3.')
on conflict (key) do nothing;
