// String UI aplikasi (dwibahasa Indonesia/Inggris).

/// String UI aplikasi Go Green (ID/EN sesuai [AppStrings.locale]).
class AppStrings {
  AppStrings._();

  /// Kode bahasa aktif ('id' atau 'en').
  static String _localeCode = 'id';

  /// Atur bahasa aktif untuk seluruh string UI.
  static set locale(String code) {
    _localeCode = code == 'en' ? 'en' : 'id';
  }

  /// Kode bahasa aktif saat ini.
  static String get locale => _localeCode;

  /// Ambil string [key] sesuai bahasa aktif (fallback Indonesia).
  static String _t(String key) {
    if (_localeCode == 'en') return _en[key] ?? _id[key] ?? key;
    return _id[key] ?? key;
  }

  /// Nama aplikasi.
  static String get appName => _t('appName');

  /// --- Auth ---

  /// Judul halaman login.
  static String get loginTitle => _t('loginTitle');

  /// Subjudul halaman login.
  static String get loginSubtitle => _t('loginSubtitle');

  /// Label checkbox "ingat saya" di halaman login.
  static String get rememberMe => _t('rememberMe');

  /// Link "lupa kata sandi" di halaman login.
  static String get forgotPassword => _t('forgotPassword');

  /// Label input email.
  static String get emailLabel => _t('emailLabel');

  /// Hint input email.
  static String get emailHint => _t('emailHint');

  /// Label input password.
  static String get passwordLabel => _t('passwordLabel');

  /// Hint input password.
  static String get passwordHint => _t('passwordHint');

  /// Label tombol login.
  static String get loginButton => _t('loginButton');

  /// Label tombol masuk dengan Google (sekali klik).
  static String get loginWithGoogle => _t('loginWithGoogle');

  /// Pemisah "atau" antara login Google dan login email.
  static String get orDivider => _t('orDivider');

  /// Pesan saat login Google gagal.
  static String get errorGoogleLoginFailed => _t('errorGoogleLoginFailed');

  /// Petunjuk saat browser OAuth Google dibuka.
  static String get googleBrowserHint => _t('googleBrowserHint');

  /// Teks link ke halaman register.
  static String get registerPrompt => _t('registerPrompt');

  /// Judul halaman register.
  static String get registerTitle => _t('registerTitle');

  /// Subjudul halaman register.
  static String get registerSubtitle => _t('registerSubtitle');

  /// Label tombol register.
  static String get registerButton => _t('registerButton');

  /// Label tombol register dengan Google (sekali klik).
  static String get registerWithGoogle => _t('registerWithGoogle');

  /// Teks link ke halaman login.
  static String get loginPrompt => _t('loginPrompt');

  /// Pesan saat login gagal (email/password salah atau koneksi bermasalah).
  static String get errorLoginFailed => _t('errorLoginFailed');

  /// Pesan saat email sudah terdaftar.
  static String get errorEmailRegistered => _t('errorEmailRegistered');

  /// Pesan saat email/password salah.
  static String get errorLoginInvalid => _t('errorLoginInvalid');

  /// Pesan saat email belum dikonfirmasi.
  static String get errorEmailNotConfirmed => _t('errorEmailNotConfirmed');

  /// Pesan saat gagal karena tidak ada koneksi internet.
  static String get errorNetwork => _t('errorNetwork');

  /// Pesan saat kata sandi terlalu lemah.
  static String get errorWeakPassword => _t('errorWeakPassword');

  /// Pesan saat registrasi dibatasi sementara karena terlalu sering mencoba.
  static String get errorRateLimitExceeded => _t('errorRateLimitExceeded');

  /// Pesan setelah registrasi yang butuh konfirmasi email.
  static String get signUpConfirmationSent => _t('signUpConfirmationSent');

  /// Label input nama.
  static String get nameLabel => _t('nameLabel');

  /// Hint input nama.
  static String get nameHint => _t('nameHint');

  /// Error email tidak valid.
  static String get errorEmailInvalid => _t('errorEmailInvalid');

  /// Error password terlalu pendek.
  static String get errorPasswordTooShort => _t('errorPasswordTooShort');

  /// Error nama kosong.
  static String get errorNameRequired => _t('errorNameRequired');

  /// Error nama tampilan terlalu pendek.
  static String get errorDisplayNameTooShort => _t('errorDisplayNameTooShort');

  /// Label input username.
  static String get usernameLabel => _t('usernameLabel');

  /// Hint input username.
  static String get usernameHint => _t('usernameHint');

  /// Error username tidak valid.
  static String get errorUsernameInvalid => _t('errorUsernameInvalid');

  /// Error username sudah dipakai user lain.
  static String get errorUsernameTaken => _t('errorUsernameTaken');

  /// Label input login email atau username.
  static String get loginIdentityLabel => _t('loginIdentityLabel');

  /// Hint input login email atau username.
  static String get loginIdentityHint => _t('loginIdentityHint');

  /// Error login email/username kosong.
  static String get loginIdentityRequired => _t('loginIdentityRequired');

  /// Label input nomor telepon.
  static String get phoneLabel => _t('phoneLabel');

  /// Hint input nomor telepon.
  static String get phoneHint => _t('phoneHint');

  /// Error nomor telepon tidak valid.
  static String get errorPhoneInvalid => _t('errorPhoneInvalid');

  /// Label input konfirmasi password.
  static String get confirmPasswordLabel => _t('confirmPasswordLabel');

  /// Hint input konfirmasi password.
  static String get confirmPasswordHint => _t('confirmPasswordHint');

  /// Error email wajib diisi.
  static String get errorEmailRequired => _t('errorEmailRequired');

  /// Error password wajib diisi.
  static String get errorPasswordRequired => _t('errorPasswordRequired');

  /// Error password tidak cocok.
  static String get errorPasswordMismatch => _t('errorPasswordMismatch');

  /// --- Home ---

  /// Sapaan di header Home.
  static String get greeting => _t('greeting');

  /// Nama tampilan sementara sebelum data user tersedia.
  static String get guestName => _t('guestName');

  /// Teks notice login yang bisa dilewati di Home.
  static String get homeLoginNotice => _t('homeLoginNotice');

  /// Label aksi Masuk pada notice login di Home.
  static String get homeLoginNoticeAction => _t('homeLoginNoticeAction');

  /// Label tooltip menutup notice login di Home.
  static String get homeLoginNoticeDismiss => _t('homeLoginNoticeDismiss');

  /// Himbauan saat back pertama di tab Home untuk keluar aplikasi.
  static String get backToExitHint => _t('backToExitHint');

  /// Judul section aksi cepat di Home.
  static String get homeQuickActionsTitle => _t('homeQuickActionsTitle');

  /// Judul section menu utama di Home.
  static String get homeMenuTitle => _t('homeMenuTitle');

  /// Judul hero banner di Home.
  static String get homeHeroTitle => _t('homeHeroTitle');

  /// Deskripsi hero banner di Home.
  static String get homeHeroSubtitle => _t('homeHeroSubtitle');

  /// Label tombol aksi hero banner di Home.
  static String get homeHeroCta => _t('homeHeroCta');

  /// Label kecil di atas judul hero banner Home (Stitch).
  static String get homeHeroEyebrow => _t('homeHeroEyebrow');

  /// Judul hero slide tukar reward di Home.
  static String get homeHero2Title => _t('homeHero2Title');

  /// Deskripsi hero slide tukar reward di Home.
  static String get homeHero2Subtitle => _t('homeHero2Subtitle');

  /// Label tombol hero slide tukar reward di Home.
  static String get homeHero2Cta => _t('homeHero2Cta');

  /// Label kecil hero slide tukar reward di Home.
  static String get homeHero2Eyebrow => _t('homeHero2Eyebrow');

  /// Judul hero slide misi mingguan di Home.
  static String get homeHero3Title => _t('homeHero3Title');

  /// Deskripsi hero slide misi mingguan di Home.
  static String get homeHero3Subtitle => _t('homeHero3Subtitle');

  /// Label tombol hero slide misi mingguan di Home.
  static String get homeHero3Cta => _t('homeHero3Cta');

  /// Label kecil hero slide misi mingguan di Home.
  static String get homeHero3Eyebrow => _t('homeHero3Eyebrow');

  /// Judul kartu ringkasan poin di Home (Stitch).
  static String get homeTotalPointsTitle => _t('homeTotalPointsTitle');

  /// Subjudul kartu poin Home V3 minimalist.
  static String get homePointsSubtitle => _t('homePointsSubtitle');

  /// Tombol tukar reward di kartu poin Home.
  static String get homeExchangeReward => _t('homeExchangeReward');

  /// Tombol lihat riwayat di kartu poin Home.
  static String get homeViewHistory => _t('homeViewHistory');

  /// Pesan aktivitas kosong di Home (user login tanpa riwayat).
  static String get homeActivityEmpty => _t('homeActivityEmpty');

  /// Pesan aktivitas kosong di Home khusus tamu (ajakan masuk).
  static String get homeActivityEmptyGuest => _t('homeActivityEmptyGuest');

  /// Judul misi mingguan di Home.
  static String get homeMissionTitle => _t('homeMissionTitle');

  /// Deskripsi misi mingguan di Home.
  static String get homeMissionDesc => _t('homeMissionDesc');

  /// Judul section aktivitas terkini di Home.
  static String get homeLatestActivity => _t('homeLatestActivity');

  /// Label ringkas lihat semua (Stitch memakai kata pendek).
  static String get seeAllShort => _t('seeAllShort');

  /// Label status terverifikasi di Home.
  static String get homeVerifiedLabel => _t('homeVerifiedLabel');

  /// Label stat hitungan buang di Home (data asli).
  static String get homeStatTimesLabel => _t('homeStatTimesLabel');

  /// Label stat buang minggu ini di Home (data asli).
  static String get homeStatWeekLabel => _t('homeStatWeekLabel');

  /// Satuan hitungan misi mingguan di Home.
  static String get homeMissionTimesUnit => _t('homeMissionTimesUnit');

  /// Akhiran progres terkumpul misi mingguan di Home.
  static String get homeMissionCollectedSuffix => _t('homeMissionCollectedSuffix');

  /// Awalan target misi mingguan di Home.
  static String get homeMissionTargetPrefix => _t('homeMissionTargetPrefix');

  /// Judul section artikel dan edukasi di Home.
  static String get homeArticleSection => _t('homeArticleSection');

  /// Deskripsi kartu aksi buang sampah.
  static String get quickActionWasteDesc => _t('quickActionWasteDesc');

  /// Judul kartu aksi lihat poin.
  static String get quickActionPointsTitle => _t('quickActionPointsTitle');

  /// Deskripsi kartu aksi lihat poin.
  static String get quickActionPointsDesc => _t('quickActionPointsDesc');

  /// Judul section artikel terbaru di Home.
  static String get homeRecentArticles => _t('homeRecentArticles');

  /// Label link lihat semua.
  static String get seeAll => _t('seeAll');

  /// Judul artikel demo pertama di Home.
  static String get homeArticle1Title => _t('homeArticle1Title');

  /// Ringkasan artikel demo pertama di Home.
  static String get homeArticle1Excerpt => _t('homeArticle1Excerpt');

  /// Judul artikel demo kedua di Home.
  static String get homeArticle2Title => _t('homeArticle2Title');

  /// Ringkasan artikel demo kedua di Home.
  static String get homeArticle2Excerpt => _t('homeArticle2Excerpt');

  /// Judul artikel demo ketiga di daftar Artikel.
  static String get homeArticle3Title => _t('homeArticle3Title');

  /// Ringkasan artikel demo ketiga.
  static String get homeArticle3Excerpt => _t('homeArticle3Excerpt');

  /// Judul artikel demo keempat di daftar Artikel.
  static String get homeArticle4Title => _t('homeArticle4Title');

  /// Ringkasan artikel demo keempat.
  static String get homeArticle4Excerpt => _t('homeArticle4Excerpt');

  /// Paragraf demo konten artikel (semua artikel di MVP).
  static String get articleContentP1 => _t('articleContentP1');

  /// Paragraf demo kedua konten artikel.
  static String get articleContentP2 => _t('articleContentP2');

  /// Paragraf demo ketiga konten artikel.
  static String get articleContentP3 => _t('articleContentP3');

  /// Hint pencarian artikel.
  static String get articleSearchHint => _t('articleSearchHint');

  /// Judul empty state pencarian artikel tanpa hasil.
  static String get articleNoResultsTitle => _t('articleNoResultsTitle');

  /// Pesan empty state pencarian artikel tanpa hasil.
  static String get articleNoResultsMessage => _t('articleNoResultsMessage');

  /// Judul bottom nav home.
  static String get navHome => _t('navHome');

  /// Judul bottom nav activity.
  static String get navActivity => _t('navActivity');

  /// Judul bottom nav waste.
  static String get navWaste => _t('navWaste');

  /// Judul bottom nav points.
  static String get navPoints => _t('navPoints');

  /// Judul bottom nav profile.
  static String get navProfile => _t('navProfile');

  /// --- Waste ---

  /// Judul halaman buang sampah.
  static String get wasteTitle => _t('wasteTitle');

  /// Label tombol ambil foto.
  static String get takePhotoButton => _t('takePhotoButton');

