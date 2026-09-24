# PRD ADMIN - Go Green

Product Requirements Document untuk fitur admin di aplikasi Go Green.

Versi: 1.0
Terakhir update: 2026-09-20
Status: In Progress

---

## 1. Latar Belakang

Aplikasi Go Green punya dua tipe pengguna utama:

- User biasa: buang sampah, dapat poin, tukar reward.
- Admin: mengelola data master (TPS, reward, user) dan memverifikasi bukti pembuangan.

Saat ini, admin mengelola data lewat Supabase Table Editor / SQL Editor. Cara ini tidak praktis untuk operasional harian. Admin butuh antarmuka khusus di dalam aplikasi.

---

## 2. Tujuan

Menyediakan antarmuka admin di dalam aplikasi Go Green, dengan ketentuan:

1. Satu aplikasi, dua pengalaman: user dan admin.
2. Setelah login, admin langsung diarahkan ke Dashboard Admin (bukan Home user).
3. UI admin terpisah total dari UI user.
4. Admin bisa mengelola TPS, verifikasi waste, kelola reward, kelola user.
5. Admin bisa mengakses dari HP (mobile), termasuk tambah TPS dari lokasi.

---

## 3. Peran (Role)

| Role    | Akses                                                                                              |
| ------- | -------------------------------------------------------------------------------------------------- |
| user    | Fitur user: Home, Buang Sampah, Poin, Artikel, Profile                                             |
| petugas | Fitur admin terbatas: Verifikasi Waste, Kelola TPS (tambah saja)                                   |
| admin   | Semua fitur admin: Dashboard, Kelola TPS, Verifikasi Waste, Kelola Reward, Kelola User, Pengaturan |

Setelah login:

- role == user -> MainShell (UI user).
- role == petugas -> AdminShell (menu terbatas).
- role == admin -> AdminShell (menu lengkap).

---

## 4. Alur Masuk Admin

1. User buka app, splash (sesi tersimpan langsung ke dasbor sesuai role).
2. Login (email/username + password, atau Google).
3. App ambil role dari tabel `profiles`.
4. Redirect:
   - user -> `/home`
   - petugas -> `/admin/waste-verification`
   - admin -> `/admin/dashboard`

Admin tidak melihat Home user. Admin punya layout sendiri.

---

## 5. Layout Admin

Admin memakai **drawer** (sidebar) sebagai navigasi utama, bukan bottom nav, karena menu admin lebih banyak dan lebih cocok untuk operasional. Tombol back di root branch sekali tekan langsung kembali ke UI user (/profile); di sub-route (form/detail) back berjalan normal (pop). Masuk admin selalu via go (bukan push) agar tidak menumpuk shell.

Drawer berisi (admin penuh; petugas hanya 3 pertama):

- Dashboard
- Kelola TPS
- Verifikasi Waste
- Kelola Reward
- Kelola User
- Pengaturan
- Log Audit
- Logout

Header admin menampilkan: nama admin, role, tombol logout.

---

## 6. Halaman Admin (MVP)

### 6.1 Dashboard Admin

Ringkasan:

- Total user terdaftar.
- Total TPS terdaftar.
- Total waste log hari ini.
- Total waste log pending verifikasi.
- Total poin beredar.
- Grafik batang setoran 7 hari terakhir (tanpa dependency baru).

Aksi cepat:

- Tombol "Tambah TPS".
- Tombol "Lihat Verifikasi Pending".

### 6.2 Kelola TPS

Fitur:

- List semua checkpoint (nama, kode TPS, alamat, radius, QR code, status aktif).
- Filter list by Provinsi, Kota/Kabupaten, Kecamatan.
- Search by nama atau kode TPS.
- Tambah checkpoint baru.
- Edit checkpoint.
- Nonaktifkan checkpoint (soft delete).
- Ambil lokasi dari GPS admin saat tambah/edit (minta hidupkan GPS bila
  mati, arahkan ke pengaturan bila izin ditolak permanen).
- Pilih titik di peta layar penuh (pin tengah, geser peta atau ketuk,
  tombol lokasi saya, konfirmasi Gunakan lokasi ini).
- Pilih wilayah berjenjang: Provinsi -> Kota/Kabupaten -> Kecamatan (dengan search).
- Wilayah + kelurahan + alamat lengkap otomatis terisi dari GPS/peta
  (reverse-geocode Nominatim) lalu kode TPS tergenerate.
