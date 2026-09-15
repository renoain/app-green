// Nilai global aplikasi Go Green.

/// Nilai global aplikasi.
abstract final class AppValues {
  AppValues._();

  /// Radius maksimal jarak user dari checkpoint dalam meter (anti-kecurangan).
  static const double gpsRadiusMeters = 100;

  /// Ukuran maksimal foto bukti dalam byte (5 MB,
  /// docs/DATABASE_SCHEMA.md bagian 4.1).
  static const int maxPhotoBytes = 5 * 1024 * 1024;
}