  /// Teks saat memproses foto.
  static String get processingPhoto => _t('processingPhoto');

  /// Teks saat GPS di luar radius.
  static String get errorGpsOutOfRange => _t('errorGpsOutOfRange');

  /// Judul section pemilihan checkpoint.
  static String get wasteCheckpointTitle => _t('wasteCheckpointTitle');

  /// Nama checkpoint TPS kelurahan.
  static String get wasteCheckpointTps => _t('wasteCheckpointTps');

  /// Alamat checkpoint TPS kelurahan.
  static String get wasteCheckpointTpsAddress => _t('wasteCheckpointTpsAddress');

  /// Nama checkpoint bank sampah.
  static String get wasteCheckpointBank => _t('wasteCheckpointBank');

  /// Alamat checkpoint bank sampah.
  static String get wasteCheckpointBankAddress => _t('wasteCheckpointBankAddress');

  /// Judul kartu status lokasi.
  static String get wasteGpsTitle => _t('wasteGpsTitle');

  /// Status GPS dalam radius checkpoint.
  static String get wasteGpsInRadius => _t('wasteGpsInRadius');

  /// Disclaimer antikecurangan di bawah tombol ambil foto.
  static String get gpsDisclaimerHint => _t('gpsDisclaimerHint');

  /// Pesan user berada di luar radius checkpoint.
  static String get wasteGpsOutOfRadius => _t('wasteGpsOutOfRadius');

  /// Label singkat status lokasi "di luar radius" pada kartu status GPS.
  static String get wasteGpsOutsideLabel => _t('wasteGpsOutsideLabel');

  /// Pesan foto sudah pernah dikirim (hash duplikat).
  static String get errorPhotoDuplicate => _t('errorPhotoDuplicate');

  /// Pesan melebihi batas kirim per hari.
  static String get errorRateLimitReached => _t('errorRateLimitReached');

  /// Label indikator foto sudah terpasang pada container upload.
  static String get photoAttachedLabel => _t('photoAttachedLabel');

  /// Judul halaman ambil foto.
  static String get captureTitle => _t('captureTitle');

  /// Pesan kamera tidak tersedia.
  static String get captureUnavailable => _t('captureUnavailable');

  /// Pesan izin kamera ditolak.
  static String get capturePermissionDenied => _t('capturePermissionDenied');

  /// Pesan foto berhasil diambil.
  static String get captureSuccess => _t('captureSuccess');

  /// Tooltip tombol balik kamera.
  static String get captureFlipButton => _t('captureFlipButton');

  /// Petunjuk menekan tombol shutter.
  static String get captureHint => _t('captureHint');

  /// Tooltip flash mati.
  static String get captureFlashOff => _t('captureFlashOff');

  /// Tooltip flash otomatis.
  static String get captureFlashAuto => _t('captureFlashAuto');

  /// Tooltip flash menyala.
  static String get captureFlashOn => _t('captureFlashOn');

  /// Tombol coba lagi untuk izin kamera.
  static String get captureRetryButton => _t('captureRetryButton');

  /// Label aksi scan QR dari halaman buang sampah.
  static String get wasteScanHint => _t('wasteScanHint');

  /// --- Scan ---

  /// Judul halaman scan QR.
  static String get scanTitle => _t('scanTitle');

  /// Petunjuk scan QR.
  static String get scanHint => _t('scanHint');

  /// Catatan bawah halaman scan.
  static String get scanNote => _t('scanNote');

  /// --- Points ---

  /// Judul halaman poin.
  static String get pointsTitle => _t('pointsTitle');

  /// Label saldo poin.
  static String get pointsBalance => _t('pointsBalance');

  /// Judul section daftar reward.
  static String get rewardsSectionTitle => _t('rewardsSectionTitle');

  /// Judul section riwayat poin.
  static String get pointsHistoryTitle => _t('pointsHistoryTitle');

  /// Pesan saat riwayat poin masih kosong.
  static String get pointsHistoryEmpty => _t('pointsHistoryEmpty');

  /// Nama reward paket sembako.
  static String get rewardSembako => _t('rewardSembako');

  /// Deskripsi reward paket sembako.
  static String get rewardSembakoDesc => _t('rewardSembakoDesc');

  /// Nama reward voucher belanja.
  static String get rewardVoucher => _t('rewardVoucher');

  /// Deskripsi reward voucher belanja.
  static String get rewardVoucherDesc => _t('rewardVoucherDesc');

  /// Nama reward saldo e-wallet.
  static String get rewardWallet => _t('rewardWallet');

  /// Deskripsi reward saldo e-wallet.
  static String get rewardWalletDesc => _t('rewardWalletDesc');

  /// Nama reward donasi lingkungan.
  static String get rewardDonasi => _t('rewardDonasi');

  /// Deskripsi reward donasi lingkungan.
  static String get rewardDonasiDesc => _t('rewardDonasiDesc');

  /// Label satuan harga reward.
  static String get rewardPointSuffix => _t('rewardPointSuffix');

  /// Judul halaman detail reward.
  static String get rewardDetailTitle => _t('rewardDetailTitle');

  /// Tombol tukar di halaman detail reward.
  static String get rewardExchangeButton => _t('rewardExchangeButton');

  /// Deskripsi benefit reward.
  static String get rewardBenefitLabel => _t('rewardBenefitLabel');

  /// Label item harga reward di detail.
  static String get rewardDetailCostLabel => _t('rewardDetailCostLabel');

  /// --- Activity ---

  /// Judul halaman aktivitas.
  static String get activityTitle => _t('activityTitle');

  /// Status aktivitas berhasil.
  static String get activityStatusSuccess => _t('activityStatusSuccess');

  /// Status aktivitas menunggu verifikasi.
  static String get activityStatusPending => _t('activityStatusPending');

  /// Deskripsi aktivitas demo pertama.
  static String get activityDemoDesc1 => _t('activityDemoDesc1');

  /// Deskripsi aktivitas demo kedua.
  static String get activityDemoDesc2 => _t('activityDemoDesc2');

  /// Judul empty state aktivitas kosong.
  static String get activityEmptyTitle => _t('activityEmptyTitle');

  /// Pesan empty state aktivitas kosong.
  static String get activityEmptyMessage => _t('activityEmptyMessage');

  /// Judul halaman detail aktivitas.
  static String get activityDetailTitle => _t('activityDetailTitle');

  /// Label tanggal di detail aktivitas.
  static String get activityDetailDateLabel => _t('activityDetailDateLabel');

  /// Label checkpoint di detail aktivitas.
  static String get activityDetailCheckpointLabel => _t('activityDetailCheckpointLabel');

  /// Label poin di detail aktivitas.
  static String get activityDetailPointLabel => _t('activityDetailPointLabel');

  /// Label status di header detail aktivitas.
  static String get activityStatusTitle => _t('activityStatusTitle');

  /// Awalan deskripsi aktivitas dari waste log ("Buang sampah ...").
  static String get activityLogPrefix => _t('activityLogPrefix');

  /// Kata sambung deskripsi aktivitas ("... di ...").
  static String get activityLogAt => _t('activityLogAt');

  /// --- Article ---

  /// Judul halaman artikel.
  static String get articleTitle => _t('articleTitle');

  /// --- Profile ---

  /// Judul halaman profile.
  static String get profileTitle => _t('profileTitle');

  /// Teks notice login di halaman Profile saat belum login.
  static String get profileLoginNotice => _t('profileLoginNotice');

  /// Email tampilan sementara sebelum data user tersedia.
  static String get profileDemoEmail => _t('profileDemoEmail');

  /// Label statistik total poin.
  static String get profileStatsPoints => _t('profileStatsPoints');

  /// Label statistik total buang sampah.
  static String get profileStatsWaste => _t('profileStatsWaste');

  /// Ahli reward yang belum tersedia.
  static String get menuNotAvailable => _t('menuNotAvailable');

  /// Label tombol simpan di Edit Profil.
  static String get saveButton => _t('saveButton');

  /// Pesan profil berhasil disimpan.
  static String get profileSaved => _t('profileSaved');

  /// Caption Edit Profil.
  static String get editProfileCaption => _t('editProfileCaption');

  /// Menu edit profil.
  static String get editProfile => _t('editProfile');

  /// Judul section akun di Pengaturan.
  static String get settingsAccountTitle => _t('settingsAccountTitle');

  /// Judul section preferensi di Pengaturan.
  static String get settingsPreferencesTitle => _t('settingsPreferencesTitle');

  /// Label notifikasi di Pengaturan.
  static String get settingsNotification => _t('settingsNotification');

  /// Deskripsi notifikasi di Pengaturan.
  static String get settingsNotificationDesc => _t('settingsNotificationDesc');

  /// Judul section informasi di Pengaturan.
  static String get settingsInfoTitle => _t('settingsInfoTitle');

  /// Label versi aplikasi di Pengaturan.
  static String get settingsVersion => _t('settingsVersion');

  /// Nilai versi aplikasi.
  static String get settingsVersionValue => _t('settingsVersionValue');

  /// Label tentang aplikasi di Pengaturan.
  static String get settingsAbout => _t('settingsAbout');

  /// Judul pemilih bahasa di pengaturan.
  static String get settingsLanguage => _t('settingsLanguage');

  /// Label Bahasa Indonesia di pemilih bahasa.
  static String get languageIndonesian => _t('languageIndonesian');

  /// Label Bahasa Inggris di pemilih bahasa.
  static String get languageEnglish => _t('languageEnglish');

  /// Nama channel notifikasi Android.
  static String get notifChannelName => _t('notifChannelName');

  /// Deskripsi channel notifikasi Android.
  static String get notifChannelDesc => _t('notifChannelDesc');

  /// Judul dialog konfirmasi penukaran reward.
  static String get redeemConfirmTitle => _t('redeemConfirmTitle');

  /// Pesan dialog konfirmasi penukaran reward.
  static String get redeemConfirmMessage => _t('redeemConfirmMessage');

  /// Judul popup penukaran berhasil.
  static String get redeemSuccessTitle => _t('redeemSuccessTitle');

  /// Pesan popup penukaran berhasil.
  static String get redeemSuccessMessage => _t('redeemSuccessMessage');

  /// Tombol lihat voucher di popup sukses.
  static String get redeemGoVoucherButton => _t('redeemGoVoucherButton');

  /// Tombol tutup popup.
  static String get redeemCloseButton => _t('redeemCloseButton');

  /// Pesan wajib login sebelum tukar reward.
  static String get redeemNeedLogin => _t('redeemNeedLogin');

  /// Pesan kode voucher disalin ke clipboard.
  static String get redeemVoucherCopied => _t('redeemVoucherCopied');

  /// Pesan saldo poin tidak cukup untuk tukar reward.
  static String get redeemInsufficientPoints => _t('redeemInsufficientPoints');

  /// Pesan stok reward habis.
  static String get redeemOutOfStock => _t('redeemOutOfStock');

  /// Pesan gagal tukar reward.
  static String get redeemFailedMessage => _t('redeemFailedMessage');

  /// Label tombol saat proses tukar berjalan.
  static String get redeemLoadingLabel => _t('redeemLoadingLabel');

  /// Judul halaman voucher saya.
  static String get voucherTitle => _t('voucherTitle');

  /// Pesan voucher kosong.
  static String get voucherEmptyMessage => _t('voucherEmptyMessage');

  /// Status voucher menunggu.
  static String get voucherStatusPending => _t('voucherStatusPending');

  /// Status voucher disetujui.
  static String get voucherStatusApproved => _t('voucherStatusApproved');

  /// Status voucher ditolak.
  static String get voucherStatusRejected => _t('voucherStatusRejected');

  /// Status voucher diklaim.
  static String get voucherStatusClaimed => _t('voucherStatusClaimed');

  /// Tombol batal pada dialog.
  static String get cancelButton => _t('cancelButton');

  /// Menu pengaturan.
  static String get settings => _t('settings');

  /// Tombol logout.
  static String get logout => _t('logout');

  /// --- Verification ---

  /// Judul halaman verifikasi.
  static String get verificationTitle => _t('verificationTitle');

  /// Status verifikasi berhasil.
  static String get verificationSuccess => _t('verificationSuccess');

  /// Status verifikasi gagal.
  static String get verificationFailed => _t('verificationFailed');

  /// Status menunggu approval.
  static String get verificationPending => _t('verificationPending');

  /// Label detail timestamp.
  static String get verificationTimestampLabel => _t('verificationTimestampLabel');

  /// Label detail lokasi.
  static String get verificationLocationLabel => _t('verificationLocationLabel');

  /// Label detail hash.
  static String get verificationHashLabel => _t('verificationHashLabel');

  /// Label estimasi poin.
  static String get verificationPointsLabel => _t('verificationPointsLabel');

  /// Tombol konfirmasi kirim.
  static String get verificationSubmitButton => _t('verificationSubmitButton');

  /// Judul popup poin masuk.
  static String get pointsEarnedTitle => _t('pointsEarnedTitle');

  /// Pesan popup poin masuk.
  static String get pointsEarnedMessage => _t('pointsEarnedMessage');

  /// Tombol tutup popup poin masuk.
  static String get pointsEarnedButton => _t('pointsEarnedButton');

