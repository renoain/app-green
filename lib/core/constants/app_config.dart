// Konfigurasi runtime Go Green (override sinkron dari app_settings).
//
// AppValues adalah konstanta kompilasi (fallback). AppConfig menampung
// override yang dimuat dari tabel app_settings saat splash (best effort)
// dan diperbarui langsung saat admin menyimpan. Bila override kosong
// (offline/test/belum push migrasi), nilai fallback AppValues dipakai
// sehingga perilaku deterministik.

import 'app_values.dart';

/// Kunci pengaturan di tabel app_settings.
abstract final class AppSettingKeys {
  AppSettingKeys._();

  /// Radius GPS default (meter).
  static const String gpsRadiusMeters = 'gps_radius_meters';

  /// Penegakan blokir radius GPS.
  static const String enforceGpsRadius = 'enforce_gps_radius';

  /// Batas setoran per user per hari.
  static const String maxWasteLogsPerDay = 'max_waste_logs_per_day';

  /// Target misi mingguan (kali/minggu).
  static const String weeklyMissionTarget = 'weekly_mission_target';

  /// Foto maksimal (MB).
  static const String maxPhotoMb = 'max_photo_mb';

  /// Bonus poin kategori organik.
  static const String bonusOrganik = 'bonus_organik';

  /// Bonus poin kategori anorganik.
  static const String bonusAnorganik = 'bonus_anorganik';

  /// Bonus poin kategori daur ulang.
  static const String bonusDaurUlang = 'bonus_daur_ulang';

  /// Bonus poin kategori B3.
  static const String bonusB3 = 'bonus_b3';
}

/// Nilai konfigurasi efektif aplikasi (override atau fallback).
abstract final class AppConfig {
  AppConfig._();

  static final Map<String, String> _overrides = <String, String>{};

  /// Terapkan nilai remote (key -> value mentah).
  static void apply(Map<String, String> values) {
    _overrides
      ..clear()
      ..addAll(values);
  }

  /// Kosongkan override (dipakai test agar deterministik).
  static void clear() => _overrides.clear();

  static int _int(String key, int fallback) {
    return int.tryParse(_overrides[key] ?? '') ?? fallback;
  }

  static bool _bool(String key, bool fallback) {
    final String? raw = _overrides[key]?.trim().toLowerCase();
    if (raw == 'true') return true;
    if (raw == 'false') return false;
    return fallback;
  }

  /// Radius GPS default checkpoint (meter).
  static double get gpsRadiusMeters => _int(
        AppSettingKeys.gpsRadiusMeters,
        AppValues.gpsRadiusMeters.toInt(),
      ).toDouble();

  /// Apakah blokir radius GPS ditegakkan.
  static bool get enforceGpsRadius => _bool(
        AppSettingKeys.enforceGpsRadius,
        AppValues.enforceGpsRadius,
      );

  /// Batas waste_logs per user per hari.
  static int get maxWasteLogsPerDay => _int(
        AppSettingKeys.maxWasteLogsPerDay,
        AppValues.maxWasteLogsPerDay,
      );

  /// Target misi mingguan (kali/minggu).
  static int get weeklyMissionTargetDisposals => _int(
        AppSettingKeys.weeklyMissionTarget,
        AppValues.weeklyMissionTargetDisposals,
      );

  /// Foto maksimal dalam byte.
  static int get maxPhotoBytes =>
      _int(AppSettingKeys.maxPhotoMb, 5) * 1024 * 1024;

  /// Foto maksimal dalam MB (untuk form admin).
  static int get maxPhotoMb => _int(AppSettingKeys.maxPhotoMb, 5);

  /// Bonus poin kategori organik.
  static int get categoryBonusOrganik => _int(
        AppSettingKeys.bonusOrganik,
        AppValues.categoryBonusOrganik,
      );

  /// Bonus poin kategori anorganik.
  static int get categoryBonusAnorganik => _int(
        AppSettingKeys.bonusAnorganik,
        AppValues.categoryBonusAnorganik,
      );

  /// Bonus poin kategori daur ulang.
  static int get categoryBonusDaurUlang => _int(
        AppSettingKeys.bonusDaurUlang,
        AppValues.categoryBonusDaurUlang,
      );

  /// Bonus poin kategori B3.
  static int get categoryBonusB3 => _int(
        AppSettingKeys.bonusB3,
        AppValues.categoryBonusB3,
      );
}
