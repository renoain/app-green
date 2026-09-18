// Menyimpan seluruh string UI aplikasi.
//
// String tampilan wajib Bahasa Indonesia. Wajib dipakai di widget,
// dilarang hardcode string UI langsung.

/// String UI aplikasi Go Green.
class AppStrings {
  AppStrings._();

  /// Nama aplikasi.
  static const String appName = 'Go Green';

  /// --- Auth ---

  /// Judul halaman login.
  static const String loginTitle = 'Masuk';

  /// Subjudul halaman login.
  static const String loginSubtitle =
      'Ayo mulai kebiasaan hijau dan kumpulkan poin untuk reward.';

  /// Label checkbox "ingat saya" di halaman login.
  static const String rememberMe = 'Ingat saya';

  /// Link "lupa kata sandi" di halaman login.
  static const String forgotPassword = 'Lupa kata sandi?';

  /// Label input email.
  static const String emailLabel = 'Email';

  /// Hint input email.
  static const String emailHint = 'nama@email.com';

  /// Label input password.
  static const String passwordLabel = 'Kata Sandi';

  /// Hint input password.
  static const String passwordHint = 'Minimal 6 karakter';

  /// Label tombol login.
  static const String loginButton = 'Masuk';

  /// Label tombol masuk dengan Google (sekali klik).
  static const String loginWithGoogle = 'Masuk dengan Google';

  /// Pemisah "atau" antara login Google dan login email.
  static const String orDivider = 'atau';

  /// Pesan saat login Google gagal.
  static const String errorGoogleLoginFailed =
      'Gagal masuk dengan Google. Coba lagi.';

  /// Teks link ke halaman register.
  static const String registerPrompt = 'Belum punya akun? Daftar di sini';

  /// Judul halaman register.
  static const String registerTitle = 'Daftar';

  /// Subjudul halaman register.
  static const String registerSubtitle =
      'Buat akun untuk mulai membuang sampah dan menukar poin.';

  /// Label tombol register.
  static const String registerButton = 'Daftar';

  /// Label tombol register dengan Google (sekali klik).
  static const String registerWithGoogle = 'Daftar dengan Google';

  /// Teks link ke halaman login.
  static const String loginPrompt = 'Sudah punya akun? Masuk di sini';

  /// Pesan saat login gagal (email/password salah atau koneksi bermasalah).
  static const String errorLoginFailed =
      'Gagal masuk. Periksa email dan kata sandi, lalu coba lagi.';

  /// Pesan saat email sudah terdaftar.
  static const String errorEmailRegistered = 'Email sudah terdaftar. Silakan masuk.';

  /// Pesan saat email/password salah.
  static const String errorLoginInvalid = 'Email atau kata sandi salah. Coba lagi.';

  /// Pesan saat email belum dikonfirmasi.
  static const String errorEmailNotConfirmed =
      'Email belum dikonfirmasi. Periksa kotak masuk email kamu.';

  /// Pesan saat gagal karena tidak ada koneksi internet.
  static const String errorNetwork =
      'Tidak ada koneksi internet. Periksa koneksi lalu coba lagi.';

  /// Pesan saat kata sandi terlalu lemah.
  static const String errorWeakPassword =
      'Kata sandi terlalu lemah. Gunakan kombinasi yang lebih kuat.';

  /// Pesan saat registrasi dibatasi sementara karena terlalu sering mencoba.
  static const String errorRateLimitExceeded =
      'Terlalu banyak percobaan. Tunggu beberapa saat lalu coba lagi.';

  /// Pesan setelah registrasi yang butuh konfirmasi email.
  static const String signUpConfirmationSent =
      'Pendaftaran berhasil. Periksa email untuk konfirmasi sebelum masuk.';

  /// Label input nama.
  static const String nameLabel = 'Nama';

  /// Hint input nama.
  static const String nameHint = 'Nama lengkap kamu';

  /// Error email tidak valid.
  static const String errorEmailInvalid = 'Format email tidak valid';

  /// Error password terlalu pendek.
  static const String errorPasswordTooShort = 'Kata sandi minimal 6 karakter';