  /// Label tombol lihat detail hash.
  static String get verificationHashButton => _t('verificationHashButton');

  /// Nilai timestamp demo (server) sebelum integrasi.
  static String get verificationTimestampDemo => _t('verificationTimestampDemo');

  /// Nilai lokasi demo sebelum integrasi GPS.
  static String get verificationLocationDemo => _t('verificationLocationDemo');

  /// Pesan saat lokasi GPS tidak dapat diambil.
  static String get verificationLocationFailed => _t('verificationLocationFailed');

  /// Nilai hash demo sebelum integrasi.
  static String get verificationHashDemo => _t('verificationHashDemo');

  /// --- Onboarding ---

  /// Judul slide onboarding pertama.
  static String get onboardingTitle1 => _t('onboardingTitle1');

  /// Deskripsi slide onboarding pertama.
  static String get onboardingDesc1 => _t('onboardingDesc1');

  /// Judul slide onboarding kedua.
  static String get onboardingTitle2 => _t('onboardingTitle2');

  /// Deskripsi slide onboarding kedua.
  static String get onboardingDesc2 => _t('onboardingDesc2');

  /// Judul slide onboarding ketiga.
  static String get onboardingTitle3 => _t('onboardingTitle3');

  /// Deskripsi slide onboarding ketiga.
  static String get onboardingDesc3 => _t('onboardingDesc3');

  /// Tombol mulai.
  static String get startButton => _t('startButton');

  /// Tombol selanjutnya.
  static String get nextButton => _t('nextButton');

  /// Tombol lewati onboarding.
  static String get onboardingSkip => _t('onboardingSkip');

  /// Tombol kembali (generic).
  static String get backButton => _t('backButton');

  /// Tombol coba lagi.
  static String get retryButton => _t('retryButton');

  /// Teks sedaang memuat.
  static String get loading => _t('loading');

  /// Teks generic error.
  static String get genericError => _t('genericError');

  /// Judul section kategori sampah di halaman Buang Sampah.
  static String get wasteCategoryTitle => _t('wasteCategoryTitle');

  /// Label kategori organik.
  static String get wasteCategoryOrganik => _t('wasteCategoryOrganik');

  /// Label kategori anorganik.
  static String get wasteCategoryAnorganik => _t('wasteCategoryAnorganik');

  /// Label kategori daur ulang.
  static String get wasteCategoryDaurUlang => _t('wasteCategoryDaurUlang');

  /// Label kategori B3.
  static String get wasteCategoryB3 => _t('wasteCategoryB3');

  /// Pesan saat daftar checkpoint kosong.
  static String get wasteCheckpointEmpty => _t('wasteCheckpointEmpty');

  /// Pesan saat daftar checkpoint gagal dimuat.
  static String get wasteCheckpointError => _t('wasteCheckpointError');

  /// Pesan saat posisi GPS tidak dapat diambil di halaman Waste.
  static String get wastePositionFailed => _t('wastePositionFailed');

  /// Pesan wajib login sebelum kirim bukti.
  static String get wasteNeedLogin => _t('wasteNeedLogin');

  /// Hint jarak checkpoint pada daftar.
  static String get wasteDistanceHint => _t('wasteDistanceHint');

  /// --- Admin ---
  static String get adminTitle => _t('adminTitle');
  static String get adminSubtitle => _t('adminSubtitle');
  static String get adminAccessDenied => _t('adminAccessDenied');
  static String get adminCheckpointsTitle => _t('adminCheckpointsTitle');
  static String get adminAddCheckpoint => _t('adminAddCheckpoint');
  static String get adminEditCheckpoint => _t('adminEditCheckpoint');
  static String get adminCheckpointEmpty => _t('adminCheckpointEmpty');
  static String get adminCheckpointNameLabel => _t('adminCheckpointNameLabel');
  static String get adminCheckpointNameHint => _t('adminCheckpointNameHint');
  static String get adminCheckpointAddressLabel => _t('adminCheckpointAddressLabel');
  static String get adminCheckpointLatLabel => _t('adminCheckpointLatLabel');
  static String get adminCheckpointLngLabel => _t('adminCheckpointLngLabel');
  static String get adminCheckpointRadiusLabel => _t('adminCheckpointRadiusLabel');
  static String get adminCheckpointQrLabel => _t('adminCheckpointQrLabel');
  static String get adminCheckpointMaxUsesLabel => _t('adminCheckpointMaxUsesLabel');
  static String get adminCheckpointMaxUsesHint => _t('adminCheckpointMaxUsesHint');
  static String get adminCheckpointMaxUsesInvalid => _t('adminCheckpointMaxUsesInvalid');
  static String get adminCheckpointRemainingLabel => _t('adminCheckpointRemainingLabel');
  static String get checkpointQuotaRemaining => _t('checkpointQuotaRemaining');
  static String get checkpointUnlimited => _t('checkpointUnlimited');
  static String get checkpointFull => _t('checkpointFull');
  static String get wasteCheckpointFull => _t('wasteCheckpointFull');
  static String get adminCheckpointNameEmpty => _t('adminCheckpointNameEmpty');
  static String get adminCheckpointLatInvalid => _t('adminCheckpointLatInvalid');
  static String get adminCheckpointLngInvalid => _t('adminCheckpointLngInvalid');
  static String get adminCheckpointRadiusInvalid => _t('adminCheckpointRadiusInvalid');
  static String get adminCheckpointSaved => _t('adminCheckpointSaved');
  static String get adminCheckpointDeleted => _t('adminCheckpointDeleted');
  static String get adminCheckpointDeleteTitle => _t('adminCheckpointDeleteTitle');
  static String get adminMapHint => _t('adminMapHint');
  static String get adminUseMyLocation => _t('adminUseMyLocation');

  /// Tombol buka pemilih peta layar penuh.
  static String get adminPickOnMap => _t('adminPickOnMap');

  /// Judul halaman pemilih peta layar penuh.
  static String get adminMapPickerTitle => _t('adminMapPickerTitle');

  /// Hint pemilih peta layar penuh.
  static String get adminMapPickerHint => _t('adminMapPickerHint');

  /// Tombol konfirmasi titik di pemilih peta.
  static String get adminUseThisLocation => _t('adminUseThisLocation');

  /// Judul dialog saat GPS perangkat mati.
  static String get adminEnableLocationTitle => _t('adminEnableLocationTitle');

  /// Pesan dialog saat GPS perangkat mati.
  static String get adminEnableLocationMessage => _t('adminEnableLocationMessage');

  /// Tombol buka pengaturan sistem dari dialog lokasi.
  static String get adminOpenSettings => _t('adminOpenSettings');

  /// Judul dialog saat izin lokasi ditolak permanen.
  static String get adminLocationPermissionTitle => _t('adminLocationPermissionTitle');

  /// Pesan dialog saat izin lokasi ditolak permanen.
  static String get adminLocationPermissionMessage => _t('adminLocationPermissionMessage');
  static String get adminTestLocationTitle => _t('adminTestLocationTitle');
  static String get adminTestLocationActive => _t('adminTestLocationActive');
  static String get adminTestLocationOff => _t('adminTestLocationOff');
  static String get adminTestLocationSet => _t('adminTestLocationSet');
  static String get adminTestLocationCleared => _t('adminTestLocationCleared');
  static String get adminVerificationTitle => _t('adminVerificationTitle');
  static String get adminVerificationEmpty => _t('adminVerificationEmpty');
  static String get adminApprove => _t('adminApprove');
  static String get adminReject => _t('adminReject');
  static String get adminMenuCheckpoint => _t('adminMenuCheckpoint');
  static String get adminMenuVerification => _t('adminMenuVerification');
  static String get adminMenuOpen => _t('adminMenuOpen');

  /// --- Admin Shell ---

  /// Judul dasbor admin.
  static String get adminDashboard => _t('adminDashboard');

  /// Menu kelola TPS.
  static String get adminManageTps => _t('adminManageTps');

  /// Menu verifikasi waste.
  static String get adminVerifyWaste => _t('adminVerifyWaste');

  /// Menu kelola reward.
  static String get adminManageReward => _t('adminManageReward');

  /// Menu kelola user.
  static String get adminManageUser => _t('adminManageUser');

  /// Menu pengaturan admin.
  static String get adminSettings => _t('adminSettings');

  /// Menu mode admin di profil.
  static String get adminMode => _t('adminMode');

  /// Menu kembali ke UI user dari shell admin (khusus role admin).
  static String get adminUserMode => _t('adminUserMode');

  /// Judul sheet semua menu admin dari navbar bawah.
  static String get adminMoreMenu => _t('adminMoreMenu');

  /// Pesan halaman admin fase 2 yang belum tersedia.
  static String get adminComingSoon => _t('adminComingSoon');

  /// Catatan kelola reward admin.
  static String get adminRewardManageNote => _t('adminRewardManageNote');

  /// Pesan reward kosong di admin.
  static String get adminRewardEmpty => _t('adminRewardEmpty');

  /// Label stok reward di admin.
  static String get adminRewardStockLabel => _t('adminRewardStockLabel');

  /// Label status aktif reward di admin.
  static String get adminRewardActiveLabel => _t('adminRewardActiveLabel');
  /// Label status nonaktif reward di admin.
  static String get adminRewardInactiveLabel =>
      _t('adminRewardInactiveLabel');

  /// Judul seksi forensik di detail verifikasi.
  static String get forensicTitle => _t('forensicTitle');

  /// Label skor risiko forensik.
  static String get forensicScoreLabel => _t('forensicScoreLabel');

  /// Risiko forensik rendah.
  static String get forensicLow => _t('forensicLow');

  /// Risiko forensik sedang.
  static String get forensicMedium => _t('forensicMedium');

  /// Risiko forensik tinggi.
  static String get forensicHigh => _t('forensicHigh');

  /// EXIF kamera utuh.
  static String get forensicExifOk => _t('forensicExifOk');

  /// EXIF bermasalah.
  static String get forensicExifBad => _t('forensicExifBad');

  /// Sinyal tanpa EXIF kamera.
  static String get forensicNoExif => _t('forensicNoExif');

  /// Sinyal jejak edit.
  static String get forensicEdited => _t('forensicEdited');

  /// Sinyal jauh dari checkpoint.
  static String get forensicFarGps => _t('forensicFarGps');

  /// Sinyal setoran beruntun.
  static String get forensicRapid => _t('forensicRapid');

  /// Forensik belum dinilai (data lama).
  static String get forensicUnassessed => _t('forensicUnassessed');

  /// Tombol tambah reward admin.
  static String get adminRewardAdd => _t('adminRewardAdd');

  /// Judul form tambah reward admin.
  static String get adminRewardAddTitle => _t('adminRewardAddTitle');

  /// Judul form ubah reward admin.
  static String get adminRewardEditTitle => _t('adminRewardEditTitle');

  /// Label nama reward di form admin.
  static String get adminRewardNameLabel => _t('adminRewardNameLabel');

  /// Label deskripsi reward di form admin.
  static String get adminRewardDescLabel => _t('adminRewardDescLabel');

  /// Label harga poin reward di form admin.
  static String get adminRewardCostLabel => _t('adminRewardCostLabel');

  /// Label stok reward di form admin.
  static String get adminRewardStockFieldLabel => _t('adminRewardStockFieldLabel');

  /// Label status aktif di form reward admin.
  static String get adminRewardActiveSwitch => _t('adminRewardActiveSwitch');

  /// Tombol simpan reward admin.
  static String get adminRewardSave => _t('adminRewardSave');

  /// Validasi nama reward kosong.
  static String get adminRewardNameEmpty => _t('adminRewardNameEmpty');

  /// Validasi harga poin reward.
  static String get adminRewardCostInvalid => _t('adminRewardCostInvalid');

  /// Validasi stok reward.
  static String get adminRewardStockInvalid => _t('adminRewardStockInvalid');

  /// Konfirmasi hapus reward admin.
  static String get adminRewardDeleteConfirm => _t('adminRewardDeleteConfirm');

  /// Tombol hapus reward admin.
  static String get adminRewardDelete => _t('adminRewardDelete');

  /// Pesan user kosong di admin.
  static String get adminUserEmpty => _t('adminUserEmpty');

  /// Label role di daftar user admin.
  static String get adminUserRoleLabel => _t('adminUserRoleLabel');

  /// Hint cari user admin (nama/email).
  static String get adminUserSearchHint => _t('adminUserSearchHint');

  /// Label filter semua role user admin.
  static String get adminUserFilterAll => _t('adminUserFilterAll');

  /// Judul detail user admin.
  static String get adminUserDetailTitle => _t('adminUserDetailTitle');

  /// Label total poin di detail user admin.
  static String get adminUserTotalPoints => _t('adminUserTotalPoints');

  /// Judul riwayat buang di detail user admin.
  static String get adminUserHistoryTitle => _t('adminUserHistoryTitle');

  /// Pesan riwayat kosong di detail user admin.
  static String get adminUserHistoryEmpty => _t('adminUserHistoryEmpty');

  /// Label ubah role di detail user admin.
  static String get adminUserChangeRole => _t('adminUserChangeRole');

  /// Cegahan admin mencabut role sendiri.
  static String get adminUserSelfDemoteBlocked => _t('adminUserSelfDemoteBlocked');

