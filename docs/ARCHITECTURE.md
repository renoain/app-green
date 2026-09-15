# ARCHITECTURE - Go Green

Dokumen arsitektur project. Sumber kebenaran untuk keputusan struktur,
layer, dan aturan dependency.

---

## 1. Stack Teknologi

### 1.1 Frontend

| Komponen         | Pilihan                    | Alasan                                                     | Alternatif                        |
| ---------------- | -------------------------- | ---------------------------------------------------------- | --------------------------------- |
| Framework        | Flutter                    | Cross-platform, konsisten UI, ekosistem matang, hot reload | React Native, Kotlin/Swift native |
| Bahasa           | Dart                       | Wajib untuk Flutter                                        | TypeScript, Kotlin                |
| State management | Riverpod                   | Modern, testable, compile-safe, komunitas besar            | Bloc, Provider                    |
| Routing          | go_router                  | Resmi Flutter team, deklaratif, deep link support          | auto_route                        |
| HTTP client      | dio                        | Fitur lengkap (interceptor, cancel, form data)             | http                              |
| Form             | reactive_forms             | Reactive, validasi terstruktur                             | flutter_form_builder              |
| Icon             | flutter_lucide + flutter_svg | Konsisten, open source, line-art, aktif dipelihara (terbit 2026-09) | lucide_icons (rusak di Flutter 3.47, IconData final class), phosphor_flutter, heroicons |
| Font             | Manrope + Geist            | Sesuai DESIGN_SYSTEM.md                                    | Plus Jakarta Sans, Inter          |

### 1.2 Backend

| Komponen | Pilihan                   | Alasan                                           | Alternatif         |
| -------- | ------------------------- | ------------------------------------------------ | ------------------ |
| BaaS     | Supabase                  | PostgreSQL, auth, storage, realtime, gratis, RLS | Firebase, Appwrite |
| Database | PostgreSQL (via Supabase) | Relasional, cocok untuk data transaksional       | Firestore          |
| Storage  | Supabase Storage          | Terintegrasi, private bucket                     | S3, Cloudinary     |
| Auth     | Supabase Auth             | Email/password + Google OAuth                    | Firebase Auth      |

### 1.3 Device & Media

| Komponen   | Pilihan            | Alasan                     | Alternatif                            |
| ---------- | ------------------ | -------------------------- | ------------------------------------- |
| Kamera     | camera             | In-app only, kontrol penuh | image_picker (tidak bisa in-app only) |
| GPS        | geolocator         | Standar Flutter, akurat    | location                              |
| QR scan    | mobile_scanner     | Modern, aktif dipelihara   | qr_code_scanner                       |
| Permission | permission_handler | Standar Flutter            | -                                     |

### 1.4 Keamanan & Hash

| Komponen     | Pilihan       | Alasan                             | Alternatif |
| ------------ | ------------- | ---------------------------------- | ---------- |
| Hash         | crypto        | SHA-256, standar                   | -          |
| EXIF         | exif          | Baca metadata foto                 | -          |
| AI Forensics | TBD (fase 2+) | Hive, Sightengine, AWS Rekognition | -          |

### 1.5 Utility

| Komponen         | Pilihan                     | Alasan                    | Alternatif         |
| ---------------- | --------------------------- | ------------------------- | ------------------ |
| Logger           | logger                      | Sesuai Bagian J protokol  | -                  |
| Local storage    | shared_preferences + hive   | Simple + terstruktur      | -                  |
| Formatter/Linter | dart format + flutter_lints | Standar Flutter           | very_good_analysis |
| Testing          | flutter_test + mocktail     | Standar Flutter + mocking | mockito            |

### 1.6 DevOps

| Komponen        | Pilihan                      | Alasan  |
| --------------- | ---------------------------- | ------- |
| Version control | Git                          | Standar |
| CI/CD           | TBD                          | Fase 2+ |
| Release         | Play Store / App Store / web | TBD     |

---

## 2. Layer Architecture

Project ini memakai **feature-first + clean architecture** ringan.

### 2.1 Layer

1. **Presentation**
   - Widget, halaman, komponen.
   - State management (Riverpod).
   - Dilarang akses data langsung.
   - Dilarang logic bisnis.