- Generate kode TPS otomatis format <KOTA>-<KEC>-<NOMOR> (mis. SBY-KTT-01) dari kecamatan terpilih + nomor urut se-wilayah.
- QR code tampil lagi: pratinjau di form + tombol QR di kartu membuka dialog gambar untuk dicetak/ditempel di TPS (qr_code otomatis CP-XXX).

Form tambah/edit:

- Provinsi (wajib, dropdown + search, otomatis dari lokasi bila cocok).
- Kota/Kabupaten (wajib, terfilter dari provinsi, dropdown + search).
- Kecamatan (wajib, terfilter dari kota, dropdown + search).
- Kode TPS (otomatis, unik, preview sebelum simpan).
- Kelurahan (otomatis dari lokasi, bisa diubah).
- Deskripsi lokasi (wajib, manual, menjelaskan titik spesifik TPS).
- Alamat lengkap (otomatis dari lokasi, bisa diubah).
- Latitude (wajib, bisa dari GPS).
- Longitude (wajib, bisa dari GPS).
- Radius (default 100 m, bisa diubah).
- QR code (otomatis, unik).
- Status aktif (default true).

### 6.3 Verifikasi Waste

Fitur:

- List waste_logs dengan status `pending`.
- Filter: hari ini, 7 hari, semua.
- Detail waste log:
  - Foto bukti.
  - Timestamp server.
  - Lokasi (lat/lng).
  - Jarak ke checkpoint.
  - Hash SHA-256.
  - Kategori sampah.
  - User yang submit.
- Aksi: Approve / Reject.
- Alasan reject (opsional).

Setelah approve:

- Update status waste_log menjadi `verified`.
- Insert ke `points` (earn) sesuai perhitungan.
- Update `verified_by`, `verified_at`.

Setelah reject:

- Update status waste_log menjadi `rejected`.
- Catat alasan di `notes`.

### 6.4 Kelola Reward (Selesai baca + tulis)

Fitur:

- List semua reward (aktif + nonaktif).
- Tambah/edit/hapus reward via form (/admin/rewards/new, /admin/rewards/:id/edit).
- Update stok via form.
- Aktif/nonaktif via switch (langsung tersimpan).

### 6.5 Kelola User (Selesai baca + tulis role)

Fitur:

- List user (limit 50, terbaru di atas).
- Cari nama/email + filter by role (Semua/User/Petugas/Admin).
- Ubah role user (user/petugas/admin) via detail; cegah self-demote
  (migration 018 policy profiles_update_role_admin, push manual).
- Lihat detail user (profil, total poin via points, 10 riwayat waste).

### 6.6 Pengaturan (Selesai tulis; kategori fase lanjut)

Fitur:

- Radius default checkpoint (10-1000 m, jadi default form TPS baru).
- Rate limit waste per hari (1-20, ditegakkan ValidatePhotoUsecase).
- Penegakan blokir radius GPS on/off (waste/capture/validasi).
- Target misi mingguan (1-30) + foto maksimal (1-10 MB).
- Nilai dari tabel app_settings (migration 019, push manual),
  dimuat saat splash best effort, fallback AppValues bila offline.
- Kategori sampah (tambah/edit) menyusul fase lanjut (enum + bonus
  poin masih di kode).

---

## 7. RLS dan Hak Akses

RLS di Supabase sudah mengizinkan admin:

- `checkpoints`: admin manage.
- `waste_logs`: admin read/update.
- `rewards`: admin manage.
- `profiles`: admin read all.
- `points`: admin read all.

Petugas hanya boleh:

- `waste_logs`: read/update (verifikasi).
- `checkpoints`: read (tidak boleh manage).

**Perlu update RLS** kalau petugas juga boleh tambah TPS.

---

## 8. Struktur Folder

lib/features/admin/
data/
datasources/
models/
repositories/
domain/
entities/
repositories/
usecases/
presentation/
admin_shell.dart
pages/
admin_dashboard_page.dart
admin_checkpoint_page.dart
admin_checkpoint_form_page.dart
admin_map_picker_page.dart
admin_waste_verification_page.dart
admin_reward_page.dart
admin_user_page.dart
widgets/
location_ready.dart
providers/

text

---

## 9. Route Admin