  /// Error nama kosong.
  static const String errorNameRequired = 'Nama wajib diisi';

  /// Error nama tampilan terlalu pendek.
  static const String errorDisplayNameTooShort = 'Nama minimal 2 karakter';

  /// Label input username.
  static const String usernameLabel = 'Username';

  /// Hint input username.
  static const String usernameHint = 'cth: warga_hijau';

  /// Error username tidak valid.
  static const String errorUsernameInvalid =
      'Username 3-20 karakter: huruf kecil, angka, underscore, tanpa spasi';

  /// Error username sudah dipakai user lain.
  static const String errorUsernameTaken =
      'Username sudah dipakai. Coba username lain.';

  /// Label input login email atau username.
  static const String loginIdentityLabel = 'Email atau Username';

  /// Hint input login email atau username.
  static const String loginIdentityHint = 'nama@email.com atau username';

  /// Error login email/username kosong.
  static const String loginIdentityRequired =
      'Email atau username wajib diisi';

  /// Label input nomor telepon.
  static const String phoneLabel = 'Nomor Telepon';

  /// Hint input nomor telepon.
  static const String phoneHint = '08xxxxxxxxxx (opsional)';

  /// Error nomor telepon tidak valid.
  static const String errorPhoneInvalid = 'Nomor telepon tidak valid';

  /// Label input konfirmasi password.
  static const String confirmPasswordLabel = 'Konfirmasi Kata Sandi';

  /// Hint input konfirmasi password.
  static const String confirmPasswordHint = 'Ulangi kata sandi';

  /// Error email wajib diisi.
  static const String errorEmailRequired = 'Email wajib diisi';

  /// Error password wajib diisi.
  static const String errorPasswordRequired = 'Kata sandi wajib diisi';

  /// Error password tidak cocok.
  static const String errorPasswordMismatch = 'Kata sandi tidak cocok';

  /// --- Home ---

  /// Sapaan di header Home.
  static const String greeting = 'Halo,';

  /// Nama tampilan sementara sebelum data user tersedia.
  static const String guestName = 'Warga Go Green';

  /// Teks notice login yang bisa dilewati di Home.
  static const String homeLoginNotice =
      'Masuk untuk sinkron data, buang sampah, dan tukar poin.';

  /// Label aksi Masuk pada notice login di Home.
  static const String homeLoginNoticeAction = 'Masuk';

  /// Label tooltip menutup notice login di Home.
  static const String homeLoginNoticeDismiss = 'Tutup notice';

  /// Himbauan saat back pertama di tab Home untuk keluar aplikasi.
  static const String backToExitHint = 'Tekan kembali lagi untuk keluar';

  /// Judul section aksi cepat di Home.
  static const String homeQuickActionsTitle = 'Aksi Cepat';

  /// Judul section menu utama di Home.
  static const String homeMenuTitle = 'Menu Utama';

  /// Judul hero banner di Home.
  static const String homeHeroTitle = 'Buang Sampah, Dapat Poin!';

  /// Deskripsi hero banner di Home.
  static const String homeHeroSubtitle =
      'Jaga lingkungan, kumpulkan poin, dan tukar dengan reward.';

  /// Label tombol aksi hero banner di Home.
  static const String homeHeroCta = 'Mulai Sekarang';

  /// Label kecil di atas judul hero banner Home (Stitch).
  static const String homeHeroEyebrow = 'Ayo Mulai!';

  /// Judul kartu ringkasan poin di Home (Stitch).
  static const String homeTotalPointsTitle = 'Total Poin Kamu';

  /// Tombol tukar reward di kartu poin Home.
  static const String homeExchangeReward = 'Tukar Reward';

  /// Tombol lihat riwayat di kartu poin Home.
  static const String homeViewHistory = 'Lihat Riwayat';

  /// Nilai stat sampah terpilah di Home.
  static const String homeStatWasteValue = '12,5 kg';

  /// Label stat sampah terpilah di Home.
  static const String homeStatWasteLabel = 'Sampah Terpilah';

  /// Nilai stat karbon dihindari di Home.
  static const String homeStatCarbonValue = '35 kg';

