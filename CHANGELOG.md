# CHANGELOG - Go Green

## [2026-09-15] - Kecil: Posisi Cari Artikel & Navigasi Avatar Profile

Status: Selesai

File yang diubah:
- lib/features/home/presentation/pages/home_page.dart (diedit): field
  pencarian (SearchField) dipindah dari bawah header ke atas section
  "Artikel Terbaru" (setelah PointCard); avatar profil di header Home
  kini bisa ditekan dan mengarah ke halaman Edit Profil
  (AppRouteName.editProfile).

Verifikasi:
- hasil linter/analyze: OK (dart analyze tidak ada issue)
- hasil test: OK (home_login_notice_test dan auth_flow_test lulus)

Status: Selesai

File yang diubah:
- lib/features/home/presentation/pages/home_page.dart (diedit): tampilan
  Home didesain ulang sesuai contoh clipboard — header sapaan dengan avatar
  (widget Avatar) dan tombol lonceng, field pencarian (SearchField), banner
  hero "Buang Sampah, Dapat Poin!" dengan gambar aset home_promo.png dari
  folder ref sebagai latar, gradient overlay gelap, dan tombol CTA; section
  "Menu Utama" berisi empat kartu aksi cepat (Buang Sampah, Poin & Reward,
  Artikel, Scan QR) dalam satu baris; PointCard dan daftar Artikel Terbaru
  dengan thumbnail gambar (article_1.png, article_2.png dari folder ref).
- lib/core/widgets/card_widgets.dart (diedit): ArticleCard ditambah propopsi
  thumbnailImage (String?) sehingga gambar thumbnail aset bisa ditampilkan;
  jika null tetap fallback ke ikon placeholder seperti sebelumnya.
- lib/core/constants/app_assets.dart (diedit): tambah path aset homeBannerHero,
  articleThumb1, articleThumb2 (dari folder referensi UI).
- lib/core/constants/app_strings.dart (diedit): tambah string homeMenuTitle,
  homeHeroTitle, homeHeroSubtitle, homeHeroCta untuk hero dan section menu.
- pubspec.yaml (diedit): deklarasi aset folder assets/images/ref/ agar gambar
  referensi bisa diakses saat runtime.
- docs/UI_PAGES.md (diedit): update deskripsi section Home.
- docs/COMPONENT_LIBRARY.md (diedit): update deskripsi ArticleCard prop
  thumbnailImage.
- docs/ASSET_MANAGEMENT.md (diedit): catatan bahwa gambar referensi hero dan
  thumbnail dipakai sementara sebagai aset produksi Home.

Catatan:
- Data home masih placeholder (nama "Warga Go Green", total poin 250, dua
  artikel demo). Belum terhubung provider/state nyata.
- Avatar bell menampilkan snackbar "Fitur ini belum tersedia."
- Gambar referensi di folder ref sementara dipakai langsung sebagai aset
  produksi Home; akan diganti dengan aset produksi akhir ketika tersedia.

Verifikasi:
- hasil linter/analyze: OK (dart analyze lib/ tidak ada issue)
- hasil test: OK (home_login_notice_test, auth_flow_test, card_widgets_test
  lulus semua)

Status: Selesai

File yang diubah:
- lib/features/auth/presentation/pages/register_page.dart (diedit): layout
  disamakan dengan LoginPage — ikon daun di atas kiri, judul "Daftar"
  rata kiri, background AuthLeafDecoration (Positioned.fill), form nama/
  email/kata sandi/konfirmasi, tombol Daftar, divider "atau", tombol
  "Daftar dengan Google", link ke Login, dan ilustrasi AuthLeafSprig di
  pojok kanan bawah. AuthHeaderWidget tidak dipakai lagi di halaman ini.

Catatan:
- Urutan tombol Google dan link masuk tetap di bawah sesuai permintaan.
- Tidak ada perubahan logic (validasi, routing, Supabase tetap sama).

Verifikasi:
- hasil linter/analyze: OK (dart analyze tidak ada issue)
- hasil test: tidak dijalankan (sesuai permintaan user)

## [2026-09-15] - Login Berlatar Daun Sesuai Referensi UI

Status: Selesai

File yang diubah:
- lib/core/widgets/auth_leaf_decoration.dart (dibuat): dekorasi latar
  autentikasi (AuthLeafDecoration, lingkaran lembut + ikon daun samar di
  sudut layar) dan ilustrasi daun pojok kanan bawah (AuthLeafSprig).
  Warna memakai token (secondaryContainer, tertiaryLight, surfaceDim).
- lib/features/auth/presentation/pages/login_page.dart (diedit): layout
  disusun ulang meniru contoh UI clipboard/login_leaves.png yaitu ikon
  daun di atas, judul besar kiri, baris "Ingat saya" + "Lupa kata sandi?",
  tombol masuk, divider "atau", masuk dengan Google, link daftar, dan
  ilustrasi daun kanan bawah. Background daftar daun ditambahkan pada
  Stack; AuthHeaderWidget tidak dipakai lagi di halaman ini.