2. **Domain**
   - Entity (model bisnis).
   - Repository interface.
   - Usecase.
   - Tidak boleh depend ke layer data atau presentation.
   - Tidak boleh depend ke Flutter.

3. **Data**
   - Model (extends entity).
   - Datasource (remote, local).
   - Repository implementation.
   - Depend ke domain.

### 2.2 Aturan Dependency

- Presentation -> Domain.
- Data -> Domain.
- Domain -> tidak depend ke siapa pun.
- Dilarang Presentation -> Data langsung.
- Dilarang Domain -> Data atau Presentation.

---

## 3. Struktur Folder

lib/
core/
theme/ # token warna, typography, spacing, radius, elevation
router/ # go_router
constants/ # app_assets, app_strings
utils/ # logger, helpers
widgets/ # widget global reusable (termasuk LoginNoticeCard)
services/ # supabase_service, auth_service, location_service, dll
features/
auth/
data/
datasources/
models/
repositories/
presentation/
pages/ # login_page, register_page
providers/ # auth_provider (authNotifierProvider, AuthSessionState)
pages/
widgets/
providers/
home/
waste/
points/
activity/
article/
profile/
splash/
onboarding/
scan/
verification/
main.dart

text

---

## 4. Routing

- Pakai go_router.
- Semua route didefinisikan di lib/core/router/app_router.dart.
- Dilarang Navigator.push langsung.
- Pakai context.go / context.goNamed / context.push.
- Route awal: /splash.
- Tab utama (home, activity, waste, points, profile) memakai
  StatefulShellRoute.indexedStack agar state tiap tab tersimpan dan
  bottom navigation dipakai bersama lewat MainShell
  (lib/core/widgets/main_shell.dart). Daftar route dipakai oleh test
  melalui konstanta appRoutes.

Daftar route:

- /splash
- /onboarding
- /login
- /register
- /home (tab: home)
- /activity (tab: activity)
- /waste (tab: waste)
- /points (tab: points)
- /profile (tab: profile)
- /article
- /article/:id (detail artikel)
- /reward/:id (detail reward)
- /activity/:id (detail aktivitas)
- /verification (verifikasi bukti)
- /scan (scan QR)
- /capture (kamera in-app, foto bukti)
- /edit-profile (edit profil)
- /settings (pengaturan aplikasi)

---

## 5. Naming Convention

| Item            | Format                                | Contoh               |
| --------------- | ------------------------------------- | -------------------- |
| File            | snake_case.dart                       | home_page.dart       |
| Class           | PascalCase                            | HomePage             |
| Variabel/fungsi | camelCase                             | fetchUserData        |
| Konstanta       | lowerCamelCase / SCREAMING_SNAKE_CASE | appColors / APP_NAME |
| Provider        | camelCase + Provider                  | userProvider         |
| Halaman         | <Nama>Page                            | HomePage             |
| Widget          | <Nama> / <Nama>Widget                 | PointsCard           |
| Entity          | <Nama>                                | User                 |
| Model           | <Nama>Model                           | UserModel            |
| Usecase         | <Verb><Nama>Usecase                   | FetchUserUsecase     |
| Repository      | <Nama>Repository                      | UserRepository       |
| Datasource      | <Nama>DataSource                      | UserRemoteDataSource |

---

## 6. Import Order

1. Dart SDK (dart:...)
2. Package (package:...)
3. Project (relative)

Pisahkan tiap grup dengan baris kosong. Urutkan alfabetis dalam grup.

---

## 7. Error Handling

- Tangkap error di layer data dan domain.
- Gunakan Result/Either pattern atau exception terstruktur.
- Tampilkan pesan ramah Bahasa Indonesia di presentation.
- Log error dengan logger.
- Dilarang print() di produksi.
- Error yang belum tertangani dicatat di CHANGELOG dengan status
  "Sedang dikerjakan".

---

## 8. Aturan Penambahan Dependency Baru

Setiap penambahan dependency wajib:

1. Dievaluasi dengan checklist PROTOCOL.md Bagian C.
2. Dicatat di CHANGELOG dengan alasan.
3. Dicatat di docs/ARCHITECTURE.md dengan alasan.
4. Ada minimal 1 alternatif yang dievaluasi.
5. Lisensi aman (MIT, Apache, BSD).
6. Aktif dipelihara (release di bawah 12 bulan terakhir).