  /// Label stat karbon dihindari di Home.
  static const String homeStatCarbonLabel = 'Karbon Dihindari';

  /// Nilai stat pohon selamat di Home.
  static const String homeStatTreeValue = '5';

  /// Label stat pohon selamat di Home.
  static const String homeStatTreeLabel = 'Pohon Selamat';

  /// Judul misi mingguan di Home.
  static const String homeMissionTitle = 'Misi Hijau Mingguan';

  /// Deskripsi misi mingguan di Home.
  static const String homeMissionDesc =
      'Kumpulkan 5 kg sampah anorganik minggu ini';

  /// Progres terkumpul misi mingguan di Home.
  static const String homeMissionCollected = '3,25 kg terkumpul';

  /// Target misi mingguan di Home.
  static const String homeMissionTarget = 'Target: 5,0 kg';

  /// Judul section aktivitas terkini di Home.
  static const String homeLatestActivity = 'Aktivitas Terkini';

  /// Label ringkas lihat semua (Stitch memakai kata pendek).
  static const String seeAllShort = 'Semua';

  /// Judul setoran botol plastik demo di Home.
  static const String homeActivity1Title = 'Setor Botol Plastik (PET)';

  /// Waktu setoran botol plastik demo di Home.
  static const String homeActivity1Time = 'Hari ini, 08.30';

  /// Judul setoran kertas karton demo di Home.
  static const String homeActivity2Title = 'Setor Kertas Karton';

  /// Waktu setoran kertas karton demo di Home.
  static const String homeActivity2Time = 'Kemarin, 14.15';

  /// Label status terverifikasi di Home.
  static const String homeVerifiedLabel = 'Terverifikasi';

  /// Judul section artikel dan edukasi di Home.
  static const String homeArticleSection = 'Artikel & Edukasi Hijau';

  /// Deskripsi kartu aksi buang sampah.
  static const String quickActionWasteDesc = 'Ambil foto di checkpoint terdekat';

  /// Judul kartu aksi lihat poin.
  static const String quickActionPointsTitle = 'Lihat Poin';

  /// Deskripsi kartu aksi lihat poin.
  static const String quickActionPointsDesc = 'Tukarkan poin menjadi reward';

  /// Judul section artikel terbaru di Home.
  static const String homeRecentArticles = 'Artikel Terbaru';

  /// Label link lihat semua.
  static const String seeAll = 'Lihat semua';

  /// Judul artikel demo pertama di Home.
  static const String homeArticle1Title = 'Pilah Sampah: Mulai dari Dapur';

  /// Ringkasan artikel demo pertama di Home.
  static const String homeArticle1Excerpt =
      'Cara sederhana memilah sampah organik dan anorganik di rumah.';

  /// Judul artikel demo kedua di Home.
  static const String homeArticle2Title = 'Kompos Rumah Tangga Tanpa Bau';

  /// Ringkasan artikel demo kedua di Home.
  static const String homeArticle2Excerpt =
      'Teknik kompos basah yang aman untuk rumah kecil.';

  /// Judul artikel demo ketiga di daftar Artikel.
  static const String homeArticle3Title = 'Daur Ulang Plastik di Rumah';

  /// Ringkasan artikel demo ketiga.
  static const String homeArticle3Excerpt =
      'Mengubah botol bekas menjadi barang yang berguna.';

  /// Judul artikel demo keempat di daftar Artikel.
  static const String homeArticle4Title = 'Kurangi Sampah Makanan';

  /// Ringkasan artikel demo keempat.
  static const String homeArticle4Excerpt =
      'Kebiasaan belanja dan memasak yang lebih cerdas.';

  /// Paragraf demo konten artikel (semua artikel di MVP).
  static const String articleContentP1 =
      'Memilah sampah sejak dari sumber adalah langkah paling sederhana '
      'untuk memulai gaya hidup ramah lingkungan. Siapkan wadah terpisah '
      'untuk organik, anorganik, dan residu di area dapur.';

  /// Paragraf demo kedua konten artikel.
  static const String articleContentP2 =
      'Sampah organik dapat diolah menjadi kompos, sedangkan sampah '
      'anorganik yang bersih bisa diserahkan ke bank sampah terdekat. '
      'Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.';