- lib/core/constants/app_strings.dart (diedit): tambah string rememberMe
  ("Ingat saya") dan forgotPassword ("Lupa kata sandi?").

Catatan:
- Urutan tombol Google dan link register tetap di bawah sesuai permintaan.
- Link "Lupa kata sandi?" menampilkan snackbar fitur belum tersedia.
- RegisterPage tidak diubah.
- Gambar di assets/images/ref/ tidak dipakai langsung sebagai aset produksi
  (hanya referensi visual); dekorasi dibangun dengan token tema.

Verifikasi:
- hasil linter/analyze: OK (dart analyze tidak ada issue)
- hasil test: OK (auth_flow_test dan home_login_notice_test lulus)

## [2026-09-15] - Polish Tampilan Login & Register

Status: Selesai

- core/widgets/auth_header_widget.dart (baru): header autentikasi reusable
  (logo daun + judul + deskripsi) dengan spacing konsisten, dipakai oleh
  LoginPage dan RegisterPage agar tampilan kedua halaman seragam.
- Halaman Login & Register: subtitle deskriptif di bawah judul, dekorasi
  latar daun halus (token secondaryContainer + alpha), dan jarak antar
  elemen yang konsisten sesuai DESIGN_SYSTEM. Layout asli dipertahankan
  (Google sign-in, divider "atau", urutan field, routing go_router,
  validasi, dan Supabase tidak berubah).
- Test widget auth_flow: perbaikan agar tombol PrimaryButton dipastikan
  terlihat (ensureVisible) sebelum ditekan, sesuai form yang scrollable.

## [2026-09-15] - Google Sign-In Satu Klik (Login & Register)

Status: Selesai

- Fitur: tombol "Masuk dengan Google" (globe icon, lucide) pada halaman Login
  dan Register. Satu klik langsung login/daftar tanpa isi email manual.
- auth (data/repositories/supabase_auth_repository.dart): tambah
  signInWithGoogle via Supabase Auth OAuth (signInWithOAuth). Error
  non-api di-mapping via AuthErrorMapper.mapSignInError
  (networkError -> pesan "Gagal masuk..." / ekor).

## [2026-09-15] - Auth Login Riil (Repository Layer: Supabase)

Status: Selesai

- Ganti AuthService (lib/core/services/auth_service.dart) dengan lapisan
  auth berarsitektur presentation -> domain -> data. File auth_service.dart
  dihapus; operasi auth kini lewat AuthRepository.
- Domain (lib/features/auth/domain/):
  - entities/auth_session.dart: AuthSession (userEmail, isLoggedIn).
  - repositories/auth_repository.dart: AuthRepository + enum
    SignInResult (success, invalidCredentials, notConfirmed, networkError,
    error) dan SignUpResult (success, alreadyRegistered, needsConfirmation,
    weakPassword, networkError, error).
- Data (lib/features/auth/data/):
  - datasources/auth_remote_datasource.dart: rewire ke Supabase Auth riil
    (signInWithEmail, signUpWithEmail, signOut, currentSession,
    authStateChanges) dengan SupabaseService.instance lazy.
  - repositories/supabase_auth_repository.dart: demonya tetap jalan bila
    Supabase belum terinisialisasi (delay 800ms) supaya widget test aman.
  - mappers/auth_error_mapper.dart: memetakan kode error Supabase
    (invalid_credentials, email_not_confirmed, already registered, weak
    password) dan error jaringan (SocketException, timeout) ke enum.
- Presentation (lib/features/auth/presentation/providers/auth_provider.dart):
  authRepositoryProvider + authNotifierProvider (AuthNotifier
  StateNotifier<AuthSession>) menggantikan authNotifierProvider model lama.
- Login/Register/Profile/Home dipindah dari AuthService ke repository;
  hasil SignInResult/SignUpResult menampilkan snackbar error maping.
- app_strings.dart: tambah errorLoginInvalid, errorEmailNotConfirmed,
  errorNetwork, errorWeakPassword, signUpConfirmationSent.
- Test: tambah auth_error_mapper_test + supabase_auth_repository_test
  (mode demo), FakeAuthRepository di test/support; widget test profil/home
  beralih ke FakeAuthRepository. flutter analyze 0 issue; 116 test lulus.

---

## [2026-09-15] - Setup Supabase Lengkap: Schema, Migration, Data Layer

Status: Selesai

- docs/DATABASE_SCHEMA.md: sumber kebenaran struktur database.
- Migration SQL baru (supabase/migrations/001-009) sesuai DATABASE_SCHEMA.md:
  001 profiles (id, email, username, role) + fungsi role security definer;
  002 checkpoints; 003 waste_logs; 004 points; 005 rewards; 006
  redemptions; 007 trigger handle_new_user; 008 storage buckets
  waste-photos + avatars; 009 seed data (opsional).