  /// Judul info aplikasi di pengaturan admin.
  static String get adminSettingsAppTitle => _t('adminSettingsAppTitle');

  /// Judul info anti-kecurangan di pengaturan admin.
  static String get adminSettingsSecurityTitle => _t('adminSettingsSecurityTitle');

  /// Judul info misi di pengaturan admin.
  static String get adminSettingsMissionTitle => _t('adminSettingsMissionTitle');

  /// Catatan pengaturan admin (tambah nilai kategori level kode).
  static String get adminSettingsPhaseNote => _t('adminSettingsPhaseNote');

  /// Label radius GPS di form pengaturan admin.
  static String get adminSettingsRadiusLabel => _t('adminSettingsRadiusLabel');

  /// Label penegakan radius di form pengaturan admin.
  static String get adminSettingsEnforceLabel => _t('adminSettingsEnforceLabel');

  /// Label batas harian di form pengaturan admin.
  static String get adminSettingsRateLabel => _t('adminSettingsRateLabel');

  /// Label target mingguan di form pengaturan admin.
  static String get adminSettingsTargetLabel => _t('adminSettingsTargetLabel');

  /// Label foto maksimal di form pengaturan admin.
  static String get adminSettingsPhotoLabel => _t('adminSettingsPhotoLabel');

  /// Tombol simpan pengaturan admin.
  static String get adminSettingsSave => _t('adminSettingsSave');

  /// Pesan sukses simpan pengaturan admin.
  static String get adminSettingsSaved => _t('adminSettingsSaved');

  /// Validasi radius GPS pengaturan admin.
  static String get adminSettingsRadiusInvalid => _t('adminSettingsRadiusInvalid');

  /// Validasi batas harian pengaturan admin.
  static String get adminSettingsRateInvalid => _t('adminSettingsRateInvalid');

  /// Validasi target mingguan pengaturan admin.
  static String get adminSettingsTargetInvalid => _t('adminSettingsTargetInvalid');

  /// Validasi foto maksimal pengaturan admin.
  static String get adminSettingsPhotoInvalid => _t('adminSettingsPhotoInvalid');

  /// Judul seksi bonus kategori di pengaturan admin.
  static String get adminSettingsBonusTitle => _t('adminSettingsBonusTitle');

  /// Label bonus organik di pengaturan admin.
  static String get adminSettingsBonusOrganik => _t('adminSettingsBonusOrganik');

  /// Label bonus anorganik di pengaturan admin.
  static String get adminSettingsBonusAnorganik => _t('adminSettingsBonusAnorganik');

  /// Label bonus daur ulang di pengaturan admin.
  static String get adminSettingsBonusDaurUlang => _t('adminSettingsBonusDaurUlang');

  /// Label bonus B3 di pengaturan admin.
  static String get adminSettingsBonusB3 => _t('adminSettingsBonusB3');

  /// Validasi bonus kategori pengaturan admin.
  static String get adminSettingsBonusInvalid => _t('adminSettingsBonusInvalid');

  /// --- Dasbor Admin ---

  /// Label total user.
  static String get adminTotalUsers => _t('adminTotalUsers');

  /// Label total TPS.
  static String get adminTotalTps => _t('adminTotalTps');

  /// Label waste hari ini.
  static String get adminWasteToday => _t('adminWasteToday');

  /// Label waste pending.
  static String get adminWastePending => _t('adminWastePending');

  /// Label poin beredar.
  static String get adminPointsCirculating => _t('adminPointsCirculating');

  /// Tombol tambah TPS di dasbor.
  static String get adminAddTps => _t('adminAddTps');

  /// Tombol lihat verifikasi pending di dasbor.
  static String get adminViewPending => _t('adminViewPending');

  /// Menu + judul halaman log audit admin.
  static String get adminAuditLog => _t('adminAuditLog');

  /// Pesan log audit kosong.
  static String get adminAuditEmpty => _t('adminAuditEmpty');

  /// Label aksi audit: tambah.
  static String get auditActionCreate => _t('auditActionCreate');

  /// Label aksi audit: ubah.
  static String get auditActionUpdate => _t('auditActionUpdate');

  /// Label aksi audit: hapus.
  static String get auditActionDelete => _t('auditActionDelete');

  /// Label aksi audit: aktifkan.
  static String get auditActionActivate => _t('auditActionActivate');

  /// Label aksi audit: nonaktifkan.
  static String get auditActionDeactivate => _t('auditActionDeactivate');

  /// Label aksi audit: setujui.
  static String get auditActionApprove => _t('auditActionApprove');

  /// Label aksi audit: tolak.
  static String get auditActionReject => _t('auditActionReject');

  /// Label aksi audit: ubah role.
  static String get auditActionChangeRole => _t('auditActionChangeRole');

  /// Label aksi audit: simpan pengaturan.
  static String get auditActionSaveSettings => _t('auditActionSaveSettings');

  /// Label entitas audit: reward.
  static String get auditEntityReward => _t('auditEntityReward');

  /// Label entitas audit: user.
  static String get auditEntityUser => _t('auditEntityUser');

  /// Label entitas audit: pengaturan.
  static String get auditEntitySettings => _t('auditEntitySettings');

  /// Label entitas audit: TPS.
  static String get auditEntityCheckpoint => _t('auditEntityCheckpoint');

  /// Label entitas audit: verifikasi.
  static String get auditEntityVerification => _t('auditEntityVerification');

  /// Judul grafik setoran 7 hari di dasbor admin.
  static String get adminChartTitle => _t('adminChartTitle');

  /// Pesan grafik kosong di dasbor admin.
  static String get adminChartEmpty => _t('adminChartEmpty');

  /// --- Kelola TPS ---

  /// Judul halaman kelola TPS.
  static String get adminEditTps => _t('adminEditTps');

  /// Hint pencarian TPS.
  static String get adminSearchTpsHint => _t('adminSearchTpsHint');

  /// Label kode QR di form TPS.
  static String get adminQrCodeLabel => _t('adminQrCodeLabel');

  /// Tombol tutup dialog umum.
  static String get closeButton => _t('closeButton');

  /// Tombol aktifkan kembali TPS.
  static String get adminActivate => _t('adminActivate');

  /// Label status aktif umum admin.
  static String get adminActiveLabel => _t('adminActiveLabel');

  /// Label status nonaktif umum admin.
  static String get adminInactiveLabel => _t('adminInactiveLabel');

  /// Petunjuk cetak QR di dialog checkpoint.
  static String get adminQrPrintHint => _t('adminQrPrintHint');

  /// Tooltip tombol lihat QR di kartu TPS.
  static String get adminQrShowTooltip => _t('adminQrShowTooltip');

  /// Judul pratinjau QR di form TPS.
  static String get adminQrPreviewTitle => _t('adminQrPreviewTitle');

  /// Catatan QR otomatis saat tambah TPS baru.
  static String get adminQrAutoNote => _t('adminQrAutoNote');

  /// Label kode TPS di form/daftar.
  static String get adminTpsCodeLabel => _t('adminTpsCodeLabel');

  /// Label dropdown provinsi.
  static String get adminRegionProvinceLabel => _t('adminRegionProvinceLabel');

  /// Label dropdown kota/kabupaten.
  static String get adminRegionCityLabel => _t('adminRegionCityLabel');

  /// Label dropdown kecamatan.
  static String get adminRegionDistrictLabel => _t('adminRegionDistrictLabel');

  /// Label input kelurahan (terisi otomatis dari peta, bisa diubah).
  static String get adminSubdistrictLabel => _t('adminSubdistrictLabel');

  /// Judul section filter wilayah di daftar TPS.
  static String get adminRegionFilterTitle => _t('adminRegionFilterTitle');

  /// Aksi nonaktifkan TPS.
  static String get adminDeactivate => _t('adminDeactivate');

  /// Judul dialog nonaktifkan TPS.
  static String get adminDeactivateTitle => _t('adminDeactivateTitle');

  /// --- Verifikasi Waste ---

  /// Filter hari ini.
  static String get adminFilterToday => _t('adminFilterToday');

  /// Filter 7 hari.
  static String get adminFilterWeek => _t('adminFilterWeek');

  /// Filter semua.
  static String get adminFilterAll => _t('adminFilterAll');

  /// Judul halaman detail verifikasi.
  static String get adminDetailTitle => _t('adminDetailTitle');

  /// Judul dialog alasan penolakan.
  static String get adminRejectReasonTitle => _t('adminRejectReasonTitle');

  /// Hint input alasan penolakan.
  static String get adminRejectReasonHint => _t('adminRejectReasonHint');

  /// Error alasan penolakan kosong.
  static String get adminRejectReasonEmpty => _t('adminRejectReasonEmpty');

  /// Pesan verifikasi disetujui.
  static String get adminVerifySuccess => _t('adminVerifySuccess');

  /// Pesan verifikasi ditolak.
  static String get adminRejectSuccess => _t('adminRejectSuccess');

  /// Label foto bukti.
  static String get adminPhotoLabel => _t('adminPhotoLabel');

  /// Label jarak ke checkpoint.
  static String get adminDistanceLabel => _t('adminDistanceLabel');

  /// Label hash SHA-256.
  static String get adminHashLabel => _t('adminHashLabel');

  /// Label kategori sampah.
  static String get adminCategoryLabel => _t('adminCategoryLabel');

  /// Label pengirim.
  static String get adminSubmitterLabel => _t('adminSubmitterLabel');

  /// Label timestamp server.
  static String get adminServerTimeLabel => _t('adminServerTimeLabel');

  /// Label lokasi.
  static String get adminLocationLabel => _t('adminLocationLabel');

  /// Label estimasi poin.
  static String get adminPointsEstimateLabel => _t('adminPointsEstimateLabel');

  /// Pesan foto tidak tersedia.
  static String get adminNoPhoto => _t('adminNoPhoto');

