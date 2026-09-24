// Entity nilai pengaturan operasional (domain).
//
// Representasi terketik dari tabel app_settings; parsing mentah
// (string) dengan fallback AppValues agar tahan data rusak.

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_values.dart';

/// Nilai pengaturan operasional Go Green.
class AppSettingsValues {
  /// Membuat nilai pengaturan.
  const AppSettingsValues({
    required this.gpsRadiusMeters,
    required this.enforceGpsRadius,
    required this.maxWasteLogsPerDay,
    required this.weeklyMissionTarget,
    required this.maxPhotoMb,
  });

  /// Nilai default (sama dengan AppValues).
  factory AppSettingsValues.defaults() {
    return const AppSettingsValues(
      gpsRadiusMeters: 100,
      enforceGpsRadius: true,
      maxWasteLogsPerDay: 5,
      weeklyMissionTarget: 5,
      maxPhotoMb: 5,
    );
  }

  /// Bangun dari map key -> value mentah tabel.
  factory AppSettingsValues.fromMap(Map<String, String> map) {
    int num(String key, int fallback) {
      return int.tryParse(map[key] ?? '') ?? fallback;
    }

    bool flag(String key, bool fallback) {
      final String? raw = map[key]?.trim().toLowerCase();
      if (raw == 'true') return true;
      if (raw == 'false') return false;
      return fallback;
    }

    return AppSettingsValues(
      gpsRadiusMeters: num(
        AppSettingKeys.gpsRadiusMeters,
        AppValues.gpsRadiusMeters.toInt(),
      ),
      enforceGpsRadius: flag(
        AppSettingKeys.enforceGpsRadius,
        AppValues.enforceGpsRadius,
      ),
      maxWasteLogsPerDay: num(
        AppSettingKeys.maxWasteLogsPerDay,
        AppValues.maxWasteLogsPerDay,
      ),
      weeklyMissionTarget: num(
        AppSettingKeys.weeklyMissionTarget,
        AppValues.weeklyMissionTargetDisposals,
      ),
      maxPhotoMb: num(AppSettingKeys.maxPhotoMb, 5),
    );
  }

  /// Radius GPS default (meter).
  final int gpsRadiusMeters;

  /// Penegakan blokir radius GPS.
  final bool enforceGpsRadius;

  /// Batas setoran per user per hari.
  final int maxWasteLogsPerDay;

  /// Target misi mingguan.
  final int weeklyMissionTarget;

  /// Foto maksimal (MB).
  final int maxPhotoMb;

  /// Ubah ke map key -> value untuk disimpan.
  Map<String, String> toMap() {
    return <String, String>{
      AppSettingKeys.gpsRadiusMeters: '$gpsRadiusMeters',
      AppSettingKeys.enforceGpsRadius: '$enforceGpsRadius',
      AppSettingKeys.maxWasteLogsPerDay: '$maxWasteLogsPerDay',
      AppSettingKeys.weeklyMissionTarget: '$weeklyMissionTarget',
      AppSettingKeys.maxPhotoMb: '$maxPhotoMb',
    };
  }
}