- Migration lama 202609150001/0002 dihapus karena belum pernah dijalankan
  dan schema-nya berbeda dari DATABASE_SCHEMA.md.
- AppTables (lib/core/constants/app_tables.dart): konstanta nama tabel
  dan bucket Supabase.
- AppEnums (lib/core/constants/app_enums.dart): UserRole, WasteCategory,
  WasteLogStatus, RedemptionStatus, PointType dengan fromDb().
- SupabaseService (lib/core/services/supabase_service.dart): tambah
  currentUser dan signOut (aman dipanggil dalam mode demo).
- AuthService (lib/core/services/auth_service.dart): signUp tidak lagi
  insert manual ke profiles; metadata username dikirim ke trigger
  handle_new_user yang membuat baris profil otomatis.
- auth_remote_datasource.dart: signInWithEmail, signUpWithEmail,
  signInWithGoogle, signOut, getCurrentUser, getProfile.
- waste_remote_datasource.dart: uploadPhoto (max 5 MB), insertWasteLog,
  getWasteLogs, getPendingWasteLogs, verifyWasteLog.
- points_remote_datasource.dart: getTotalPoints, getPointsHistory,
  addPoints, redeemPoints (pencatatan poin sisi server fase lanjut).
- Entity + Model: WasteLog/WasteLogModel, Profile/ProfileModel,
  Checkpoint/CheckpointModel, Reward/RewardModel.

File yang dibuat:
- docs/DATABASE_SCHEMA.md
- supabase/migrations/001_create_profiles.sql
- supabase/migrations/002_create_checkpoints.sql
- supabase/migrations/003_create_waste_logs.sql
- supabase/migrations/004_create_points.sql
- supabase/migrations/005_create_rewards.sql
- supabase/migrations/006_create_redemptions.sql
- supabase/migrations/007_create_triggers.sql
- supabase/migrations/008_create_storage_buckets.sql
- supabase/migrations/009_seed_data.sql
- lib/core/constants/app_tables.dart
- lib/core/constants/app_enums.dart
- lib/features/auth/data/datasources/auth_remote_datasource.dart
- lib/features/waste/data/datasources/waste_remote_datasource.dart
- lib/features/points/data/datasources/points_remote_datasource.dart
- lib/features/waste/domain/entities/waste_log.dart
- lib/features/waste/data/models/waste_log_model.dart
- lib/features/profile/domain/entities/profile.dart
- lib/features/profile/data/models/profile_model.dart
- lib/features/checkpoints/domain/entities/checkpoint.dart
- lib/features/checkpoints/data/models/checkpoint_model.dart
- lib/features/rewards/domain/entities/reward.dart
- lib/features/rewards/data/models/reward_model.dart

File yang dihapus:
- supabase/migrations/202609150001_initial_schema.sql
- supabase/migrations/202609150002_storage_buckets.sql

File yang diubah:
- lib/core/services/supabase_service.dart (diedit: +currentUser, +signOut)
- lib/core/services/auth_service.dart (diedit: signUp pakai trigger)
- lib/core/constants/app_values.dart (diedit: +maxPhotoBytes)
- docs/ARCHITECTURE.md (diedit: section 10 diupdate schema baru)

Verifikasi: flutter analyze bersih (0 issue), 101 test lulus,
docs/ARCHITECTURE.md diperbarui.

---

## [2026-09-15] - Auth Supabase + Profil Kondisional

Status: Selesai

- AuthService (lib/core/services/auth_service.dart): signIn, signUp,
  signOut, currentUser, onAuthStateChange berbasis Supabase Auth. Dalam
  mode demo (Supabase belum terinisialisasi, contoh pada test widget)
  operasi disimulasikan agar UI tetap bisa berjalan.
- authNotifierProvider (lib/features/auth/presentation/providers/):
  status autentikasi yang mengikuti perubahan sesi Supabase
  (onAuthStateChange).
- Login page: memanggil AuthService; gagal menampilkan
  "Gagal masuk..." (errorLoginFailed).
- Register page: memanggil AuthService; menangani case email sudah
  terdaftar dan error.
- Halaman Profil kondisional berikut status login:
  - Belum login: notice login (LoginNoticeCard) "Masuk atau daftar...",
    menu Pengaturan; TANPA "Keluar" dan TANPA "Edit Profil".
  - Sudah login: menampilkan email user, Edit Profil, Pengaturan, dan
    "Keluar" (signOut -> kembali ke Home).
- Notice login di Home otomatis hilang saat sudah login (tetap bisa
  di-tutup oleh tamu). Widget LoginNoticeCard dipakai bersama Home dan
  Profil.
- String baru: errorLoginFailed, errorEmailRegistered, profileLoginNotice.

