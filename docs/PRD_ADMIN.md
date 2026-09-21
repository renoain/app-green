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

1. User buka app, splash.
2. Login (email/username + password, atau Google).
3. App ambil role dari tabel `profiles`.
4. Redirect:
   - user -> `/home`
   - petugas -> `/admin/waste-verification`
   - admin -> `/admin/dashboard`

Admin tidak melihat Home user. Admin punya layout sendiri.

---

## 5. Layout Admin

Admin memakai **drawer** (sidebar) sebagai navigasi utama, bukan bottom nav, karena menu admin lebih banyak dan lebih cocok untuk operasional. Tombol back di root branch perlu ditekan 2 kali dalam 2 detik untuk keluar aplikasi (seperti tab Beranda user); di sub-route (form/detail) back berjalan normal.

Drawer berisi:

- Dashboard
- Kelola TPS
- Verifikasi Waste
- Kelola Reward
- Kelola User
- Pengaturan
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
- Grafik sederhana (opsional, fase 2).

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
- Ambil lokasi dari GPS admin saat tambah/edit.
- Pilih wilayah berjenjang: Provinsi -> Kota/Kabupaten -> Kecamatan (dengan search).
- Wilayah otomatis terisi dari GPS/peta (reverse-geocode Nominatim) lalu kode TPS tergenerate.
- Generate kode TPS otomatis format <KOTA>-<KEC>-<NOMOR> (mis. SBY-KTT-01) dari kecamatan terpilih + nomor urut se-wilayah.
- Kolom QR disembunyikan sementara, menyusul fase berikut (qr_code tetap tersimpan otomatis CP-XXX).
- Tampilkan QR code (untuk dicetak/ditempel di TPS).

Form tambah/edit:

- Provinsi (wajib, dropdown + search, otomatis dari lokasi bila cocok).
- Kota/Kabupaten (wajib, terfilter dari provinsi, dropdown + search).
- Kecamatan (wajib, terfilter dari kota, dropdown + search).
- Kode TPS (otomatis, unik, preview sebelum simpan).
- Kelurahan (opsional).
- Deskripsi lokasi (wajib, manual, menjelaskan titik spesifik TPS).
- Alamat (opsional).
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

### 6.4 Kelola Reward (Fase 2)

Fitur:

- List reward.
- Tambah/edit/hapus reward.
- Update stok.
- Aktif/nonaktif reward.

### 6.5 Kelola User (Fase 2)

Fitur:

- List user.
- Filter by role.
- Ubah role user (user/petugas/admin).
- Lihat detail user (profil, total poin, riwayat waste).

### 6.6 Pengaturan (Fase 2)

Fitur:

- Radius default checkpoint.
- Rate limit waste per hari.
- Kategori sampah (tambah/edit).
- Konfigurasi anti-kecurangan.

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
admin_waste_verification_page.dart
admin_reward_page.dart
admin_user_page.dart
widgets/
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
| `/admin/users`                  | Kelola User      |
| `/admin/settings`               | Pengaturan       |

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

### Fase 2

5. Kelola reward.
6. Kelola user.
7. Pengaturan.
8. Statistik dan grafik.
9. Audit log.

---

## 12. Yang Tidak Termasuk

- Dashboard web terpisah (fase 3+).
- Multi-tenant / multi-organisasi.
- Role custom selain user, petugas, admin.
- Approval berjenjang.

---

## 13. Status dan Riwayat

- Status: In Progress (MVP: shell, dasbor, kelola TPS, verifikasi waste).
- 2026-09-20: Dokumen dibuat manual oleh owner.
- 2026-09-20: Implementasi MVP selesai (fase 2: reward, user, pengaturan).
- 2026-09-21: Section 6.2 diperbarui (filter + dropdown wilayah berjenjang, kode TPS otomatis KOTA-KEC-NOMOR, kolom code terpisah dari qr_code).
- 2026-09-21: Double-back keluar di AdminShell; wilayah + kode otomatis dari GPS/peta; Nama jadi Deskripsi; QR disembunyikan sementara.
- Menunggu review dan uji device fisik.
- Setelah disetujui, masuk ke pengembangan fase 2.