  /// Teks Indonesia per kunci (fallback).
  static const Map<String, String> _id = <String, String>{
    'appName': 'Go Green',
    'loginTitle': 'Masuk',
    'loginSubtitle': 'Ayo mulai kebiasaan hijau dan kumpulkan poin untuk reward.',
    'rememberMe': 'Ingat saya',
    'forgotPassword': 'Lupa kata sandi?',
    'emailLabel': 'Email',
    'emailHint': 'nama@email.com',
    'passwordLabel': 'Kata Sandi',
    'passwordHint': 'Minimal 6 karakter',
    'loginButton': 'Masuk',
    'loginWithGoogle': 'Masuk dengan Google',
    'orDivider': 'atau',
    'errorGoogleLoginFailed': 'Gagal masuk dengan Google. Coba lagi.',
    'googleBrowserHint': 'Lanjutkan login di browser, lalu kembali ke aplikasi.',
    'registerPrompt': 'Belum punya akun? Daftar di sini',
    'registerTitle': 'Daftar',
    'registerSubtitle': 'Buat akun untuk mulai membuang sampah dan menukar poin.',
    'registerButton': 'Daftar',
    'registerWithGoogle': 'Daftar dengan Google',
    'loginPrompt': 'Sudah punya akun? Masuk di sini',
    'errorLoginFailed': 'Gagal masuk. Periksa email dan kata sandi, lalu coba lagi.',
    'errorEmailRegistered': 'Email sudah terdaftar. Silakan masuk.',
    'errorLoginInvalid': 'Email atau kata sandi salah. Coba lagi.',
    'errorEmailNotConfirmed': 'Email belum dikonfirmasi. Periksa kotak masuk email kamu.',
    'errorNetwork': 'Tidak ada koneksi internet. Periksa koneksi lalu coba lagi.',
    'errorWeakPassword': 'Kata sandi terlalu lemah. Gunakan kombinasi yang lebih kuat.',
    'errorRateLimitExceeded': 'Terlalu banyak percobaan. Tunggu beberapa saat lalu coba lagi.',
    'signUpConfirmationSent': 'Pendaftaran berhasil. Periksa email untuk konfirmasi sebelum masuk.',
    'nameLabel': 'Nama',
    'nameHint': 'Nama lengkap kamu',
    'errorEmailInvalid': 'Format email tidak valid',
    'errorPasswordTooShort': 'Kata sandi minimal 6 karakter',
    'errorNameRequired': 'Nama wajib diisi',
    'errorDisplayNameTooShort': 'Nama minimal 2 karakter',
    'usernameLabel': 'Username',
    'usernameHint': 'cth: warga_hijau',
    'errorUsernameInvalid': 'Username 3-20 karakter: huruf kecil, angka, underscore, tanpa spasi',
    'errorUsernameTaken': 'Username sudah dipakai. Coba username lain.',
    'loginIdentityLabel': 'Email atau Username',
    'loginIdentityHint': 'nama@email.com atau username',
    'loginIdentityRequired': 'Email atau username wajib diisi',
    'phoneLabel': 'Nomor Telepon',
    'phoneHint': '08xxxxxxxxxx (opsional)',
    'errorPhoneInvalid': 'Nomor telepon tidak valid',
    'confirmPasswordLabel': 'Konfirmasi Kata Sandi',
    'confirmPasswordHint': 'Ulangi kata sandi',
    'errorEmailRequired': 'Email wajib diisi',
    'errorPasswordRequired': 'Kata sandi wajib diisi',
    'errorPasswordMismatch': 'Kata sandi tidak cocok',
    'greeting': 'Halo,',
    'guestName': 'Warga Go Green',
    'homeLoginNotice': 'Masuk untuk sinkron data, buang sampah, dan tukar poin.',
    'homeLoginNoticeAction': 'Masuk',
    'homeLoginNoticeDismiss': 'Tutup notice',
    'backToExitHint': 'Tekan kembali lagi untuk keluar',
    'homeQuickActionsTitle': 'Aksi Cepat',
    'homeMenuTitle': 'Menu Utama',
    'homeHeroTitle': 'Buang Sampah, Dapat Poin!',
    'homeHeroSubtitle': 'Jaga lingkungan, kumpulkan poin, dan tukar dengan reward.',
    'homeHeroCta': 'Mulai Sekarang',
    'homeHeroEyebrow': 'Ayo Mulai!',
    'homeHero2Title': 'Tukar Poin, Dapat Reward!',
    'homeHero2Subtitle': 'Poin terkumpul bisa jadi sembako dan voucher.',
    'homeHero2Cta': 'Lihat Reward',
    'homeHero2Eyebrow': 'Reward Menanti',
    'homeHero3Title': 'Selesaikan Misi Mingguan!',
    'homeHero3Subtitle': 'Buang sampah rutin dan kejar target mingguanmu.',
    'homeHero3Cta': 'Lihat Aktivitas',
    'homeHero3Eyebrow': 'Misi Hijau',
    'homeTotalPointsTitle': 'Total Poin Kamu',
    'homePointsSubtitle': 'Kumpulkan poin, tukar reward',
    'homeExchangeReward': 'Tukar Reward',
    'homeViewHistory': 'Lihat Riwayat',
    'homeMissionTitle': 'Misi Hijau Mingguan',
    'homeMissionDesc': 'Kumpulkan 5 kg sampah anorganik minggu ini',
    'homeLatestActivity': 'Aktivitas Terkini',
    'seeAllShort': 'Semua',
    'homeVerifiedLabel': 'Terverifikasi',
    'homeStatTimesLabel': 'Kali Buang',
    'homeStatWeekLabel': 'Minggu Ini',
    'homeMissionTimesUnit': 'kali',
    'homeMissionCollectedSuffix': 'terkumpul',
    'homeMissionTargetPrefix': 'Target:',
    'homeActivityEmpty': 'Belum ada aktivitas. Buang sampah pertamamu yuk!',
    'homeActivityEmptyGuest': 'Belum ada aktivitas. Masuk dulu untuk mulai.',
    'homeArticleSection': 'Artikel & Edukasi Hijau',
    'quickActionWasteDesc': 'Ambil foto di checkpoint terdekat',
    'quickActionPointsTitle': 'Lihat Poin',
    'quickActionPointsDesc': 'Tukarkan poin menjadi reward',
    'homeRecentArticles': 'Artikel Terbaru',
    'seeAll': 'Lihat semua',
    'homeArticle1Title': 'Pilah Sampah: Mulai dari Dapur',
    'homeArticle1Excerpt': 'Cara sederhana memilah sampah organik dan anorganik di rumah.',
    'homeArticle2Title': 'Kompos Rumah Tangga Tanpa Bau',
    'homeArticle2Excerpt': 'Teknik kompos basah yang aman untuk rumah kecil.',
    'homeArticle3Title': 'Daur Ulang Plastik di Rumah',
    'homeArticle3Excerpt': 'Mengubah botol bekas menjadi barang yang berguna.',
    'homeArticle4Title': 'Kurangi Sampah Makanan',
    'homeArticle4Excerpt': 'Kebiasaan belanja dan memasak yang lebih cerdas.',
    'articleContentP1': 'Memilah sampah sejak dari sumber adalah langkah paling sederhana '
      'untuk memulai gaya hidup ramah lingkungan. Siapkan wadah terpisah '
      'untuk organik, anorganik, dan residu di area dapur.',
    'articleContentP2': 'Sampah organik dapat diolah menjadi kompos, sedangkan sampah '
      'anorganik yang bersih bisa diserahkan ke bank sampah terdekat. '
      'Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.',
    'articleContentP3': 'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat '
      'pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.',
    'articleSearchHint': 'Cari artikel',
    'articleNoResultsTitle': 'Artikel tidak ditemukan',
    'articleNoResultsMessage': 'Coba kata kunci lain, misalnya "kompos".',
    'navHome': 'Beranda',
    'navActivity': 'Aktivitas',
    'navWaste': 'Buang Sampah',
    'navPoints': 'Poin',
    'navProfile': 'Profil',
    'wasteTitle': 'Buang Sampah',
    'takePhotoButton': 'Ambil Foto',
    'processingPhoto': 'Memproses foto...',
    'errorGpsOutOfRange': 'Kamu berada di luar radius checkpoint',
    'wasteCheckpointTitle': 'Checkpoint',
    'wasteCheckpointTps': 'TPS Kelurahan',
    'wasteCheckpointTpsAddress': 'Jl. Melati No. 12, RT 05',
    'wasteCheckpointBank': 'Bank Sampah Berseri',
    'wasteCheckpointBankAddress': 'Jl. Kenanga No. 3, RT 03',
    'wasteGpsTitle': 'Lokasi kamu',
    'wasteGpsInRadius': 'Dalam radius checkpoint (100 m)',
    'gpsDisclaimerHint': 'Foto, timestamp server, dan GPS diverifikasi otomatis.',
    'wasteGpsOutOfRadius': 'Kamu berada di luar radius checkpoint (maks 100 m). Dekat ke lokasi checkpoint lalu ambil ulang.',
    'wasteGpsOutsideLabel': 'Di luar radius',
    'errorPhotoDuplicate': 'Foto ini sudah pernah dikirim sebelumnya.',
    'errorRateLimitReached': 'Kamu sudah mencapai batas kirim hari ini. Coba lagi besok.',
    'photoAttachedLabel': 'Foto terpasang',
    'captureTitle': 'Ambil Foto',
    'captureUnavailable': 'Kamera tidak tersedia di perangkat ini.',
    'capturePermissionDenied': 'Izin kamera belum diberikan. Aktifkan lewat pengaturan perangkat.',
    'captureSuccess': 'Foto berhasil diambil.',
    'captureFlipButton': 'Balik kamera',
    'captureHint': 'Tekan tombol untuk mengambil foto bukti.',
    'captureFlashOff': 'Flash mati',
    'captureFlashAuto': 'Flash otomatis',
    'captureFlashOn': 'Flash menyala',
    'captureRetryButton': 'Coba Lagi',
    'wasteScanHint': 'Scan QR di checkpoint',
    'scanTitle': 'Scan QR',
    'scanHint': 'Arahkan kamera ke QR code checkpoint',
    'scanNote': 'QR button verifikasi lokasi sebelum membuang sampah.',
    'pointsTitle': 'Poin & Reward',
    'pointsBalance': 'Total Poin',
    'rewardsSectionTitle': 'Reward',
    'pointsHistoryTitle': 'Riwayat Poin',
    'pointsHistoryEmpty': 'Belum ada riwayat poin.',
    'rewardSembako': 'Paket Sembako',
    'rewardSembakoDesc': 'Bahan pokok untuk kebutuhan mingguan.',
    'rewardVoucher': 'Voucher Belanja',
    'rewardVoucherDesc': 'Voucher belanja senilai 50 ribu rupiah.',
    'rewardWallet': 'Saldo E-Wallet',
    'rewardWalletDesc': 'Isi saldo GoPay, OVO, atau DANA.',
    'rewardDonasi': 'Donasi Lingkungan',
    'rewardDonasiDesc': 'Salurkan poin untuk penghijauan kota.',
    'rewardPointSuffix': 'Poin',
    'rewardDetailTitle': 'Detail Reward',
    'rewardExchangeButton': 'Tukar',
    'rewardBenefitLabel': 'Yang kamu dapat',
    'rewardDetailCostLabel': 'Harga',
    'activityTitle': 'Aktivitas',
    'activityStatusSuccess': 'Berhasil',
    'activityStatusPending': 'Menunggu verifikasi',
    'activityDemoDesc1': 'Buang sampah organik di TPS Kelurahan',
    'activityDemoDesc2': 'Buang sampah untuk daur ulang di Bank Sampah',
    'activityEmptyTitle': 'Belum ada aktivitas',
    'activityEmptyMessage': 'Mulai buang sampah untuk melihat riwayatmu di sini.',
    'activityDetailTitle': 'Detail Aktivitas',
    'activityDetailDateLabel': 'Tanggal',
    'activityDetailCheckpointLabel': 'Checkpoint',
    'activityDetailPointLabel': 'Poin',
    'activityStatusTitle': 'Status',
    'activityLogPrefix': 'Buang sampah',
    'activityLogAt': 'di',
    'articleTitle': 'Artikel',
    'profileTitle': 'Profil',
    'profileLoginNotice': 'Masuk atau daftar untuk menyimpan data dan menukar poin.',
    'profileDemoEmail': 'warga@go-green.id',
    'profileStatsPoints': 'Total Poin',
    'profileStatsWaste': 'Total Buang',
    'menuNotAvailable': 'Fitur ini belum tersedia.',
    'saveButton': 'Simpan',
    'profileSaved': 'Profil berhasil disimpan.',
    'editProfileCaption': 'Perbarui informasi akun kamu di sini.',
    'editProfile': 'Edit Profil',
    'settingsAccountTitle': 'Akun',
    'settingsPreferencesTitle': 'Preferensi',
    'settingsNotification': 'Notifikasi',
    'settingsNotificationDesc': 'Ingatkan saat ada poin baru atau reward.',
    'settingsInfoTitle': 'Informasi',
    'settingsVersion': 'Versi Aplikasi',
    'settingsVersionValue': '0.1.0',
    'settingsAbout': 'Tentang Go Green',
    'settingsLanguage': 'Bahasa',
    'languageIndonesian': 'Indonesia',
    'languageEnglish': 'Inggris',
    'notifChannelName': 'Go Green',
    'notifChannelDesc': 'Notifikasi aktivitas dan reward',
    'redeemConfirmTitle': 'Konfirmasi Penukaran',
    'redeemConfirmMessage': 'Kamu akan menukar poin untuk reward ini. Lanjutkan?',
    'redeemSuccessTitle': 'Penukaran Berhasil',
    'redeemSuccessMessage': 'Voucher sudah masuk daftar Voucher Saya.',
    'redeemVoucherCopied': 'Kode voucher disalin.',
    'redeemGoVoucherButton': 'Lihat Voucher Saya',
    'redeemCloseButton': 'Tutup',
    'redeemNeedLogin': 'Masuk dulu untuk menukar reward.',
    'redeemInsufficientPoints': 'Poin belum cukup untuk reward ini.',
    'redeemOutOfStock': 'Stok reward habis.',
    'redeemFailedMessage': 'Penukaran gagal. Coba lagi ya.',
    'redeemLoadingLabel': 'Menukar...',
    'voucherTitle': 'Voucher Saya',
    'voucherEmptyMessage': 'Belum ada voucher. Tukar poin dengan reward favoritmu!',
    'voucherStatusPending': 'Menunggu',
    'voucherStatusApproved': 'Disetujui',
    'voucherStatusRejected': 'Ditolak',
    'voucherStatusClaimed': 'Diklaim',
    'cancelButton': 'Batal',
    'settings': 'Pengaturan',
    'logout': 'Keluar',
    'verificationTitle': 'Verifikasi',
    'verificationSuccess': 'Foto terverifikasi',
    'verificationFailed': 'Verifikasi gagal',
    'verificationPending': 'Menunggu verifikasi manual',
    'verificationTimestampLabel': 'Timestamp',
    'verificationLocationLabel': 'Lokasi',
    'verificationHashLabel': 'Hash SHA-256',
    'verificationPointsLabel': 'Estimasi Poin',
    'verificationSubmitButton': 'Konfirmasi Kirim',
    'pointsEarnedTitle': 'Poin Masuk!',
    'pointsEarnedMessage': 'Foto, lokasi, dan hash terverifikasi. Poin sudah masuk ke akunmu.',
    'pointsEarnedButton': 'Ke Beranda',
    'verificationHashButton': 'Lihat Detail Hash',
    'verificationTimestampDemo': '12 Sep 2026, 14.32 WIB',
    'verificationLocationDemo': 'TPS Kelurahan (dalam 100 m)',
    'verificationLocationFailed': 'Lokasi tidak dapat diambil. Pastikan GPS aktif.',
    'verificationHashDemo': 'a3f1c8e92b7d44e0a5f6c12b9d3e7f8a3c5d9e1f7b2a4c6d8e0f1a3b5c7d9e1f3',
    'onboardingTitle1': 'Buang Sampah dengan Benar',
    'onboardingDesc1': 'Buang sampah di checkpoint terdaftar dan dapatkan poin.',
    'onboardingTitle2': 'Tukar Poin Jadi Reward',
    'onboardingDesc2': 'Tukarkan poin dengan sembako, voucher, dan e-wallet.',
    'onboardingTitle3': 'Dampak untuk Bumi',
    'onboardingDesc3': 'Setiap buang sampah dengan benar mengurangi tumpukan liar dan menjaga lingkungan.',
    'startButton': 'Mulai',
    'nextButton': 'Selanjutnya',
    'onboardingSkip': 'Lewati',
    'backButton': 'Kembali',
    'retryButton': 'Coba Lagi',
    'loading': 'Memuat...',
    'genericError': 'Terjadi kesalahan. Silakan coba lagi.',
    'wasteCategoryTitle': 'Kategori Sampah',
    'wasteCategoryOrganik': 'Organik',
    'wasteCategoryAnorganik': 'Anorganik',
    'wasteCategoryDaurUlang': 'Daur Ulang',
    'wasteCategoryB3': 'B3',
    'wasteCheckpointEmpty': 'Belum ada checkpoint di sekitarmu. Coba muat ulang.',
    'wasteCheckpointError': 'Gagal memuat checkpoint. Periksa koneksi lalu coba lagi.',
    'wastePositionFailed': 'Lokasi tidak dapat diambil. Pastikan GPS aktif lalu muat ulang.',
    'wasteNeedLogin': 'Masuk dulu untuk mengirim bukti buang sampah.',
    'wasteDistanceHint': 'jarak',
    'adminTitle': 'Kelola Lokasi',
    'adminSubtitle': 'Khusus admin dan petugas untuk testing.',
    'adminAccessDenied': 'Halaman ini khusus admin dan petugas. Masuk dengan akun admin.',
    'adminCheckpointsTitle': 'Titik Pembuangan',
    'adminAddCheckpoint': 'Tambah titik',
    'adminEditCheckpoint': 'Ubah titik',
    'adminCheckpointEmpty': 'Belum ada titik pembuangan. Tambah titik pertama.',
    'adminCheckpointNameLabel': 'Deskripsi lokasi',
    'adminCheckpointNameHint': 'Contoh: Depan gerbang perumahan blok C',
    'adminCheckpointAddressLabel': 'Alamat lengkap (otomatis)',
    'adminCheckpointLatLabel': 'Latitude',
    'adminCheckpointLngLabel': 'Longitude',
    'adminCheckpointRadiusLabel': 'Radius (meter)',
    'adminCheckpointQrLabel': 'Kode QR (opsional)',
    'adminCheckpointMaxUsesLabel': 'Batas Maksimal Penggunaan',
    'adminCheckpointMaxUsesHint': 'Contoh: 100. Kosongkan jika tidak ada batas.',
    'adminCheckpointMaxUsesInvalid': 'Batas maksimal harus 1-9999 atau kosong.',
    'adminCheckpointRemainingLabel': 'Sisa kuota',
    'checkpointQuotaRemaining': 'Sisa kuota',
    'checkpointUnlimited': 'Tanpa batas',
    'checkpointFull': 'Penuh',
    'wasteCheckpointFull': 'Checkpoint penuh, pilih checkpoint lain.',
    'adminCheckpointNameEmpty': 'Deskripsi lokasi wajib diisi.',
    'adminCheckpointLatInvalid': 'Latitude harus di antara -90 dan 90.',
    'adminCheckpointLngInvalid': 'Longitude harus di antara -180 dan 180.',
    'adminCheckpointRadiusInvalid': 'Radius harus lebih dari 0.',
    'adminCheckpointSaved': 'Titik berhasil disimpan.',
    'adminCheckpointDeleted': 'Titik berhasil dihapus.',
    'adminCheckpointDeleteTitle': 'Hapus titik ini?',
    'adminMapHint': 'Ketuk peta untuk memindahkan pin, atau buka peta layar penuh untuk menggeser.',
    'adminUseMyLocation': 'Pakai lokasi saya',
    'adminPickOnMap': 'Pilih di peta',
    'adminMapPickerTitle': 'Pilih lokasi',
    'adminMapPickerHint': 'Geser peta atau ketuk untuk memindahkan pin.',
    'adminUseThisLocation': 'Gunakan lokasi ini',
    'adminEnableLocationTitle': 'Hidupkan lokasi',
    'adminEnableLocationMessage': 'Layanan lokasi perangkat mati. Hidupkan GPS untuk memakai lokasi saat ini.',
    'adminOpenSettings': 'Buka Pengaturan',
    'adminLocationPermissionTitle': 'Izin lokasi ditolak',
    'adminLocationPermissionMessage': 'Izin lokasi ditolak. Buka pengaturan aplikasi untuk mengizinkan akses lokasi.',
    'adminTestLocationTitle': 'Lokasi uji',
    'adminTestLocationActive': 'Lokasi uji aktif',
    'adminTestLocationOff': 'GPS asli',
    'adminTestLocationSet': 'Lokasi uji dipasang.',
    'adminTestLocationCleared': 'Kembali ke GPS asli.',
    'adminVerificationTitle': 'Antrean Verifikasi',
    'adminVerificationEmpty': 'Tidak ada bukti menunggu verifikasi.',
    'adminApprove': 'Setujui',
    'adminReject': 'Tolak',
    'adminMenuCheckpoint': 'Kelola titik',
    'adminMenuVerification': 'Verifikasi bukti',
    'adminMenuOpen': 'Buka kelola lokasi',
    'adminDashboard': 'Dasbor Admin',
    'adminManageTps': 'Kelola TPS',
    'adminVerifyWaste': 'Verifikasi Waste',
    'adminManageReward': 'Kelola Reward',
    'adminManageUser': 'Kelola User',
    'adminSettings': 'Pengaturan',
    'adminMode': 'Mode Admin',
    'adminUserMode': 'Mode Pengguna',
    'adminMoreMenu': 'Semua Menu Admin',
    'adminComingSoon': 'Halaman ini tersedia di fase 2.',
    'adminRewardManageNote': 'Daftar real dari katalog. Ketuk item untuk ubah, geser status untuk aktif/nonaktif.',
    'adminRewardEmpty': 'Belum ada reward di katalog.',
    'adminRewardStockLabel': 'Stok',
    'adminRewardActiveLabel': 'Aktif',
    'adminRewardInactiveLabel': 'Nonaktif',
    'forensicTitle': 'Forensik Foto',
    'forensicScoreLabel': 'Skor Risiko',
    'forensicLow': 'Rendah',
    'forensicMedium': 'Sedang',
    'forensicHigh': 'Tinggi',
    'forensicExifOk': 'EXIF utuh',
    'forensicExifBad': 'EXIF bermasalah',
    'forensicNoExif': 'Tanpa EXIF kamera',
    'forensicEdited': 'Jejak edit terdeteksi',
    'forensicFarGps': 'Jauh dari checkpoint',
    'forensicRapid': 'Setoran beruntun',
    'forensicUnassessed': 'Belum dinilai (data lama)',
    'adminRewardAdd': 'Tambah Reward',
    'adminRewardAddTitle': 'Tambah Reward Baru',
    'adminRewardEditTitle': 'Ubah Reward',
    'adminRewardNameLabel': 'Nama reward',
    'adminRewardDescLabel': 'Deskripsi (opsional)',
    'adminRewardCostLabel': 'Harga (poin)',
    'adminRewardStockFieldLabel': 'Stok',
    'adminRewardActiveSwitch': 'Tampilkan di katalog',
    'adminRewardSave': 'Simpan Reward',
    'adminRewardNameEmpty': 'Nama reward wajib diisi.',
    'adminRewardCostInvalid': 'Harga poin harus lebih dari 0.',
    'adminRewardStockInvalid': 'Stok tidak boleh negatif.',
    'adminRewardDeleteConfirm': 'Hapus reward ini dari katalog?',
    'adminRewardDelete': 'Hapus',
    'adminUserEmpty': 'Belum ada user terdaftar.',
    'adminUserRoleLabel': 'Role',
    'adminUserSearchHint': 'Cari nama atau email...',
    'adminUserFilterAll': 'Semua',
    'adminUserDetailTitle': 'Detail User',
    'adminUserTotalPoints': 'Total Poin',
    'adminUserHistoryTitle': 'Riwayat Buang',
    'adminUserHistoryEmpty': 'Belum ada riwayat buang.',
    'adminUserChangeRole': 'Ubah Role',
    'adminUserSelfDemoteBlocked': 'Tidak bisa mencabut role admin milik sendiri agar tidak terkunci.',
    'adminSettingsAppTitle': 'Aplikasi',
    'adminSettingsSecurityTitle': 'Anti-kecurangan',
    'adminSettingsMissionTitle': 'Misi Mingguan',
    'adminSettingsPhaseNote': 'Nilai di bawah langsung berlaku. Tambah nilai kategori baru tetap lewat update aplikasi.',
    'adminSettingsRadiusLabel': 'Radius GPS default (meter)',
    'adminSettingsEnforceLabel': 'Tegakkan blokir radius GPS',
    'adminSettingsRateLabel': 'Batas setoran per hari',
    'adminSettingsTargetLabel': 'Target misi mingguan (kali)',
    'adminSettingsPhotoLabel': 'Foto maksimal (MB)',
    'adminSettingsSave': 'Simpan Pengaturan',
    'adminSettingsSaved': 'Pengaturan tersimpan dan langsung berlaku.',
    'adminSettingsRadiusInvalid': 'Radius harus 10-1000 meter.',
    'adminSettingsRateInvalid': 'Batas harian harus 1-20.',
    'adminSettingsTargetInvalid': 'Target harus 1-30 kali.',
    'adminSettingsPhotoInvalid': 'Foto maksimal harus 1-10 MB.',
    'adminSettingsBonusTitle': 'Bonus Kategori (poin)',
    'adminSettingsBonusOrganik': 'Organik',
    'adminSettingsBonusAnorganik': 'Anorganik',
    'adminSettingsBonusDaurUlang': 'Daur Ulang',
    'adminSettingsBonusB3': 'B3',
    'adminSettingsBonusInvalid': 'Bonus kategori harus 0-50 poin.',
    'adminTotalUsers': 'Total User',
    'adminTotalTps': 'Total TPS',
    'adminWasteToday': 'Waste Hari Ini',
    'adminWastePending': 'Pending Verifikasi',
    'adminPointsCirculating': 'Poin Beredar',
    'adminAddTps': 'Tambah TPS',
    'adminViewPending': 'Lihat Verifikasi Pending',
    'adminAuditLog': 'Log Audit',
    'adminAuditEmpty': 'Belum ada aktivitas admin tercatat.',
    'auditActionCreate': 'Tambah',
    'auditActionUpdate': 'Ubah',
    'auditActionDelete': 'Hapus',
    'auditActionActivate': 'Aktifkan',
    'auditActionDeactivate': 'Nonaktifkan',
    'auditActionApprove': 'Setujui',
    'auditActionReject': 'Tolak',
    'auditActionChangeRole': 'Ubah Role',
    'auditActionSaveSettings': 'Simpan Pengaturan',
    'auditEntityReward': 'Reward',
    'auditEntityUser': 'User',
    'auditEntitySettings': 'Pengaturan',
    'auditEntityCheckpoint': 'TPS',
    'auditEntityVerification': 'Verifikasi',
    'adminChartTitle': 'Setoran 7 Hari Terakhir',
    'adminChartEmpty': 'Belum ada setoran 7 hari terakhir.',
    'adminEditTps': 'Ubah TPS',
    'adminSearchTpsHint': 'Cari nama TPS',
    'adminQrCodeLabel': 'Kode QR (otomatis)',
    'closeButton': 'Tutup',
    'adminActivate': 'Aktifkan',
    'adminActiveLabel': 'Aktif',
    'adminInactiveLabel': 'Nonaktif',
    'adminQrPrintHint': 'Tangkap layar lalu cetak dan tempel di lokasi TPS.',
    'adminQrShowTooltip': 'Lihat QR',
    'adminQrPreviewTitle': 'QR Checkpoint',
    'adminQrAutoNote': 'Kode QR dibuat otomatis saat disimpan (CP-XXX).',
    'adminTpsCodeLabel': 'Kode TPS (otomatis)',
    'adminRegionProvinceLabel': 'Provinsi',
    'adminRegionCityLabel': 'Kota/Kabupaten',
    'adminRegionDistrictLabel': 'Kecamatan',
    'adminSubdistrictLabel': 'Kelurahan (otomatis)',
    'adminRegionFilterTitle': 'Filter Wilayah',
    'adminDeactivate': 'Nonaktifkan',
    'adminDeactivateTitle': 'Nonaktifkan TPS ini?',
    'adminFilterToday': 'Hari Ini',
    'adminFilterWeek': '7 Hari',
    'adminFilterAll': 'Semua',
    'adminDetailTitle': 'Detail Verifikasi',
    'adminRejectReasonTitle': 'Alasan Penolakan',
    'adminRejectReasonHint': 'Tulis alasan penolakan',
    'adminRejectReasonEmpty': 'Alasan penolakan wajib diisi.',
    'adminVerifySuccess': 'Bukti disetujui.',
    'adminRejectSuccess': 'Bukti ditolak.',
    'adminPhotoLabel': 'Foto Bukti',
    'adminDistanceLabel': 'Jarak ke Checkpoint',
    'adminHashLabel': 'Hash SHA-256',
    'adminCategoryLabel': 'Kategori',
    'adminSubmitterLabel': 'Pengirim',
    'adminServerTimeLabel': 'Waktu Server',
    'adminLocationLabel': 'Lokasi',
    'adminPointsEstimateLabel': 'Estimasi Poin',
    'adminNoPhoto': 'Foto tidak tersedia.',
  };