File yang diubah:
- lib/core/services/auth_service.dart (baru)
- lib/core/services/supabase_service.dart (diedit: isInitialized + .env)
- lib/features/auth/presentation/providers/auth_provider.dart (baru)
- lib/features/auth/presentation/pages/login_page.dart (diedit)
- lib/features/auth/presentation/pages/register_page.dart (diedit)
- lib/features/home/presentation/pages/home_page.dart (diedit)
- lib/features/profile/presentation/pages/profile_page.dart (diedit)
- lib/core/widgets/login_notice_widget.dart (baru)
- lib/core/constants/app_strings.dart (diedit)
- test/widget/pages/profile_page_test.dart (ditulis ulang)
- test/widget/pages/home_login_notice_test.dart (ditambah test login)
- test/widget/pages/edit_profile_page_test.dart (diedit)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 101 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Setup Supabase: Kredensial, Schema, RLS, Storage

Status: Parsial (schema/RLS/storage siap; email/password auth via dashboard
manual)

- Kredensial Supabase (SUPABASE_URL + SUPABASE_ANON_KEY) di .env
  (gitignored). supabase_service.dart membaca dari --dart-define dulu,
  fallback ke .env via flutter_dotenv. Dilarang hardcode secret.
- Migration SQL baru di supabase/migrations/:
  - 202609150001_initial_schema.sql: profiles, checkpoints,
    waste_submissions, rewards, reward_claims, articles, points_log + RLS.
  - 202609150002_storage_buckets.sql: bucket waste-evidence (private),
    article-covers (public read) + RLS storage path user.
- Belum dikerjakan (langkah manual): jalankan migration di SQL Editor,
  aktifkan email/password auth di dashboard.

File yang diubah:
- .env (baru, gitignored)
- .env.example (diedit: instruksi)
- lib/core/services/supabase_service.dart (diedit: fallback .env)
- supabase/migrations/202609150001_initial_schema.sql (baru)
- supabase/migrations/202609150002_storage_buckets.sql (baru)
- docs/ARCHITECTURE.md (diedit: section 10 diisi status aktual)

Verifikasi: flutter analyze bersih; dokumentasi diperbarui.

---

## [2026-09-15] - Perilaku Back: Kembali ke Home Dulu + Exit 2x

Status: Selesai

Perubahan perilaku tombol back (di MainShell/PopScope):
- Di tab selain Beranda (misal Poin), back kembali ke tab Beranda dulu
  (lewat goBranch ke branch 0), bukan langsung keluar aplikasi.
- Di tab Beranda, back pertama menampilkan snackbar "Tekan kembali lagi
  untuk keluar"; back kedua dalam 2 detik menutup aplikasi
  (SystemNavigator.pop).

File yang diubah:
- lib/core/widgets/main_shell.dart (diedit: jadi StatefulWidget,
  PopScope + logika back, SystemNavigator)
- lib/core/constants/app_strings.dart (diedit: backToExitHint)
- test/widget/pages/auth_flow_test.dart (diedit: 2 test back baru)

Verifikasi: flutter analyze bersih (0 issue), 99 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Login Tidak Wajib di Awal + Notice Login di Home

Status: Selesai

Perubahan alur:
- Setelah Splash dan Onboarding (yang bisa dilewati), user LANGSUNG masuk
  ke Home, tidak lagi diarahkan ke halaman Login.
- Login/Register tetap tersedia; di Home tampil notice login berupa banner
  di bagian atas yang bisa ditutup (ikon x), dengan aksi "Masuk" yang
  membuka halaman Login.
- Notice bersifat per-sesi (state lokal HomePage); login dari notice
  mengarah kembali ke Home setelah berhasil.

File yang diubah:
- lib/features/onboarding/onboarding_page.dart (diedit: last slide dan
  tombol Lewati ke Home)
- lib/features/home/presentation/pages/home_page.dart (diedit: jadi
  StatefulWidget + _LoginNoticeBanner)
- lib/core/constants/app_strings.dart (diedit: homeLoginNotice*)
- test/widget/pages/auth_flow_test.dart (diedit: ekspektasi ke Home)
- test/widget/pages/home_login_notice_test.dart (baru)

Verifikasi: flutter analyze bersih (0 issue), 97 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Tampilan Timestamp pada Foto + Radius Dinonaktifkan Sementara

Status: Selesai

Fitur baru:
- Halaman Verifikasi menampilkan timestamp hasil pengambilan foto:
  - Overlay timestamp di bagian bawah preview foto (ikon jam + label),
  - Baris detail Timestamp ikut menampilkan nilai yang sama.
- Timestamp diambil saat shutter di halaman kamera memakai waktu device dan
  diformat "12 Sep 2026, 14.32 WIB" (formatIndonesianTimestamp).
  Catatan: sementara memakai waktu device sampai timestamp server terpasang
  bersama layer Supabase.