| Route                           | Halaman          |
| ------------------------------- | ---------------- |
| `/admin/dashboard`              | Dashboard        |
| `/admin/checkpoints`            | Kelola TPS       |
| `/admin/checkpoints/new`        | Tambah TPS       |
| `/admin/checkpoints/:id/edit`   | Edit TPS         |
| `/admin/waste-verification`     | Verifikasi Waste |
| `/admin/waste-verification/:id` | Detail Waste     |
| `/admin/rewards`                | Kelola Reward    |
| `/admin/rewards/new`            | Tambah Reward    |
| `/admin/rewards/:id/edit`       | Ubah Reward      |
| `/admin/users`                  | Kelola User      |
| `/admin/users/:id`              | Detail User      |
| `/admin/settings`               | Pengaturan       |
| `/admin/audit-logs`             | Log Audit        |

---

## 10. Non-Functional Requirements

- Bahasa UI: Indonesia.
- Icon: Lucide.
- Token: design system (AppColors, AppTypography, AppSpacing, dll).
- Mobile-first (bisa dipakai di HP).
- Tidak hardcode warna/spacing/radius.
- Setiap aksi admin dicatat di log (fase 2).

---

## 11. Prioritas

### MVP

1. Admin shell + drawer.
2. Dashboard admin.
3. Kelola TPS (list, tambah, edit, nonaktif).
4. Verifikasi waste (list, detail, approve, reject).

### Fase 2 (5-9 selesai; tersisa kategori, QR TPS, soft-delete)

5. Kelola reward (selesai tulis).
6. Kelola user (selesai tulis role).
7. Pengaturan (selesai tulis; kategori fase lanjut).
8. Statistik dan grafik (selesai batang 7 hari).
9. Audit log (selesai tabel + hooks + daftar).

---

## 12. Yang Tidak Termasuk

- Dashboard web terpisah (fase 3+).
- Multi-tenant / multi-organisasi.
- Role custom selain user, petugas, admin.
- Approval berjenjang.

---

## 13. Status dan Riwayat

- Status: In Progress (MVP admin selesai fungsional; tersisa kategori sampah, QR TPS, soft-delete TPS).
- 2026-09-20: Dokumen dibuat manual oleh owner.
- 2026-09-20: Implementasi MVP selesai (fase 2: reward, user, pengaturan).
- 2026-09-21: Section 6.2 diperbarui (filter + dropdown wilayah berjenjang, kode TPS otomatis KOTA-KEC-NOMOR, kolom code terpisah dari qr_code).
- 2026-09-21: Double-back keluar di AdminShell; wilayah + kode otomatis dari GPS/peta; Nama jadi Deskripsi; QR disembunyikan sementara.
- 2026-09-21: Dialog hidupkan GPS + izin lokasi; peta layar penuh pin geser; autofill kecamatan/kelurahan/alamat lengkap/kode TPS.
- 2026-09-21: Masuk admin via go + kunci Scaffold per-instance (perbaiki layar merah); back root sekali ke /profile; splash redirect sesi sesuai role; retry+timeout API wilayah (522).
- 2026-09-22: Reward/user/pengaturan jadi daftar real baca (skeleton + refresh); tulis (tambah/ubah role) tetap fase 2.
- 2026-09-22: Nav ganda uji coba (drawer usap tepi + navbar 3 item + sheet usap-atas) dengan flag AppValues; Mode Pengguna khusus role admin via go.
- 2026-09-23: Kelola Reward tulis selesai (tambah/ubah/hapus/stok/aktif via form + switch + konfirmasi, RLS admin); user/pengaturan tulis tetap fase 2.
- 2026-09-23: Kelola User tulis selesai (cari/filter role/detail poin+riwayat/ubah role + cegah self-demote, migration 018 profiles_update_role_admin + rewards_select_all_admin); pengaturan tulis tetap fase 2.
- 2026-09-23: Pengaturan tulis selesai (tabel app_settings migration 019 + form validasi + AppConfig runtime + wiring radius/batas/target/foto + load splash); kategori sampah fase lanjut.
- 2026-09-23: Grafik dasbor selesai (batang 7 hari via bucket domain + Container, tanpa dependency baru); tersisa audit log + kategori + QR TPS + soft-delete.
- 2026-09-23: Audit log selesai (tabel admin_audit_logs migration 020 append-only + hooks 5 notifier best effort + halaman daftar + menu drawer); tersisa kategori + QR TPS + soft-delete.
- Menunggu review dan uji device fisik.
- Setelah disetujui, masuk ke pengembangan fase 2.