Dependency yang tidak memenuhi syarat DILARANG dipakai.

### 8.1 Evaluasi Dependency Terpasang

flutter_lucide 1.45.0 (menggantikan lucide_icons):

1. Tujuan: menampilkan set ikon line-art Lucide secara konsisten.
2. Alternatif dievaluasi:
   - lucide_icons 0.257.0: TIDAK LOLOS kualifikasi - tidak bisa dikompilasi
     di Dart 3.13/Flutter 3.47.2 karena class IconData menjadi final
     (LucideIconData extends IconData gagal). Rilis terakhir lama, belum
     diperbarui, sehingga ditinggalkan.
   - flutter_lucide 1.45.0: aktif (rilis 2026-09-11), implementasi memakai
     IconData const + bundling font TTF (tidak extends IconData), aman.
   - phosphor_flutter / heroicons: set ikon berbeda, gaya tidak sesuai
     standar design Lucide.
3. Pemeliharaan: aktif, rilis reguler (terakhir 3 hari sebelum pemakaian).
4. Lisensi: ISC (permissive, setara MIT/BSD).
5. Kompatibilitas: SDK >=3.4.3, font TTF internal, teruji di Flutter 3.47.2.
6. Ukuran: satu file font TTF (~100 KB), efek bundle kecil.
7. Dokumentasi: README lengkap, konvensi nama snake_case.

Konsekuensi migrasi: nama ikon berubah dari camelCase (lucide_icons,
contoh shieldCheck) menjadi snake_case (flutter_lucide, contoh
shield_check). Pemakaian ikon sekarang lewat class LucideIcons (nama sama)
dari package:flutter_lucide.

---

### 8.2 Evaluasi Dependency Terpasang (dev)

geolocator_platform_interface 4.3.0 (dev, untuk unit test):

1. Tujuan: fake GeolocatorPlatform agar LocationService dan GeoUtils dapat
   diuji tanpa plugin perangkat di environment test.
2. Alternatif dievaluasi:
   - Mock method channel "flutter.baseflow.com/geolocator": fragile karena
     format argumen/response internal; tidak dipilih.
   - Inject fungsi pengambil posisi secara manual: menyebar dan mengurangi
     kejelasan; tidak dipilih.
3. Pemeliharaan: aktif, dikelola tim geolocator, rilis mengikuti geolocator.
4. Lisensi: MIT.
5. Kompatibilitas: sudah diresolusi sebagai dependency transitif geolocator
   11.1.0; cukup dipindah ke dev_dependencies agar dapat di-import test.

---

## 9. Yang Dilarang

- Logic bisnis di widget.
- Akses data langsung dari widget.
- Hardcode warna, spacing, radius.
- Hardcode string UI di banyak tempat.
- Hardcode path aset.
- print() di produksi.
- Secret di kode.
- Emoji di kode, komentar, dokumentasi.
- Duplikasi widget/komponen.
- Import lintas layer yang melanggar aturan dependency.
- Dependency tanpa evaluasi.

---

## 10. Backend (Supabase) - Status Saat Ini

Status: schema, RLS, dan storage disiapkan sebagai 9 migration berurut
(supabase/migrations/001-009) mengikuti docs/DATABASE_SCHEMA.md sebagai
sumber kebenaran. Email/password auth diaktifkan via dashboard Supabase
(langkah manual). Kredensial dibaca dari .env (gitignored) atau
--dart-define oleh supabase_service.dart; dilarang hardcode secret.
Migration belum dijalankan ke database (dijalankan manual di SQL Editor).

### 10.1 Tabel (lihat migration 001-006, docs/DATABASE_SCHEMA.md)

- profiles (id, email, username, role, created_at) + trigger
  on_auth_user_created -> handle_new_user
- checkpoints (id, name, address, latitude, longitude, radius, qr_code,
  created_at)
- waste_logs (id, user_id, checkpoint_id, category, photo_url, hash,
  latitude, longitude, server_timestamp, status, verified_by,
  verified_at, notes, created_at)