  /// Paragraf demo ketiga konten artikel.
  static const String articleContentP3 =
      'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat '
      'pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.';

  /// Hint pencarian artikel.
  static const String articleSearchHint = 'Cari artikel';

  /// Judul empty state pencarian artikel tanpa hasil.
  static const String articleNoResultsTitle = 'Artikel tidak ditemukan';

  /// Pesan empty state pencarian artikel tanpa hasil.
  static const String articleNoResultsMessage =
      'Coba kata kunci lain, misalnya "kompos".';

  /// Judul bottom nav home.
  static const String navHome = 'Beranda';

  /// Judul bottom nav activity.
  static const String navActivity = 'Aktivitas';

  /// Judul bottom nav waste.
  static const String navWaste = 'Buang Sampah';

  /// Judul bottom nav points.
  static const String navPoints = 'Poin';

  /// Judul bottom nav profile.
  static const String navProfile = 'Profil';

  /// --- Waste ---

  /// Judul halaman buang sampah.
  static const String wasteTitle = 'Buang Sampah';

  /// Label tombol ambil foto.
  static const String takePhotoButton = 'Ambil Foto';

  /// Teks saat memproses foto.
  static const String processingPhoto = 'Memproses foto...';

  /// Teks saat GPS di luar radius.
  static const String errorGpsOutOfRange = 'Kamu berada di luar radius checkpoint';

  /// Judul section pemilihan checkpoint.
  static const String wasteCheckpointTitle = 'Checkpoint';

  /// Nama checkpoint TPS kelurahan.
  static const String wasteCheckpointTps = 'TPS Kelurahan';

  /// Alamat checkpoint TPS kelurahan.
  static const String wasteCheckpointTpsAddress = 'Jl. Melati No. 12, RT 05';

  /// Nama checkpoint bank sampah.
  static const String wasteCheckpointBank = 'Bank Sampah Berseri';

  /// Alamat checkpoint bank sampah.
  static const String wasteCheckpointBankAddress = 'Jl. Kenanga No. 3, RT 03';

  /// Judul kartu status lokasi.
  static const String wasteGpsTitle = 'Lokasi kamu';

  /// Status GPS dalam radius checkpoint.
  static const String wasteGpsInRadius = 'Dalam radius checkpoint (100 m)';

  /// Disclaimer antikecurangan di bawah tombol ambil foto.
  static const String gpsDisclaimerHint =
      'Foto, timestamp server, dan GPS diverifikasi otomatis.';

  /// Pesan user berada di luar radius checkpoint.
  static const String wasteGpsOutOfRadius =
      'Kamu berada di luar radius checkpoint (maks 100 m). Dekat ke lokasi checkpoint lalu ambil ulang.';

  /// Label singkat status lokasi "di luar radius" pada kartu status GPS.
  static const String wasteGpsOutsideLabel = 'Di luar radius';

  /// Pesan foto sudah pernah dikirim (hash duplikat).
  static const String errorPhotoDuplicate =
      'Foto ini sudah pernah dikirim sebelumnya.';

  /// Pesan melebihi batas kirim per hari.
  static const String errorRateLimitReached =
      'Kamu sudah mencapai batas kirim hari ini. Coba lagi besok.';

  /// Label indikator foto sudah terpasang pada container upload.
  static const String photoAttachedLabel = 'Foto terpasang';

  /// Judul halaman ambil foto.
  static const String captureTitle = 'Ambil Foto';

  /// Pesan kamera tidak tersedia.
  static const String captureUnavailable = 'Kamera tidak tersedia di perangkat ini.';

  /// Pesan izin kamera ditolak.
  static const String capturePermissionDenied =
      'Izin kamera belum diberikan. Aktifkan lewat pengaturan perangkat.';

  /// Pesan foto berhasil diambil.
  static const String captureSuccess = 'Foto berhasil diambil.';

  /// Tooltip tombol balik kamera.
  static const String captureFlipButton = 'Balik kamera';

  /// Petunjuk menekan tombol shutter.
  static const String captureHint = 'Tekan tombol untuk mengambil foto bukti.';