Pengingat (diminta user):
- Cek radius GPS 100 m dari checkpoint yang dibuat sebelumnya DIHAPUS
  sementara agar tidak memblokir preview. Untuk reaktivasi, tinggal
  menghidupkan pemakaian AppValues.gpsRadiusMeters + GeoUtils.distanceMeters
  di _takePicture (capture_photo_page.dart) dan menampilkan jarak kembali.
  Aset pendukung (koordinat checkpoint, util, konstanta) sengaja disimpan.

File yang diubah:
- lib/core/utils/formatters.dart (diedit: formatIndonesianTimestamp)
- lib/features/verification/presentation/data/verification_extra.dart
  (diedit: timestampLabel; hapus checkpointName/distanceFromCheckpoint)
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit:
  hapus cek radius, tambah timestamp)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: tidak
  lagi kirim checkpoint ke kamera)
- lib/core/router/app_router.dart (diedit: revert extra /capture)
- lib/features/verification/presentation/pages/verification_page.dart
  (diedit: overlay timestamp pada foto)
- test/unit/core/formatters_test.dart (diedit)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 94 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Cek Radius GPS Checkpoint (Anti-Kecurangan)

Status: Selesai (cek radius wajib diuji di device fisik)

Fitur baru:
- Cek radius GPS sebelum lanjut ke verifikasi: jarak posisi user ke
  checkpoint terpilih dihitung dengan geolocator.distanceBetween. Jika lebih
  dari 100 m (AppValues.gpsRadiusMeters), upload diblokir dan ditampilkan
  pesan "Kamu berada di luar radius checkpoint".
- Checkpoint demo kini membawa koordinat (lat/lng) dan dikirim ke halaman
  kamera via route extra.
- Halaman Verifikasi menampilkan jarak ke checkpoint, misal
  "-6.200000, 106.816667 (25 m dari TPS Kelurahan)".
- LocationService refactor: getCurrentPosition() mengembalikan Position,
  formatPositionLabel() memformat koordinat.
- Dependency baru (dev): geolocator_platform_interface ^4.3.0 untuk fake
  pada unit test LocationService/GeoUtils. Evaluasi (PROTOCOL Bagian C):
  milik tim geolocator, sudah diresolusi transitif di dependency graph,
  aktif dipelihara; alternatif dievaluasi: mock method channel
  "flutter.baseflow.com/geolocator" (fragile, tidak dipilih).

File yang diubah:
- lib/core/constants/app_values.dart (dibuat: gpsRadiusMeters)
- lib/core/utils/geo_utils.dart (dibuat: distanceMeters)
- lib/features/waste/presentation/data/checkpoint_demo_data.dart (dibuat)
- lib/core/services/location_service.dart (diedit)
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit:
  cek radius + kirim checkpoint)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: pakai
  data checkpoint baru + kirim checkpoint terpilih)
- lib/features/verification/presentation/data/verification_extra.dart
  (diedit: checkpointName + distanceFromCheckpoint)
- lib/features/verification/presentation/pages/verification_page.dart
  (diedit: tampil jarak ke checkpoint)
- lib/core/router/app_router.dart (diedit: extra /capture)
- lib/core/constants/app_strings.dart (diedit: pesan luar radius)
- pubspec.yaml (diedit: dev dep geolocator_platform_interface)
- test/unit/core/location_service_test.dart (dibuat)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 92 test lulus,
docs diubah di UI_PAGES.md dan ARCHITECTURE.md.

---

## [2026-09-15] - Perbaikan Kamera: Lokasi GPS Asli, Retake, dan Flash

Status: Selesai (kamera/GPS/flash menunggu pengujian device fisik)

Perbaikan bug:
- Lokasi verifikasi kini memakai koordinat GPS asli (geolocator) saat foto
  diambil, dikirim via data ekstra route, bukan teks demo statis. Jika GPS
  mati atau izin lokasi ditolak ditampilkan pesan "Lokasi tidak dapat
  diambil".
- Layar hitam saat "Coba Lagi" diperbaiki: kamera pindah ke Verifikasi pakai
  push (bukan go), sehingga halaman kamera tetap hidup dan tombol "Coba
  Lagi" kembali ke kamera yang masih berfungsi.
- Flash kamera: tombol flash (mati -> otomatis -> menyala) memakai
  setFlashMode; ikon zap_off/zap dengan tooltip.
- Retry inisialisasi kamera kini membuang controller lama sebelum membuat
  yang baru agar tidak menyisakan instance rusak.
- Preview foto bukti ditampilkan di halaman Verifikasi dari file hasil
  takePicture; izin lokasi (Android manifest dan Info.plist) ditambahkan.