  /// Teks Inggris per kunci.
  static const Map<String, String> _en = <String, String>{
    'appName': 'Go Green',
    'loginTitle': 'Sign In',
    'loginSubtitle': 'Start your green habit and collect points for rewards.',
    'rememberMe': 'Remember me',
    'forgotPassword': 'Forgot password?',
    'emailLabel': 'Email',
    'emailHint': 'name@email.com',
    'passwordLabel': 'Password',
    'passwordHint': 'At least 6 characters',
    'loginButton': 'Sign In',
    'loginWithGoogle': 'Sign in with Google',
    'orDivider': 'or',
    'errorGoogleLoginFailed': 'Google sign-in failed. Try again.',
    'googleBrowserHint': 'Continue signing in from the browser, then return to the app.',
    'registerPrompt': 'No account yet? Register here',
    'registerTitle': 'Register',
    'registerSubtitle': 'Create an account to start disposing waste and redeeming points.',
    'registerButton': 'Register',
    'registerWithGoogle': 'Register with Google',
    'loginPrompt': 'Already have an account? Sign in here',
    'errorLoginFailed': 'Sign-in failed. Check your email and password, then try again.',
    'errorEmailRegistered': 'Email is already registered. Please sign in.',
    'errorLoginInvalid': 'Wrong email or password. Try again.',
    'errorEmailNotConfirmed': 'Email is not confirmed. Check your inbox.',
    'errorNetwork': 'No internet connection. Check your connection and try again.',
    'errorWeakPassword': 'Password is too weak. Use a stronger combination.',
    'errorRateLimitExceeded': 'Too many attempts. Wait a moment and try again.',
    'signUpConfirmationSent': 'Registration successful. Check your email to confirm before signing in.',
    'nameLabel': 'Name',
    'nameHint': 'Your full name',
    'errorEmailInvalid': 'Invalid email format',
    'errorPasswordTooShort': 'Password must be at least 6 characters',
    'errorNameRequired': 'Name is required',
    'errorDisplayNameTooShort': 'Name must be at least 2 characters',
    'usernameLabel': 'Username',
    'usernameHint': 'e.g. green_resident',
    'errorUsernameInvalid': 'Username must be 3-20 characters: lowercase, numbers, underscore, no spaces',
    'errorUsernameTaken': 'Username is taken. Try another one.',
    'loginIdentityLabel': 'Email or Username',
    'loginIdentityHint': 'name@email.com or username',
    'loginIdentityRequired': 'Email or username is required',
    'phoneLabel': 'Phone Number',
    'phoneHint': '08xxxxxxxxxx (optional)',
    'errorPhoneInvalid': 'Invalid phone number',
    'confirmPasswordLabel': 'Confirm Password',
    'confirmPasswordHint': 'Repeat your password',
    'errorEmailRequired': 'Email is required',
    'errorPasswordRequired': 'Password is required',
    'errorPasswordMismatch': 'Passwords do not match',
    'greeting': 'Hello,',
    'guestName': 'Go Green Resident',
    'homeLoginNotice': 'Sign in to sync data, dispose waste, and redeem points.',
    'homeLoginNoticeAction': 'Sign In',
    'homeLoginNoticeDismiss': 'Dismiss notice',
    'backToExitHint': 'Press back again to exit',
    'homeQuickActionsTitle': 'Quick Actions',
    'homeMenuTitle': 'Main Menu',
    'homeHeroTitle': 'Dispose Waste, Earn Points!',
    'homeHeroSubtitle': 'Protect the environment, collect points, and redeem rewards.',
    'homeHeroCta': 'Start Now',
    'homeHeroEyebrow': 'Let\'s Go!',
    'homeHero2Title': 'Redeem Points, Get Rewards!',
    'homeHero2Subtitle': 'Collected points can become groceries and vouchers.',
    'homeHero2Cta': 'View Rewards',
    'homeHero2Eyebrow': 'Rewards Await',
    'homeHero3Title': 'Complete the Weekly Mission!',
    'homeHero3Subtitle': 'Dispose waste regularly and hit your weekly target.',
    'homeHero3Cta': 'View Activity',
    'homeHero3Eyebrow': 'Green Mission',
    'homeTotalPointsTitle': 'Your Total Points',
    'homePointsSubtitle': 'Collect points, redeem rewards',
    'homeExchangeReward': 'Redeem Reward',
    'homeViewHistory': 'View History',
    'homeMissionTitle': 'Weekly Green Mission',
    'homeMissionDesc': 'Collect 5 kg of inorganic waste this week',
    'homeLatestActivity': 'Latest Activity',
    'seeAllShort': 'All',
    'homeVerifiedLabel': 'Verified',
    'homeStatTimesLabel': 'Drop-offs',
    'homeStatWeekLabel': 'This Week',
    'homeMissionTimesUnit': 'times',
    'homeMissionCollectedSuffix': 'collected',
    'homeMissionTargetPrefix': 'Target:',
    'homeActivityEmpty': 'No activity yet. Make your first drop-off!',
    'homeActivityEmptyGuest': 'No activity yet. Sign in to get started.',
    'homeArticleSection': 'Green Articles & Education',
    'quickActionWasteDesc': 'Take a photo at the nearest checkpoint',
    'quickActionPointsTitle': 'View Points',
    'quickActionPointsDesc': 'Turn points into rewards',
    'homeRecentArticles': 'Latest Articles',
    'seeAll': 'See all',
    'homeArticle1Title': 'Sorting Waste: Start from the Kitchen',
    'homeArticle1Excerpt': 'A simple way to sort organic and inorganic waste at home.',
    'homeArticle2Title': 'Odorless Home Composting',
    'homeArticle2Excerpt': 'A safe wet-compost technique for small homes.',
    'homeArticle3Title': 'Recycling Plastic at Home',
    'homeArticle3Excerpt': 'Turning used bottles into useful goods.',
    'homeArticle4Title': 'Reducing Food Waste',
    'homeArticle4Excerpt': 'Smarter shopping and cooking habits.',
    'articleContentP1': 'Sorting waste at the source is the simplest first step toward an eco-friendly lifestyle. Prepare separate bins for organic, inorganic, and residual waste in the kitchen area.',
    'articleContentP2': 'Organic waste can be composted, while clean inorganic waste can go to the nearest waste bank. Rinse packaging before handing it over so it is easier to recycle.',
    'articleContentP3': 'By sorting regularly, you help reduce landfill burden and can earn points in the Go Green app.',
    'articleSearchHint': 'Search articles',
    'articleNoResultsTitle': 'No articles found',
    'articleNoResultsMessage': 'Try another keyword, for example "compost".',
    'navHome': 'Home',
    'navActivity': 'Activity',
    'navWaste': 'Dispose',
    'navPoints': 'Points',
    'navProfile': 'Profile',
    'wasteTitle': 'Dispose Waste',
    'takePhotoButton': 'Take Photo',
    'processingPhoto': 'Processing photo...',
    'errorGpsOutOfRange': 'You are outside the checkpoint radius',
    'wasteCheckpointTitle': 'Checkpoint',
    'wasteCheckpointTps': 'Neighborhood Drop-off Point',
    'wasteCheckpointTpsAddress': '12 Melati St, Block 05',
    'wasteCheckpointBank': 'Berseri Waste Bank',
    'wasteCheckpointBankAddress': '3 Kenanga St, Block 03',
    'wasteGpsTitle': 'Your location',
    'wasteGpsInRadius': 'Within checkpoint radius (100 m)',
    'gpsDisclaimerHint': 'Photo, server timestamp, and GPS are verified automatically.',
    'wasteGpsOutOfRadius': 'You are outside the checkpoint radius (max 100 m). Move closer, then retake.',
    'wasteGpsOutsideLabel': 'Out of radius',
    'errorPhotoDuplicate': 'This photo has already been submitted.',
    'errorRateLimitReached': 'You have reached today\'s submission limit. Try again tomorrow.',
    'photoAttachedLabel': 'Photo attached',
    'captureTitle': 'Take Photo',
    'captureUnavailable': 'Camera is not available on this device.',
    'capturePermissionDenied': 'Camera permission not granted. Enable it in device settings.',
    'captureSuccess': 'Photo captured successfully.',
    'captureFlipButton': 'Flip camera',
    'captureHint': 'Press the button to take the proof photo.',
    'captureFlashOff': 'Flash off',
    'captureFlashAuto': 'Flash auto',
    'captureFlashOn': 'Flash on',
    'captureRetryButton': 'Try Again',
    'wasteScanHint': 'Scan the QR at the checkpoint',
    'scanTitle': 'Scan QR',
    'scanHint': 'Point the camera at the checkpoint QR code',
    'scanNote': 'QR verifies the location before disposing waste.',
    'pointsTitle': 'Points & Rewards',
    'pointsBalance': 'Total Points',
    'rewardsSectionTitle': 'Rewards',
    'pointsHistoryTitle': 'Points History',
    'pointsHistoryEmpty': 'No points history yet.',
    'rewardSembako': 'Grocery Pack',
    'rewardSembakoDesc': 'Staple goods for weekly needs.',
    'rewardVoucher': 'Shopping Voucher',
    'rewardVoucherDesc': 'Shopping voucher worth 50 thousand rupiah.',
    'rewardWallet': 'E-Wallet Balance',
    'rewardWalletDesc': 'Top up GoPay, OVO, or DANA.',
    'rewardDonasi': 'Green Donation',
    'rewardDonasiDesc': 'Donate points for city greening.',
    'rewardPointSuffix': 'Points',
    'rewardDetailTitle': 'Reward Details',
    'rewardExchangeButton': 'Redeem',
    'rewardBenefitLabel': 'What you get',
    'rewardDetailCostLabel': 'Price',
    'activityTitle': 'Activity',
    'activityStatusSuccess': 'Successful',
    'activityStatusPending': 'Awaiting verification',
    'activityDemoDesc1': 'Disposed organic waste at the Neighborhood Drop-off',
    'activityDemoDesc2': 'Dropped recyclables at the Waste Bank',
    'activityEmptyTitle': 'No activity yet',
    'activityEmptyMessage': 'Start disposing waste to see your history here.',
    'activityDetailTitle': 'Activity Details',
    'activityDetailDateLabel': 'Date',
    'activityDetailCheckpointLabel': 'Checkpoint',
    'activityDetailPointLabel': 'Points',
    'activityStatusTitle': 'Status',
    'activityLogPrefix': 'Disposed waste',
    'activityLogAt': 'at',
    'articleTitle': 'Articles',
    'profileTitle': 'Profile',
    'profileLoginNotice': 'Sign in or register to save data and redeem points.',
    'profileDemoEmail': 'resident@go-green.id',
    'profileStatsPoints': 'Total Points',
    'profileStatsWaste': 'Total Drop-offs',
    'menuNotAvailable': 'This feature is not available yet.',
    'saveButton': 'Save',
    'profileSaved': 'Profile saved successfully.',
    'editProfileCaption': 'Update your account info here.',
    'editProfile': 'Edit Profile',
    'settingsAccountTitle': 'Account',
    'settingsPreferencesTitle': 'Preferences',
    'settingsNotification': 'Notifications',
    'settingsNotificationDesc': 'Remind me about new points or rewards.',
    'settingsInfoTitle': 'Info',
    'settingsVersion': 'App Version',
    'settingsVersionValue': '0.1.0',
    'settingsAbout': 'About Go Green',
    'settingsLanguage': 'Language',
    'languageIndonesian': 'Indonesian',
    'languageEnglish': 'English',
    'notifChannelName': 'Go Green',
    'notifChannelDesc': 'Activity and reward notifications',
    'redeemConfirmTitle': 'Confirm Redemption',
    'redeemConfirmMessage': 'You are about to redeem points for this reward. Continue?',
    'redeemSuccessTitle': 'Redemption Successful',
    'redeemSuccessMessage': 'The voucher is now in My Vouchers.',
    'redeemVoucherCopied': 'Voucher code copied.',
    'redeemGoVoucherButton': 'View My Vouchers',
    'redeemCloseButton': 'Close',
    'redeemNeedLogin': 'Sign in first to redeem rewards.',
    'redeemInsufficientPoints': 'Not enough points for this reward.',
    'redeemOutOfStock': 'Reward is out of stock.',
    'redeemFailedMessage': 'Redemption failed. Please try again.',
    'redeemLoadingLabel': 'Redeeming...',
    'voucherTitle': 'My Vouchers',
    'voucherEmptyMessage': 'No vouchers yet. Redeem points for your favorite rewards!',
    'voucherStatusPending': 'Pending',
    'voucherStatusApproved': 'Approved',
    'voucherStatusRejected': 'Rejected',
    'voucherStatusClaimed': 'Claimed',
    'cancelButton': 'Cancel',
    'settings': 'Settings',
    'logout': 'Sign Out',
    'verificationTitle': 'Verification',
    'verificationSuccess': 'Photo verified',
    'verificationFailed': 'Verification failed',
    'verificationPending': 'Awaiting manual verification',
    'verificationTimestampLabel': 'Timestamp',
    'verificationLocationLabel': 'Location',
    'verificationHashLabel': 'SHA-256 Hash',
    'verificationPointsLabel': 'Estimated Points',
    'verificationSubmitButton': 'Confirm Send',
    'pointsEarnedTitle': 'Points Earned!',
    'pointsEarnedMessage': 'Photo, location, and hash verified. Points are now in your account.',
    'pointsEarnedButton': 'Go Home',
    'verificationHashButton': 'View Hash Details',
    'verificationTimestampDemo': 'Sep 12 2026, 2:32 PM',
    'verificationLocationDemo': 'Neighborhood Drop-off (within 100 m)',
    'verificationLocationFailed': 'Location unavailable. Make sure GPS is on.',
    'verificationHashDemo': 'a3f1c8e92b7d44e0a5f6c12b9d3e7f8a3c5d9e1f7b2a4c6d8e0f1a3b5c7d9e1f3',
    'onboardingTitle1': 'Dispose Waste Properly',
    'onboardingDesc1': 'Drop waste at registered checkpoints and earn points.',
    'onboardingTitle2': 'Turn Points into Rewards',
    'onboardingDesc2': 'Redeem points for groceries, vouchers, and e-wallets.',
    'onboardingTitle3': 'Impact for the Earth',
    'onboardingDesc3': 'Every proper drop-off reduces illegal dumping and protects the environment.',
    'startButton': 'Start',
    'nextButton': 'Next',
    'onboardingSkip': 'Skip',
    'backButton': 'Back',
    'retryButton': 'Try Again',
    'loading': 'Loading...',
    'genericError': 'Something went wrong. Please try again.',
    'wasteCategoryTitle': 'Waste Category',
    'wasteCategoryOrganik': 'Organic',
    'wasteCategoryAnorganik': 'Inorganic',
    'wasteCategoryDaurUlang': 'Recyclable',
    'wasteCategoryB3': 'Hazardous',
    'wasteCheckpointEmpty': 'No checkpoints near you. Try reloading.',
    'wasteCheckpointError': 'Failed to load checkpoints. Check your connection and try again.',
    'wastePositionFailed': 'Location unavailable. Turn on GPS and reload.',
    'wasteNeedLogin': 'Sign in first to submit disposal proof.',
    'wasteDistanceHint': 'distance',
    'adminTitle': 'Manage Locations',
    'adminSubtitle': 'For admins and officers, for testing.',
    'adminAccessDenied': 'This page is for admins and officers. Sign in with an admin account.',
    'adminCheckpointsTitle': 'Drop-off Points',
    'adminAddCheckpoint': 'Add point',
    'adminEditCheckpoint': 'Edit point',
    'adminCheckpointEmpty': 'No drop-off points yet. Add the first one.',
    'adminCheckpointNameLabel': 'Location description',
    'adminCheckpointNameHint': 'Example: In front of block C gate',
    'adminCheckpointAddressLabel': 'Full address (automatic)',
    'adminCheckpointLatLabel': 'Latitude',
    'adminCheckpointLngLabel': 'Longitude',
    'adminCheckpointRadiusLabel': 'Radius (meters)',
    'adminCheckpointQrLabel': 'QR Code (optional)',
    'adminCheckpointNameEmpty': 'Location description is required.',
    'adminCheckpointLatInvalid': 'Latitude must be between -90 and 90.',
    'adminCheckpointLngInvalid': 'Longitude must be between -180 and 180.',
    'adminCheckpointRadiusInvalid': 'Radius must be greater than 0.',
    'adminCheckpointSaved': 'Point saved successfully.',
    'adminCheckpointDeleted': 'Point deleted successfully.',
    'adminCheckpointDeleteTitle': 'Delete this point?',
    'adminMapHint': 'Tap the map to move the pin, or open the full-screen map to drag it.',
    'adminUseMyLocation': 'Use my location',
    'adminPickOnMap': 'Pick on map',
    'adminMapPickerTitle': 'Pick location',
    'adminMapPickerHint': 'Drag the map or tap to move the pin.',
    'adminUseThisLocation': 'Use this location',
    'adminEnableLocationTitle': 'Turn on location',
    'adminEnableLocationMessage': 'Device location service is off. Turn on GPS to use the current location.',
    'adminOpenSettings': 'Open Settings',
    'adminLocationPermissionTitle': 'Location permission denied',
    'adminLocationPermissionMessage': 'Location permission was denied. Open app settings to allow location access.',
    'adminTestLocationTitle': 'Test location',
    'adminTestLocationActive': 'Test location active',
    'adminTestLocationOff': 'Real GPS',
    'adminTestLocationSet': 'Test location set.',
    'adminTestLocationCleared': 'Back to real GPS.',
    'adminVerificationTitle': 'Verification Queue',
    'adminVerificationEmpty': 'No proof awaiting verification.',
    'adminApprove': 'Approve',
    'adminReject': 'Reject',
    'adminMenuCheckpoint': 'Manage points',
    'adminMenuVerification': 'Verify proof',
    'adminMenuOpen': 'Open location management',
    'adminDashboard': 'Admin Dashboard',
    'adminManageTps': 'Manage Drop-off Points',
    'adminVerifyWaste': 'Waste Verification',
    'adminManageReward': 'Manage Rewards',
    'adminManageUser': 'Manage Users',
    'adminSettings': 'Settings',
    'adminMode': 'Admin Mode',
    'adminUserMode': 'User Mode',
    'adminMoreMenu': 'All Admin Menus',
    'adminComingSoon': 'This page is coming in phase 2.',
    'adminRewardManageNote': 'Live catalog list. Tap an item to edit, flip the switch for active/inactive.',
    'adminRewardEmpty': 'No rewards in the catalog yet.',
    'adminRewardStockLabel': 'Stock',
    'adminRewardActiveLabel': 'Active',
    'adminRewardInactiveLabel': 'Inactive',
    'forensicTitle': 'Photo Forensics',
    'forensicScoreLabel': 'Risk Score',
    'forensicLow': 'Low',
    'forensicMedium': 'Medium',
    'forensicHigh': 'High',
    'forensicExifOk': 'EXIF intact',
    'forensicExifBad': 'EXIF issues',
    'forensicNoExif': 'No camera EXIF',
    'forensicEdited': 'Edit traces detected',
    'forensicFarGps': 'Far from checkpoint',
    'forensicRapid': 'Rapid submissions',
    'forensicUnassessed': 'Not assessed (legacy data)',
    'adminRewardAdd': 'Add Reward',
    'adminRewardAddTitle': 'Add New Reward',
    'adminRewardEditTitle': 'Edit Reward',
    'adminRewardNameLabel': 'Reward name',
    'adminRewardDescLabel': 'Description (optional)',
    'adminRewardCostLabel': 'Price (points)',
    'adminRewardStockFieldLabel': 'Stock',
    'adminRewardActiveSwitch': 'Show in catalog',
    'adminRewardSave': 'Save Reward',
    'adminRewardNameEmpty': 'Reward name is required.',
    'adminRewardCostInvalid': 'Point price must be greater than 0.',
    'adminRewardStockInvalid': 'Stock cannot be negative.',
    'adminRewardDeleteConfirm': 'Delete this reward from the catalog?',
    'adminRewardDelete': 'Delete',
    'adminUserEmpty': 'No registered users yet.',
    'adminUserRoleLabel': 'Role',
    'adminUserSearchHint': 'Search name or email...',
    'adminUserFilterAll': 'All',
    'adminUserDetailTitle': 'User Details',
    'adminUserTotalPoints': 'Total Points',
    'adminUserHistoryTitle': 'Drop-off History',
    'adminUserHistoryEmpty': 'No drop-off history yet.',
    'adminUserChangeRole': 'Change Role',
    'adminUserSelfDemoteBlocked': 'Cannot revoke your own admin role to avoid lockout.',
    'adminSettingsAppTitle': 'App',
    'adminSettingsSecurityTitle': 'Anti-fraud',
    'adminSettingsMissionTitle': 'Weekly Mission',
    'adminSettingsPhaseNote': 'Values below take effect immediately. Adding new category values still requires an app update.',
    'adminSettingsRadiusLabel': 'Default GPS radius (meters)',
    'adminSettingsEnforceLabel': 'Enforce GPS radius blocking',
    'adminSettingsRateLabel': 'Daily submission limit',
    'adminSettingsTargetLabel': 'Weekly mission target (times)',
    'adminSettingsPhotoLabel': 'Max photo size (MB)',
    'adminSettingsSave': 'Save Settings',
    'adminSettingsSaved': 'Settings saved and live.',
    'adminSettingsRadiusInvalid': 'Radius must be 10-1000 meters.',
    'adminSettingsRateInvalid': 'Daily limit must be 1-20.',
    'adminSettingsTargetInvalid': 'Target must be 1-30 times.',
    'adminSettingsPhotoInvalid': 'Max photo must be 1-10 MB.',
    'adminSettingsBonusTitle': 'Category Bonuses (points)',
    'adminSettingsBonusOrganik': 'Organic',
    'adminSettingsBonusAnorganik': 'Inorganic',
    'adminSettingsBonusDaurUlang': 'Recyclable',
    'adminSettingsBonusB3': 'Hazardous',
    'adminSettingsBonusInvalid': 'Category bonus must be 0-50 points.',
    'adminTotalUsers': 'Total Users',
    'adminTotalTps': 'Total Drop-off Points',
    'adminWasteToday': 'Waste Today',
    'adminWastePending': 'Pending Verification',
    'adminPointsCirculating': 'Points in Circulation',
    'adminAddTps': 'Add Drop-off Point',
    'adminViewPending': 'View Pending Verification',
    'adminAuditLog': 'Audit Log',
    'adminAuditEmpty': 'No admin activity recorded yet.',
    'auditActionCreate': 'Add',
    'auditActionUpdate': 'Edit',
    'auditActionDelete': 'Delete',
    'auditActionActivate': 'Activate',
    'auditActionDeactivate': 'Deactivate',
    'auditActionApprove': 'Approve',
    'auditActionReject': 'Reject',
    'auditActionChangeRole': 'Change Role',
    'auditActionSaveSettings': 'Save Settings',
    'auditEntityReward': 'Reward',
    'auditEntityUser': 'User',
    'auditEntitySettings': 'Settings',
    'auditEntityCheckpoint': 'Drop-off Point',
    'auditEntityVerification': 'Verification',
    'adminChartTitle': 'Drop-offs in the Last 7 Days',
    'adminChartEmpty': 'No drop-offs in the last 7 days.',
    'adminEditTps': 'Edit Drop-off Point',
    'adminSearchTpsHint': 'Search drop-off point name',
    'adminQrCodeLabel': 'QR Code (automatic)',
    'closeButton': 'Close',
    'adminActivate': 'Activate',
    'adminActiveLabel': 'Active',
    'adminInactiveLabel': 'Inactive',
    'adminQrPrintHint': 'Screenshot, print, and post it at the drop-off location.',
    'adminQrShowTooltip': 'View QR',
    'adminQrPreviewTitle': 'Checkpoint QR',
    'adminQrAutoNote': 'QR code is auto-generated on save (CP-XXX).',
    'adminTpsCodeLabel': 'Drop-off Code (automatic)',
    'adminRegionProvinceLabel': 'Province',
    'adminRegionCityLabel': 'City/Regency',
    'adminRegionDistrictLabel': 'District',
    'adminSubdistrictLabel': 'Subdistrict (automatic)',
    'adminCheckpointMaxUsesLabel': 'Max Usage Limit',
    'adminCheckpointMaxUsesHint': 'E.g. 100. Leave empty for unlimited.',
    'adminCheckpointMaxUsesInvalid': 'Max uses must be 1-9999 or empty.',
    'adminCheckpointRemainingLabel': 'Remaining quota',
    'checkpointQuotaRemaining': 'Remaining quota',
    'checkpointUnlimited': 'Unlimited',
    'checkpointFull': 'Full',
    'wasteCheckpointFull': 'Checkpoint is full, choose another one.',
    'adminRegionFilterTitle': 'Region Filter',
    'adminDeactivate': 'Deactivate',
    'adminDeactivateTitle': 'Deactivate this drop-off point?',
    'adminFilterToday': 'Today',
    'adminFilterWeek': '7 Days',
    'adminFilterAll': 'All',
    'adminDetailTitle': 'Verification Details',
    'adminRejectReasonTitle': 'Rejection Reason',
    'adminRejectReasonHint': 'Write the rejection reason',
    'adminRejectReasonEmpty': 'Rejection reason is required.',
    'adminVerifySuccess': 'Proof approved.',
    'adminRejectSuccess': 'Proof rejected.',
    'adminPhotoLabel': 'Proof Photo',
    'adminDistanceLabel': 'Distance to Checkpoint',
    'adminHashLabel': 'SHA-256 Hash',
    'adminCategoryLabel': 'Category',
    'adminSubmitterLabel': 'Submitter',
    'adminServerTimeLabel': 'Server Time',
    'adminLocationLabel': 'Location',
    'adminPointsEstimateLabel': 'Estimated Points',
    'adminNoPhoto': 'Photo unavailable.',
  };
}