  /// Tooltip flash mati.
  static const String captureFlashOff = 'Flash mati';

  /// Tooltip flash otomatis.
  static const String captureFlashAuto = 'Flash otomatis';

  /// Tooltip flash menyala.
  static const String captureFlashOn = 'Flash menyala';

  /// Tombol coba lagi untuk izin kamera.
  static const String captureRetryButton = 'Coba Lagi';

  /// Label aksi scan QR dari halaman buang sampah.
  static const String wasteScanHint = 'Scan QR di checkpoint';

  /// --- Scan ---

  /// Judul halaman scan QR.
  static const String scanTitle = 'Scan QR';

  /// Petunjuk scan QR.
  static const String scanHint = 'Arahkan kamera ke QR code checkpoint';

  /// Catatan bawah halaman scan.
  static const String scanNote =
      'QR button verifikasi lokasi sebelum membuang sampah.';

  /// --- Points ---

  /// Judul halaman poin.
  static const String pointsTitle = 'Poin & Reward';

  /// Label saldo poin.
  static const String pointsBalance = 'Total Poin';

  /// Judul section daftar reward.
  static const String rewardsSectionTitle = 'Reward';

  /// Judul section riwayat poin.
  static const String pointsHistoryTitle = 'Riwayat Poin';

  /// Pesan saat riwayat poin masih kosong.
  static const String pointsHistoryEmpty = 'Belum ada riwayat poin.';

  /// Nama reward paket sembako.
  static const String rewardSembako = 'Paket Sembako';

  /// Deskripsi reward paket sembako.
  static const String rewardSembakoDesc = 'Bahan pokok untuk kebutuhan mingguan.';

  /// Nama reward voucher belanja.
  static const String rewardVoucher = 'Voucher Belanja';

  /// Deskripsi reward voucher belanja.
  static const String rewardVoucherDesc = 'Voucher belanja senilai 50 ribu rupiah.';

  /// Nama reward saldo e-wallet.
  static const String rewardWallet = 'Saldo E-Wallet';

  /// Deskripsi reward saldo e-wallet.
  static const String rewardWalletDesc = 'Isi saldo GoPay, OVO, atau DANA.';

  /// Nama reward donasi lingkungan.
  static const String rewardDonasi = 'Donasi Lingkungan';

  /// Deskripsi reward donasi lingkungan.
  static const String rewardDonasiDesc = 'Salurkan poin untuk penghijauan kota.';

  /// Label satuan harga reward.
  static const String rewardPointSuffix = 'Poin';

  /// Judul halaman detail reward.
  static const String rewardDetailTitle = 'Detail Reward';

  /// Tombol tukar di halaman detail reward.
  static const String rewardExchangeButton = 'Tukar';

  /// Deskripsi benefit reward.
  static const String rewardBenefitLabel = 'Yang kamu dapat';

  /// Label item harga reward di detail.
  static const String rewardDetailCostLabel = 'Harga';

  /// --- Activity ---

  /// Judul halaman aktivitas.
  static const String activityTitle = 'Aktivitas';

  /// Status aktivitas berhasil.
  static const String activityStatusSuccess = 'Berhasil';

  /// Status aktivitas menunggu verifikasi.
  static const String activityStatusPending = 'Menunggu verifikasi';

  /// Deskripsi aktivitas demo pertama.
  static const String activityDemoDesc1 = 'Buang sampah organik di TPS Kelurahan';

  /// Deskripsi aktivitas demo kedua.
  static const String activityDemoDesc2 = 'Buang sampah untuk daur ulang di Bank Sampah';

  /// Judul empty state aktivitas kosong.
  static const String activityEmptyTitle = 'Belum ada aktivitas';

  /// Pesan empty state aktivitas kosong.
  static const String activityEmptyMessage =
      'Mulai buang sampah untuk melihat riwayatmu di sini.';

  /// Judul halaman detail aktivitas.
  static const String activityDetailTitle = 'Detail Aktivitas';

  /// Label tanggal di detail aktivitas.
  static const String activityDetailDateLabel = 'Tanggal';

