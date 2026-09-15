# PROTOCOL.md - Go Green

Protokol kickoff project Go Green. Wajib dibaca oleh agent/developer sebelum
bekerja di project ini. Semua aturan di sini mengikat selama project berjalan.

## Cara Pakai Protokol

- Protokol ini adalah "konstitusi" project. Aturan apa pun yang berbenturan
  dengan file ini harus dimenangkan oleh protokol.
- Baca protokol ini (atau bagian yang relevan) sebelum memulai task baru.
- Bagian A adalah master prompt. Bagian B hingga O adalah detail per topik.

---

## Bagian A: MASTER PROMPT

### Fase 0 - Kickoff & Keputusan

- Komunikasikan produk, fitur MVP, dan anti-kecurangan. Lihat PROTOCOL.md dan
  docs/PROJECT_OVERVIEW.md.
- Lakukan keputusan arsitektur (stack, struktur folder, state management).
- Buat AGENTS.md, PROTOCOL.md, CHANGELOG.md, docs/*, .opencode/*.

### Fase 1 - Setup Project

- Setup Flutter project, pubspec.yaml, analysis_options.yaml, aset, environment.
- Struktur folder feature-first: lib/core + lib/features/<fitur>.

### Fase 2 - Fondasi Coding

- Core: theme, constants, utils, router, services.
- Main.dart: inisialisasi, tema, router, splash page.

### Fase 3 - Fitur MVP

- Fitur: Splash, Onboarding, Auth, Home, Buang Sampah, Poin & Reward,
  Aktivitas, Artikel, Profile, Scan QR, Verifikasi.
- Gunakan skill create-feature dan create-screen untuk fitur baru.

### Aturan Umum

- Bahasa komunikasi: Bahasa Indonesia. Kode: Bahasa Inggris.
- Dilarang emoji di kode, komentar, dokumentasi, commit.
- Jangan menulis secret di kode/log/docs. Pakai .env, commit hanya .env.example.
- Tanya sebelum berasumsi pada keputusan penting.
- Update CHANGELOG.md di paling atas setiap task selesai.
- Jalankan flutter analyze dan flutter test sebelum task dianggap selesai.

---

## Bagian B: Template Dokumen Wajib per Project

Setiap project wajib memiliki dokumen berikut di folder docs/:

- PROJECT_OVERVIEW.md - deskripsi, target user, masalah, solusi, scope, bisnis.
- ARCHITECTURE.md - stack, layer, struktur folder, aturan coding.
- DESIGN_SYSTEM.md - token warna, tipografi, spacing, radius, elevation.
- UI_PAGES.md - daftar halaman, tujuan, elemen, navigasi.
- COMPONENT_LIBRARY.md - daftar komponen reusable.
- GLOSSARY.md - kamus istilah domain.
- TESTING_STRATEGY.md - framework, scope, target coverage.
- ASSET_MANAGEMENT.md - struktur dan aturan aset.
- SECURITY_AND_VALIDATION.md - anti-kecurangan dan validasi data.

Selain itu di root: AGENTS.md, PROTOCOL.md, CHANGELOG.md, README.md.

---

## Bagian C: Kriteria Pemilihan Library/Framework

Setiap dependency baru wajib lolos checklist berikut:

1. Tujuan jelas: masalah apa yang diselesaikan?
2. Alternatif: minimal 1 alternatif lain dievaluasi dan ditulis di CHANGELOG
   dan ARCHITECTURE.
3. Pemeliharaan: tidak lebih dari 12 bulan tanpa rilis.
4. Lisensi: aman untuk dipakai (MIT/Apache/BSD preferred).
5. Kompatibilitas: versi cocok dengan Flutter/Dart SDK project.
6. Ukuran: tidak membawa beban berlebih ke ukuran bundle.
7. Dokumentasi: cukup untuk dipakai tim.

Vote: setuju / tidak setuju + alasan. Jika menolak, tulis alasan di CHANGELOG.

---

## Bagian D: Format CHANGELOG.md & LOGS.md

### CHANGELOG.md

```markdown
# CHANGELOG - Go Green

## [YYYY-MM-DD] - Nama Task

Status: Selesai / Sedang dikerjakan / Dibatalkan

File yang diubah:
- path/file.ext (dibuat / diedit / dihapus)

Catatan:
- catatan singkat (opsional)

Verifikasi:
- hasil linter/analyze: OK / warning / error
- hasil test: OK / gagal / belum ditest
```

Aturan:
- Entri baru di paling atas. Dilarang mengubah/menghapus entri lama.
- Tanpa emoji. Isi hanya yang benar-benar dikerjakan.
- Task yang mengubah struktur folder, token, arsitektur, atau stack WAJIB
  ikut memperbarui docs terkait pada task yang sama.

### LOGS.md

- LOGS.md (jika ada) mencatat keputusan teknis penting: keputusan + alasan +
  konsekuensi. Format bebas tetapi harus ada tanggal.

---

## Bagian E: Checklist Anti-AI-Slop (UI)

- Maksimal 3 warna dominan per halaman.
- Tidak ada gradient mencolok/formless.
- Tidak ada shadow blur besar.
- Border radius wajar (pakai token AppRadius).
- Tipografi konsisten (pakai token AppTypography).
- Spacing kelipatan 4 (pakai token AppSpacing).
- Tidak ada ikon tak jelas / icon gunung-aesthetic yang tidak perlu.
- Setiap elemen punya hierarki visual yang jelas.
- Empty state, loading, dan error state selalu dipertimbangkan.

---

## Bagian F: Alur Desain ke Kode

1. Terima desain (Figma/external). Simpan referensi di docs/DESIGN_BRIEF.md.
2. Pastikan token (warna/tipografi/spacing/radius) sudah ada di
   docs/DESIGN_SYSTEM.md. Jika belum, tambahkan ke dokumen dulu.
3. Implementasikan sebagai widget yang memakai token.
4. Komponen yang dipakai di banyak halaman masuk COMPONENT_LIBRARY.md.
5. Validasi UI terhadap checklist anti-AI-slop (Bagian E).
6. Screenshot per halaman sebagai bukti verifikasi.

---

## Bagian G: Manajemen Aset

- Struktur folder aset: lihat docs/ASSET_MANAGEMENT.md.
- Format: SVG/PNG untuk icon dan image, TTF/WOFF untuk font.
- Penamaan file: snake_case. Icon custom diawali prefix sesuai kategori.
- Setiap aset baru wajib dideklarasikan di pubspec.yaml jika belum tercakup.
- Path aset direferensikan lewat konstanta di lib/core/constants/app_assets.dart,
  dilarang hardcode path di widget.

---

## Bagian H: Anti-Kecurangan & Validasi Data

Level validasi (lihat docs/SECURITY_AND_VALIDATION.md):

- Dasar: kamera in-app, timestamp server, GPS radius, hash SHA-256.
- Menengah: EXIF check, ELA, duplicate detection, rate limit.
- Lanjutan: AI forensics (Hive, Sightengine), approval manual.

Aturan:
- Foto bukti wajib dari kamera in-app, bukan galeri.
- Timestamp wajib dari server, bukan waktu device.
- Hash file (SHA-256) wajib disimpan dan dicek duplikat.
- GPS radius checkpoint wajib dicek sebelum upload.

---

## Bagian I: Format Commit Git

Format: `<type>(<scope>): <subject>`

Type: feat, fix, docs, refactor, chore, test, style.
Scope: singkatan fitur (auth, home, waste, points, activity, article, profile,
core, infra, docs).

Contoh:

- `feat(auth): add login flow with validation`
- `fix(waste): correct gps radius check`
- `docs(core): update design system tokens`

Aturan:
- Subject <= 72 karakter, imperatif, tanpa emoji, Bahasa Inggris.
- Pesan commit dalam Bahasa Inggris. Komunikasi diskusi Bahasa Indonesia.

---

## Bagian J: Error Handling & Logging

- Error handling: tangkap error di service/domain, tampilkan pesan ramah
  Bahasa Indonesia di UI.
- Jangan biarkan error mentah muncul ke user.
- Logging: pakai package logger (lihat lib/core/utils/logger.dart).
- Dilarang print() di produksi.
- Dilarang log data sensitif (token, password, foto).
- Batasi log pada konteks yang perlu debugging.

---

## Bagian K: Versioning & Rilis

- Versi mengikuti semver: MAJOR.MINOR.PATCH (lihat pubspec version).
- Rilis: update CHANGELOG, bump version di pubspec.yaml, tag git
  `v<version>`.
- Rilis MVP: v0.1.0. Fase lanjut: v0.2.0+.
- Setiap rilis wajib lolos flutter analyze dan flutter test.

---

## Bagian L: Checklist Verifikasi per Task

Setiap task selesai wajib dicek:

- flutter analyze: 0 error, 0 warning (atau minimal tidak bertambah).
- flutter test: semua pass.
- CHANGELOG.md updated di paling atas.
- Docs terkait diperbarui jika ada perubahan
  struktur/token/arsitektur/stack.
- String UI Bahasa Indonesia. Kode Bahasa Inggris. Tidak ada emoji.
- Tidak ada hardcode warna/spacing/radius/string yang seharusnya token.
- Tidak ada secret tercommit.

---

## Bagian M: Anti-AI-Slop untuk Kode

- Setiap file .dart wajib punya header komentar singkat (tujuan file).
- Setiap class wajib punya doc comment singkat.
- Dilarang kode hasil generate yang tidak dipahami.
- Dilarang komentar bertele-tele / menjelaskan yang sudah jelas.
- Dilarang duplikasi kode; wajib di-refactor ke fungsi/class.
- Dilarang hardcode nilai ajaib yang seharusnya konstanta.
- Kode harus mengikuti layering; dilarang logic bisnis di widget.

---

## Bagian N: Handoff & State

- Setelah task selesai, laporkan: file dibuat/ubah, hasil pub get, hasil
  analyze, hasil test, error tersisa, rekomendasi langkah berikutnya.
- Tunggu konfirmasi sebelum lanjut ke task berikutnya.
- Jangan menambah scope di luar task yang diminta.
- State project selalu dicatat di docs/PROJECT_OVERVIEW.md.

---

## Bagian O: Aturan Dependency Baru

- Dependency baru hanya boleh ditambah setelah lolos Bagian C.
- Dependency wajib dicatat di CHANGELOG dengan alasan pemakaian.
- Dependency wajib dicatat di docs/ARCHITECTURE.md.
- Jika dependency diganti, update ketiga dokumen tersebut.
- Dependency yang tidak aktif dipelihara DILARANG dipakai.