File yang diubah:
- lib/core/services/location_service.dart (dibuat)
- lib/features/verification/presentation/data/verification_extra.dart (dibuat)
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit)
- lib/features/verification/presentation/pages/verification_page.dart (diedit)
- lib/core/router/app_router.dart (diedit: baca extra verifikasi)
- lib/core/constants/app_strings.dart (diedit: string flash dan lokasi gagal)
- android/app/src/main/AndroidManifest.xml (diedit: izin lokasi)
- ios/Runner/Info.plist (diedit: NSLocationWhenInUseUsageDescription)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 85 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Detail Aktivitas, Skip Onboarding, dan Akses Scan QR

Status: Selesai (front-end, data demo)

Fitur baru:
- Detail Aktivitas: halaman di route /activity/:id menampilkan header status,
  deskripsi, dan baris detail (tanggal, checkpoint, poin). Kartu aktivitas di
  riwayat membuka halaman ini.
- Onboarding: tombol "Lewati" untuk langsung menuju Login.
- Waste: link "Scan QR di checkpoint" sebagai pintu masuk halaman Scan QR.

File yang diubah:
- lib/features/activity/presentation/data/activity_demo_data.dart (dibuat)
- lib/features/activity/presentation/pages/activity_detail_page.dart (dibuat)
- lib/features/activity/presentation/pages/activity_page.dart (diedit: data demo + navigasi)
- lib/features/onboarding/onboarding_page.dart (diedit: tombol Lewati)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: link scan QR)
- lib/core/router/app_router.dart (diedit: route /activity/:id)
- lib/core/constants/app_strings.dart (diedit: string detail aktivitas, lewati, scan)
- test/widget/pages/activity_detail_page_test.dart (dibuat)
- test/widget/pages/auth_flow_test.dart (diedit: test lewati onboarding)
- test/widget/pages/waste_page_test.dart (diedit: test link scan)

Verifikasi: flutter analyze bersih (0 issue), 82 test lulus,
dokumen diubah di UI_PAGES.md dan ARCHITECTURE.md (daftar route).

---

## [2026-09-15] - Kamera In-App, Edit Profil, Pengaturan, dan Polish UI

Status: Selesai (kamera/GPS menunggu pengujian device fisik)

Fitur baru:
- Kamera in-app (anti-kecurangan): halaman CapturePhotoPage memakai package
  camera dengan izin permission_handler. Izin ditolak dan kamera tidak
  tersedia punya fallback UI. Tombol shutter mengarah ke halaman Verifikasi.
- Edit Profil: form nama + email (terisi data demo), validasi, simpan dengan
  snackbar sukses, lalu kembali.
- Pengaturan: menu akun (Edit Profil), toggle Notifikasi dan Mode Gelap
  (lokal), informasi aplikasi (versi + dialog Tentang).
- Tukar reward: dialog konfirmasi, sukses ditampilkan lewat snackbar.

Polish UI:
- PointCard: gradient primary->primaryLight + ring ikon.
- Bottom nav: tinggi 72, indikator titik aktif, bayangan pada tombol aksen.
- Profil: avatar dengan ring primaryLight.

File yang diubah:
- lib/features/waste/presentation/pages/capture_photo_page.dart (dibuat)
- lib/features/profile/presentation/pages/edit_profile_page.dart (dibuat)
- lib/features/profile/presentation/pages/settings_page.dart (dibuat)
- lib/core/router/app_router.dart (diedit: route /capture, /edit-profile, /settings)
- lib/core/constants/app_strings.dart (diedit: string capture/profil/setting/tukar)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: tombol Ambil Foto ke kamera)
- lib/features/profile/presentation/pages/profile_page.dart (diedit: navigasi + ring avatar)
- lib/features/points/presentation/pages/reward_detail_page.dart (diedit: dialog tukar)
- lib/core/widgets/card_widgets.dart (diedit: gradient PointCard)
- lib/core/widgets/custom_bottom_nav_bar_widget.dart (diedit: indikator aktif)
- android/app/src/main/AndroidManifest.xml (diedit: izin CAMERA)
- ios/Runner/Info.plist (diedit: NSCameraUsageDescription)
- test/widget/pages/capture_photo_page_test.dart (dibuat)
- test/widget/pages/edit_profile_page_test.dart (dibuat)
- test/widget/pages/settings_page_test.dart (dibuat)
- test/widget/pages/waste_page_test.dart (diedit: navigasi kamera)
- test/widget/pages/reward_detail_page_test.dart (diedit: dialog tukar)
- docs/ARCHITECTURE.md (diedit: daftar route)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:
- Widget test memakai mock MethodChannel permission/camera karena device
  plugin tidak tersedia di environment test.
- Task kamera/GPS/QR tetap wajib diverifikasi di device fisik.
- Tidak ada dependency baru pada task ini (camera, permission_handler,
  geolocator sudah ada di pubspec).

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (76 test pass)

## [2026-09-15] - Detail Reward, Verifikasi, dan Scan QR

Status: Selesai (data sensor/foto menunggu layer data + device)

