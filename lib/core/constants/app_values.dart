// Nilai global aplikasi Go Green.

/// Nilai global aplikasi.
abstract final class AppValues {
  AppValues._();

  /// Radius maksimal jarak user dari checkpoint dalam meter (anti-kecurangan).
  static const double gpsRadiusMeters = 100;

  /// Apakah blokir radius GPS ditegakkan sebelum foto/submit.
  ///
  /// True berarti anti-kecurangan radius aktif: user di luar radius
  /// checkpoint tidak bisa lanjut ke kamera/verifikasi dan submit diblokir.
  static const bool enforceGpsRadius = true;

  /// Ukuran maksimal foto bukti dalam byte (5 MB,
  /// docs/DATABASE_SCHEMA.md bagian 4.1).
  static const int maxPhotoBytes = 5 * 1024 * 1024;

  /// Batas maksimal waste_logs per user per hari (anti-kecurangan rate limit).
  static const int maxWasteLogsPerDay = 5;

  /// Poin dasar setiap pembuangan sampah yang berhasil diverifikasi.
  ///
  /// Dipakai CalculatePointsUsecase (lib/features/waste/domain/usecases/
  /// calculate_points_usecase.dart).
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
}