// Nilai global aplikasi Go Green.

/// Nilai global aplikasi.
abstract final class AppValues {
  AppValues._();

  /// Radius GPS checkpoint dalam meter (anti-kecurangan).
  static const double gpsRadiusMeters = 100;

  /// True = user di luar radius tidak bisa foto/submit.
  static const bool enforceGpsRadius = true;

  /// Ukuran maksimal foto bukti (5 MB).
  static const int maxPhotoBytes = 5 * 1024 * 1024;

  /// Batas setoran per user per hari (anti-spam).
  static const int maxWasteLogsPerDay = 5;

  /// Poin dasar per setoran terverifikasi.
  static const int basePointsPerWaste = 25;

  /// Bonus poin untuk kategori organik.
  static const int categoryBonusOrganik = 0;

  /// Bonus poin untuk kategori anorganik.
  static const int categoryBonusAnorganik = 5;

  /// Bonus poin untuk kategori daur ulang.
  static const int categoryBonusDaurUlang = 10;

  /// Bonus poin untuk kategori B3.
  static const int categoryBonusB3 = 15;

  /// Jumlah hari beruntun minimal untuk mendapat bonus streak.
  static const int streakBonusThreshold = 3;

  /// Bonus poin saat streak melewati ambang threshold.
  static const int streakBonusPoints = 10;

  /// Target setoran mingguan misi Home (kali/minggu).
  static const int weeklyMissionTargetDisposals = 5;

  /// Redirect deep link login Google (terdaftar di native + Supabase).
  static const String oauthRedirectTo =
      'io.supabase.gogreen://login-callback';

  /// True = nav bawah admin tampil (3 menu + sheet semua menu).
  static const bool adminBottomNavEnabled = true;

  /// False = drawer admin hanya via tombol menu.
  static const bool adminDrawerSwipeEnabled = true;

  /// Gaya ikon nav aktif: 1=circle, 2=elevated, 3=pill, 4=pop.
  static const int bottomNavActiveStyle = 4;
}