File yang diubah:
- lib/features/points/presentation/pages/reward_detail_page.dart (dibuat)
- lib/features/points/presentation/pages/points_page.dart (diedit: looping demo data + navigasi detail)
- lib/features/points/presentation/data/reward_demo_data.dart (dibuat)
- lib/features/verification/presentation/pages/verification_page.dart (dibuat)
- lib/features/scan/presentation/pages/scan_page.dart (dibuat)
- lib/core/router/app_router.dart (diedit: route /reward/:id, /verification, /scan)
- lib/core/constants/app_strings.dart (diedit: string reward/verifikasi/scan)
- test/widget/pages/reward_detail_page_test.dart (dibuat)
- test/widget/pages/verification_page_test.dart (dibuat)
- test/widget/pages/scan_page_test.dart (dibuat)
- test/widget/pages/points_page_test.dart (diedit: navigasi ke detail reward)
- docs/ARCHITECTURE.md (diedit: daftar route)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:
- Detail reward: ikon, nama, harga poin, benefit, saldo, tombol Tukar
  (snackbar belum tersedia). RewardCard di Poin kini membuka halaman ini.
- Verifikasi: status berhasil, placeholder foto, detail timestamp/lokasi/
  hash/estimasi poin (nilai demo), dialog detail hash, tombol Coba Lagi
  dan Konfirmasi Kirim (ke Home). Kamera, GPS, dan hash SHA-256 asli
  menunggu layer data dan pengujian device.
- Scan QR: viewfinder visual; deteksi mobile_scanner menunggu device.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (65 test pass)

## [2026-09-15] - Halaman Waste (UI-first), Artikel, dan Detail Artikel

Status: Selesai (kamera/GPS menunggu layer data + device)

File yang diubah:
- lib/features/waste/presentation/pages/waste_page.dart (diedit: UI-first)
- lib/features/article/presentation/pages/article_page.dart (diedit: search + daftar real)
- lib/features/article/presentation/pages/article_detail_page.dart (dibuat)
- lib/features/article/presentation/data/article_demo_data.dart (dibuat)
- lib/features/home/presentation/pages/home_page.dart (diedit: kard artikel ke detail)
- lib/core/widgets/feedback_widgets.dart (dibuat: EmptyState)
- lib/core/router/app_router.dart (diedit: route /article/:id)
- lib/core/constants/app_strings.dart (diedit: string artikel, waste, detail)
- test/widget/components/feedback_widgets_test.dart (dibuat)
- test/widget/pages/article_page_test.dart (dibuat)
- test/widget/pages/waste_page_test.dart (dibuat)
- docs/ARCHITECTURE.md (diedit: daftar route)
- docs/COMPONENT_LIBRARY.md (diedit: status EmptyState)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:
- Waste: pilihan checkpoint (ListTileItem + centang), status GPS dalam
  radius demi status "Berhasil". Tombol "Ambil Foto" menampilkan snackbar
  karena kamera in-app, timestamp server, dan hash SHA-256 menunggu layer
  data. Wajib diuji di device fisik.
- Artikel: search filter di sisi klien, empty state EmptyState saat tanpa
  hasil, empat artikel demo. Detail artikel lewat route /article/:id
  (konten paragraf placeholder).
- Home kini membuka detail artikel saat kartu ditekan.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (58 test pass)

## [2026-09-15] - Halaman Aktivitas, Poin & Reward, dan Profile

Status: Selesai

File yang diubah:
- lib/features/activity/presentation/pages/activity_page.dart (diedit: halaman real)
- lib/features/points/presentation/pages/points_page.dart (diedit: halaman real)
- lib/features/profile/presentation/pages/profile_page.dart (diedit: halaman real)
- lib/core/widgets/status_widgets.dart (dibuat: StatusType, StatusChip)
- lib/core/widgets/display_widgets.dart (dibuat: Avatar, StatItem, ListTileItem)
- lib/core/widgets/card_widgets.dart (diedit: ActivityCard, RewardCard)
- lib/core/constants/app_strings.dart (diedit: string Aktivitas/Poin/Profile)
- test/widget/components/card_widgets_test.dart (diedit: test ActivityCard, RewardCard)
- test/widget/components/status_widgets_test.dart (dibuat)
- test/widget/components/display_widgets_test.dart (dibuat)
- test/widget/pages/points_page_test.dart (dibuat)
- test/widget/pages/profile_page_test.dart (dibuat)
- docs/COMPONENT_LIBRARY.md (diedit: status komponen)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:
- Aktivitas: daftar aktivitas demo memakai ActivityCard + StatusChip
  (status berhasil / menunggu verifikasi).
- Poin & Reward: saldo via PointCard, empat RewardCard demo, riwayat poin
  memakai ActivityCard. Detail reward bukan bagian task ini.
- Profile: avatar inisial (Avatar), kartu statistik (StatItem), menu
  (ListTileItem); Edit Profil/Pengaturan menampilkan snackbar, Logout
  kembali ke Login.