- points (id, user_id, amount, type, reference_id, description,
  created_at)
- rewards (id, name, description, points_cost, stock, image_url,
  is_active, created_at)
- redemptions (id, user_id, reward_id, status, qr_code, created_at,
  claimed_at)

### 10.2 RLS

- profiles: user baca/update sendiri, tidak bisa mengganti role; admin
  baca semua. Fungsi role security definer: get_role, is_admin,
  is_petugas, is_admin_or_petugas.
- checkpoints: public read; tulis/ubah/hapus hanya admin.
- waste_logs: user baca/insert sendiri; admin/petugas baca + update semua.
- points: user baca sendiri; admin baca semua (pencatatan poin sisi server).
- rewards: public baca yang is_active; tulis/ubah/hapus hanya admin.
- redemptions: user baca/insert sendiri; admin/petugas baca + update semua.

### 10.3 Storage (lihat 008_create_storage_buckets.sql)

- Bucket waste-photos (private): foto bukti, path "<userId>/".
- Bucket avatars (public read, private write): path "<userId>/avatar.jpg".
- Upload foto hanya pada folder milik user; admin/petugas boleh baca
  semua foto waste-photos.

### 10.4 Edge Function (Rencana, fase 2+)

- Validasi anti-kecurangan lanjutan.
- AI forensics.
- Approval manual.

---

### 10.5 Autentikasi (Auth)

Arsitektur auth berlapis presentation -> domain -> data:

- Domain (lib/features/auth/domain/):
  - entities/auth_session.dart: AuthSession (userEmail, isLoggedIn).
  - repositories/auth_repository.dart: kontrak AuthRepository
    (signIn, signUp, signOut, currentSession, authStateChanges) plus enum
    hasil SignInResult / SignUpResult.
- Data (lib/features/auth/data/):
  - datasources/auth_remote_datasource.dart: membungkus Supabase Auth
    (signInWithEmail, signUpWithEmail, signOut, currentSession,
    authStateChanges) dengan SupabaseService.instance lazy.
  - repositories/supabase_auth_repository.dart: implementasi
    AuthRepository; bila Supabase belum terinisialisasi (mode demo)
    mensimulasikan operasi (delay 800ms) agar UI & test tetap berfungsi.
  - mappers/auth_error_mapper.dart: memetakan AuthException/error jaringan
    ke SignInResult/SignUpResult.
- Presentation (lib/features/auth/presentation/):
  - providers/auth_provider.dart: authRepositoryProvider (AuthRepository)
    dan authNotifierProvider (AuthNotifier StateNotifier<AuthSession>);
    mengikuti authStateChanges dari repository.
- Baris "profiles" dibuat otomatis oleh trigger handle_new_user setelah
  signUp. Kredensial Supabase dibaca dari .env / --dart-define.
- Dipakai Login/Register (form -> repository), Home (notice login
  otomatis hilang saat login), dan Profile (menu kondisional login vs
  logout).

### 10.6 Data Layer (Datasource & Model)

- Datasource per fitur di data/datasources/:
  - auth_remote_datasource.dart (signInWithEmail, signUpWithEmail,
    signInWithGoogle, signOut, getCurrentUser, getProfile).
  - waste_remote_datasource.dart (uploadPhoto, insertWasteLog,
    getWasteLogs, getPendingWasteLogs, verifyWasteLog).
  - points_remote_datasource.dart (getTotalPoints, getPointsHistory,
    addPoints, redeemPoints).
- Model data extends entity domain per fitur; fromJson/toJson memakai
  kolom snake_case. Entities: WasteLog, Profile, Checkpoint, Reward.
- Konstanta nama tabel/bucket di AppTables; enum role/kategori/status/
  tipe poin di app_enums (AppEnums).

---

## 11. Anti-Kecurangan (Ringkasan)

Level MVP: dasar (4 lapisan).

1. Kamera in-app.
2. Timestamp server.
3. GPS radius.
4. Hash SHA-256.

Detail di docs/SECURITY_AND_VALIDATION.md.

---

## 12. Status Dokumen

- Versi: 1.0
- Terakhir update: [tanggal]
- Perubahan berikutnya: setelah Fase 1 final.