  /// Label checkpoint di detail aktivitas.
  static const String activityDetailCheckpointLabel = 'Checkpoint';

  /// Label poin di detail aktivitas.
  static const String activityDetailPointLabel = 'Poin';

  /// Label status di header detail aktivitas.
  static const String activityStatusTitle = 'Status';

  /// Awalan deskripsi aktivitas dari waste log ("Buang sampah ...").
  static const String activityLogPrefix = 'Buang sampah';

  /// Kata sambung deskripsi aktivitas ("... di ...").
  static const String activityLogAt = 'di';

  /// --- Article ---

  /// Judul halaman artikel.
  static const String articleTitle = 'Artikel';

  /// --- Profile ---

  /// Judul halaman profile.
  static const String profileTitle = 'Profil';

  /// Teks notice login di halaman Profile saat belum login.
  static const String profileLoginNotice =
      'Masuk atau daftar untuk menyimpan data dan menukar poin.';

  /// Email tampilan sementara sebelum data user tersedia.
  static const String profileDemoEmail = 'warga@go-green.id';

  /// Label statistik total poin.
  static const String profileStatsPoints = 'Total Poin';

  /// Label statistik total buang sampah.
  static const String profileStatsWaste = 'Total Buang';

  /// Ahli reward yang belum tersedia.
  static const String menuNotAvailable = 'Fitur ini belum tersedia.';

  /// Label tombol simpan di Edit Profil.
  static const String saveButton = 'Simpan';

  /// Pesan profil berhasil disimpan.
  static const String profileSaved = 'Profil berhasil disimpan.';

  /// Caption Edit Profil.
  static const String editProfileCaption =
      'Perbarui informasi akun kamu di sini.';

  /// Menu edit profil.
  static const String editProfile = 'Edit Profil';

  /// Judul section akun di Pengaturan.
  static const String settingsAccountTitle = 'Akun';

  /// Judul section preferensi di Pengaturan.
  static const String settingsPreferencesTitle = 'Preferensi';

  /// Label notifikasi di Pengaturan.
  static const String settingsNotification = 'Notifikasi';

  /// Deskripsi notifikasi di Pengaturan.
  static const String settingsNotificationDesc =
      'Ingatkan saat ada poin baru atau reward.';

  /// Judul section informasi di Pengaturan.
  static const String settingsInfoTitle = 'Informasi';

  /// Label versi aplikasi di Pengaturan.
  static const String settingsVersion = 'Versi Aplikasi';

  /// Nilai versi aplikasi.
  static const String settingsVersionValue = '0.1.0';

  /// Label tentang aplikasi di Pengaturan.
  static const String settingsAbout = 'Tentang Go Green';

  /// Judul dialog konfirmasi penukaran reward.
  static const String redeemConfirmTitle = 'Konfirmasi Penukaran';

  /// Pesan dialog konfirmasi penukaran reward.
  static const String redeemConfirmMessage =
      'Kamu akan menukar poin untuk reward ini. Lanjutkan?';

  /// Pesan reward berhasil ditukar.
  static const String redeemSuccess = 'Reward berhasil ditukar.';

  /// Tombol batal pada dialog.
  static const String cancelButton = 'Batal';

  /// Menu pengaturan.
  static const String settings = 'Pengaturan';

  /// Tombol logout.
  static const String logout = 'Keluar';

  /// --- Verification ---

  /// Judul halaman verifikasi.
  static const String verificationTitle = 'Verifikasi';

  /// Status verifikasi berhasil.
  static const String verificationSuccess = 'Foto terverifikasi';

  /// Status verifikasi gagal.
  static const String verificationFailed = 'Verifikasi gagal';

  /// Status menunggu approval.
  static const String verificationPending = 'Menunggu verifikasi manual';

  /// Label detail timestamp.
  static const String verificationTimestampLabel = 'Timestamp';

  /// Label detail lokasi.
  static const String verificationLocationLabel = 'Lokasi';

  /// Label detail hash.
  static const String verificationHashLabel = 'Hash SHA-256';

  /// Label estimasi poin.
  static const String verificationPointsLabel = 'Estimasi Poin';