- Semua data masih placeholder sampai layer data terpasang.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (48 test pass)

## [2026-09-14] - Home, bottom navigation, dan komponen card

Status: Selesai

File yang diubah:
- lib/core/widgets/custom_bottom_nav_bar_widget.dart (dibuat)
- lib/core/widgets/card_widgets.dart (dibuat: InfoCard, PointCard, ArticleCard)
- lib/core/widgets/main_shell.dart (dibuat)
- lib/core/router/app_router.dart (diedit: StatefulShellRoute untuk tab utama, splash pindah ke /splash)
- lib/core/constants/app_strings.dart (diedit: string Home)
- lib/core/utils/formatters.dart (dibuat: format angka dan tanggal Indonesia)
- lib/features/home/presentation/pages/home_page.dart (diedit: halaman real)
- test/unit/core/formatters_test.dart (dibuat)
- test/widget/components/bottom_nav_bar_test.dart (dibuat)
- test/widget/components/card_widgets_test.dart (dibuat)
- test/widget/pages/auth_flow_test.dart (diedit: initial location /splash + test ganti tab)
- docs/ARCHITECTURE.md (diedit: bagian routing)
- docs/COMPONENT_LIBRARY.md (diedit: status komponen)
- docs/UI_PAGES.md (diedit: status halaman Home)

Catatan:
- Routing tab utama kini StatefulShellRoute.indexedStack + MainShell,
  state tiap tab tersimpan; splash berpindah path ke /splash.
- Bottom nav 5 item; "Buang Sampah" sebagai tombol aksen bulat di tengah.
- Home memakai komponen reusable dan token tema; data masih placeholder
  sampai layer data terpasang.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (33 test pass)

## [2026-09-14] - Alur auth: Splash, Onboarding, Login, Register

Status: Selesai

File yang diubah:
- lib/core/router/app_router.dart (diedit: route /onboarding, konstanta AppRouteName.onboarding, ekspor appRoutes untuk test)
- lib/core/constants/app_strings.dart (diedit: string konfirmasi password dan error validasi)
- lib/core/widgets/app_button_widgets.dart (dibuat)
- lib/core/widgets/custom_text_field_widget.dart (dibuat)
- lib/core/widgets/app_bar_and_loading_widgets.dart (dibuat)
- lib/features/splash/splash_page.dart (diedit: halaman real dengan navigasi ke onboarding)
- lib/features/onboarding/onboarding_page.dart (dibuat)
- lib/features/auth/presentation/pages/login_page.dart (diedit: halaman real dengan validasi form)
- lib/features/auth/presentation/pages/register_page.dart (diedit: halaman real dengan validasi form)
- pubspec.yaml (diedit: ganti lucide_icons -> flutter_lucide)
- test/widget_test.dart (diedit: akomodasi timer splash)
- test/widget/components/app_button_test.dart (dibuat)
- test/widget/components/input_test.dart (dibuat)
- test/widget/components/app_bar_and_loading_test.dart (dibuat)
- test/widget/pages/auth_flow_test.dart (dibuat)
- docs/ARCHITECTURE.md (diedit: stack ikon dan evaluasi dependency 8.1)
- docs/COMPONENT_LIBRARY.md (diedit: status komponen)
- docs/UI_PAGES.md (diedit: status halaman auth)
- docs/TESTING_STRATEGY.md (diedit: perbaiki file yang rusak)

Catatan:
- Halaman auth memakai komponen reusable (PrimaryButton, CustomTextField,
  dll) dan token tema.
- Navigasi memakai context.goNamed dengan nama route.
- Penggantian dependency: lucide_icons 0.257.0 tidak bisa dikompilasi di
  Flutter 3.47.2 (IconData final class), diganti flutter_lucide 1.45.0
  (aktif dipelihara, terbit 2026-09-11). Nama ikon berubah ke snake_case.
- Evaluasi dependency lengkap ada di docs/ARCHITECTURE.md bagian 8.1.

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (19 test pass)

## [2026-09-14] - Setup struktur project

Status: Selesai

File yang diubah:
- docs/* (dibuat)
- pubspec.yaml (dibuat)
- AGENTS.md (dibuat)
- PROTOCOL.md (dibuat)
- CHANGELOG.md (dibuat)
- .env.example (dibuat)
- .opencode/* (dibuat)
- assets/* (dibuat)
  - assets/fonts/* (dibuat: font Manrope 4 bobot + Geist 3 bobot, unduhan resmi)
- lib/core/* (dibuat)
- lib/features/* (dibuat)
- lib/main.dart (dibuat)
- test/* (dibuat)

Catatan:
- Setup fondasi project sesuai PROTOCOL.md
- Font Manrope dan Geist (TTF) diunduh dari fonts.gstatic.com
- Dependency sesuai spesifikasi awal

Verifikasi:
- hasil linter/analyze: OK (0 issue)
- hasil test: OK (1 test pass)