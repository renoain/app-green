# AGENTS.md - Go Green

File instruksi utama untuk AI/agent (OpenCode, Cursor, GitHub Copilot, dll).
Wajib dibaca sebelum menulis kode atau membuat file.

## 1. Konteks Produk

Go Green adalah aplikasi mobile pengelolaan sampah rumah tangga dengan
sistem poin dan reward.

Fitur utama:

- Buang sampah ke checkpoint, dapat poin.
- Poin ditukar reward (sembako, voucher, e-wallet, donasi).
- Bukti foto anti-edit (kamera in-app, timestamp server, GPS radius,
  hash SHA-256).
- Edukasi via artikel.

Target user: warga urban (18-45 tahun) yang sadar lingkungan, komunitas
RT/RW, pemerintah daerah / bank sampah.

## 2. Wajib Baca Sebelum Coding

- AGENTS.md (file ini)
- PROTOCOL.md
- docs/PROJECT_OVERVIEW.md
- docs/ARCHITECTURE.md
- docs/DESIGN_SYSTEM.md
- docs/UI_PAGES.md
- docs/COMPONENT_LIBRARY.md
- docs/GLOSSARY.md
- docs/TESTING_STRATEGY.md
- docs/ASSET_MANAGEMENT.md
- docs/SECURITY_AND_VALIDATION.md
- CHANGELOG.md

## 3. Rules Modular

Aturan detail ada di folder .opencode/rules/. Wajib dibaca sesuai konteks:

- .opencode/rules/01-core.md - aturan umum, bahasa, secret, git
- .opencode/rules/02-coding.md - konvensi kode, layer, naming
- .opencode/rules/03-design.md - token, anti-AI-slop, icon
- .opencode/rules/04-docs.md - aturan dokumentasi & CHANGELOG
- .opencode/rules/05-security.md - anti-kecurangan, data sensitif
- .opencode/rules/06-testing.md - verifikasi wajib, testing

## 4. Skills Tersedia

Skill bisa dipanggil dengan menyebut namanya. Lihat .opencode/skills/:

- setup-foundation - setup awal project dari 0
- create-feature - buat fitur baru lengkap
- create-screen - buat halaman UI baru
- create-component - buat komponen reusable baru
- update-changelog - update CHANGELOG sesuai format wajib
- verify-task - jalankan checklist verifikasi sebelum task selesai
- setup-supabase - setup Supabase (auth, database, storage)

## 5. Agents Tersedia

- design-reviewer - review UI terhadap DESIGN_SYSTEM.md
- security-auditor - audit anti-kecurangan & data sensitif
- doc-writer - tulis/perbarui dokumentasi

## 6. Commands Tersedia

- /new-feature - mulai fitur baru
- /new-screen - mulai halaman baru
- /release - siapkan rilis

## 7. Aturan Cepat

- Komunikasi dalam Bahasa Indonesia.
- Nama variabel/class/file/folder dalam Bahasa Inggris.
- String UI dalam Bahasa Indonesia.
- Dilarang emoji di kode, komentar, dokumentasi, commit.
- Dilarang hardcode warna/spacing/radius, wajib pakai token di
  lib/core/theme/.
- Dilarang menulis secret, wajib lewat .env.
- Setiap task selesai WAJIB update CHANGELOG.md di paling atas.
- Task yang mengubah struktur/token/arsitektur WAJIB update docs terkait
  pada task yang sama.
- Ikuti PROTOCOL.md untuk alur kerja.
- Ada keputusan penting atau konflik? Tanyakan dulu, jangan berasumsi.

## 8. Tech Stack

- Framework: Flutter
- Bahasa: Dart
- State management: Riverpod
- Routing: go_router
- HTTP: dio
- Backend/BaaS: Supabase
- Database: PostgreSQL (via Supabase)
- Storage: Supabase Storage
- Auth: Supabase Auth
- Icon: lucide_icons + flutter_svg
- Font: Manrope + Geist
- Kamera: camera
- GPS: geolocator
- Hash: crypto (SHA-256)
- EXIF: exif
- QR scan: mobile_scanner
- Permission: permission_handler
- Logger: logger
- Local storage: shared_preferences + hive
- Testing: flutter_test + mocktail

## 9. Arsitektur Singkat

- Layer: presentation, domain, data.
- Logic bisnis di domain (usecase/service), bukan di widget.
- Akses data di data (repository/datasource).
- Widget hanya memanggil provider/notifier.
- Provider didefinisikan per fitur di presentation/providers/.
- Route di lib/core/router/app_router.dart.
- Token di lib/core/theme/.
- Konstanta di lib/core/constants/.
- Service di lib/core/services/.
- Utility di lib/core/utils/.
- Widget global di lib/core/widgets/.

## 10. Alur Kerja

1. Sebelum menulis kode, baca AGENTS.md, PROTOCOL.md, dan docs terkait.
2. Untuk fitur baru, panggil skill create-feature.
3. Untuk halaman baru, panggil skill create-screen.
4. Untuk komponen baru, panggil skill create-component.
5. Setelah selesai, panggil skill verify-task.
6. Update CHANGELOG.md dengan skill update-changelog.
7. Laporkan ke user: file yang dibuat/diubah, hasil verifikasi,
   rekomendasi task selanjutnya.

## 11. Aturan Verifikasi

Sebelum task dianggap selesai:

1. flutter analyze - OK / warning / error.
2. flutter test - OK / gagal / belum ditest.
3. Task UI: screenshot terlampir.
4. Task kamera/GPS: dites di device fisik.
5. CHANGELOG.md terupdate di paling atas.
6. Docs terkait terupdate jika ada perubahan struktur/token/arsitektur.
7. Tidak ada hardcode warna/spacing/radius.
8. Tidak ada logic bisnis di widget.
9. Tidak ada secret di kode.
10. Tidak ada emoji di kode/docs.
11. Dependency baru sudah dievaluasi (jika ada).

## 12. Aturan Security

Anti-kecurangan level dasar (MVP):

1. Kamera in-app
   - Foto bukti WAJIB dari kamera in-app, bukan galeri.
2. Timestamp server
   - Timestamp WAJIB dari server, bukan waktu device.
3. GPS radius
   - GPS radius checkpoint WAJIB dicek sebelum upload.
   - Radius default: 100 meter.
4. Hash file
   - Hash SHA-256 WAJIB dihitung dan disimpan.
   - Cek duplikat hash sebelum simpan.

Level lanjutan (fase 2+):

- EXIF check, ELA, duplicate detection, approval manual, AI forensics.

Data sensitif:

- Dilarang log data sensitif.
- Dilarang commit .env.
- Semua secret di .env.

## 13. Aturan Dependency Baru

- Setiap penambahan dependency wajib dievaluasi dengan checklist di
  PROTOCOL.md Bagian C.
- Wajib dicatat di CHANGELOG dan docs/ARCHITECTURE.md dengan alasan.
- Wajib ada minimal 1 alternatif yang dievaluasi.
- Dependency yang tidak aktif dipelihara (di atas 12 bulan tanpa rilis)
  DILARANG dipakai.
- Dependency dengan lisensi tidak aman DILARANG dipakai.