  /// Tombol konfirmasi kirim.
  static const String verificationSubmitButton = 'Konfirmasi Kirim';

  /// Label tombol lihat detail hash.
  static const String verificationHashButton = 'Lihat Detail Hash';

  /// Nilai timestamp demo (server) sebelum integrasi.
  static const String verificationTimestampDemo = '12 Sep 2026, 14.32 WIB';

  /// Nilai lokasi demo sebelum integrasi GPS.
  static const String verificationLocationDemo = 'TPS Kelurahan (dalam 100 m)';

  /// Pesan saat lokasi GPS tidak dapat diambil.
  static const String verificationLocationFailed =
      'Lokasi tidak dapat diambil. Pastikan GPS aktif.';

  /// Nilai hash demo sebelum integrasi.
  static const String verificationHashDemo =
      'a3f1c8e92b7d44e0a5f6c12b9d3e7f8a3c5d9e1f7b2a4c6d8e0f1a3b5c7d9e1f3';

  /// Estimasi poin demo.
  static const int verificationPointsDemo = 25;

  /// --- Onboarding ---

  /// Judul slide onboarding pertama.
  static const String onboardingTitle1 = 'Buang Sampah dengan Benar';

  /// Deskripsi slide onboarding pertama.
  static const String onboardingDesc1 = 'Buang sampah di checkpoint terdaftar dan dapatkan poin.';

  /// Judul slide onboarding kedua.
  static const String onboardingTitle2 = 'Tukar Poin Jadi Reward';

  /// Deskripsi slide onboarding kedua.
  static const String onboardingDesc2 = 'Tukarkan poin dengan sembako, voucher, dan e-wallet.';

  /// Judul slide onboarding ketiga.
  static const String onboardingTitle3 = 'Dampak untuk Bumi';

  /// Deskripsi slide onboarding ketiga.
  static const String onboardingDesc3 = 'Setiap buang sampah dengan benar mengurangi tumpukan liar dan menjaga lingkungan.';

  /// Tombol mulai.
  static const String startButton = 'Mulai';

  /// Tombol selanjutnya.
  static const String nextButton = 'Selanjutnya';

  /// Tombol lewati onboarding.
  static const String onboardingSkip = 'Lewati';

  /// Tombol kembali (generic).
  static const String backButton = 'Kembali';

  /// Tombol coba lagi.
  static const String retryButton = 'Coba Lagi';

  /// Teks sedaang memuat.
  static const String loading = 'Memuat...';

  /// Teks generic error.
  static const String genericError = 'Terjadi kesalahan. Silakan coba lagi.';

  /// Judul section kategori sampah di halaman Buang Sampah.
  static const String wasteCategoryTitle = 'Kategori Sampah';

  /// Label kategori organik.
  static const String wasteCategoryOrganik = 'Organik';

  /// Label kategori anorganik.
  static const String wasteCategoryAnorganik = 'Anorganik';

  /// Label kategori daur ulang.
  static const String wasteCategoryDaurUlang = 'Daur Ulang';

  /// Label kategori B3.
  static const String wasteCategoryB3 = 'B3';

  /// Pesan saat daftar checkpoint kosong.
  static const String wasteCheckpointEmpty =
      'Belum ada checkpoint di sekitarmu. Coba muat ulang.';

  /// Pesan saat daftar checkpoint gagal dimuat.
  static const String wasteCheckpointError =
      'Gagal memuat checkpoint. Periksa koneksi lalu coba lagi.';

  /// Pesan saat posisi GPS tidak dapat diambil di halaman Waste.
  static const String wastePositionFailed =
      'Lokasi tidak dapat diambil. Pastikan GPS aktif lalu muat ulang.';

  /// Pesan wajib login sebelum kirim bukti.
  static const String wasteNeedLogin =
      'Masuk dulu untuk mengirim bukti buang sampah.';

  /// Pesan kirim bukti berhasil.
  static const String wasteSubmitSuccess = 'Bukti terkirim. Poin menunggumu.';

  /// Hint jarak checkpoint pada daftar.
  static const String wasteDistanceHint = 'jarak';
}