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
    required this.bonusOrganik,
    required this.bonusAnorganik,
    required this.bonusDaurUlang,
    required this.bonusB3,
  });

  /// Nilai default (sama dengan AppValues).
  factory AppSettingsValues.defaults() {
    return const AppSettingsValues(
      gpsRadiusMeters: 100,
      enforceGpsRadius: true,
      maxWasteLogsPerDay: 5,
      weeklyMissionTarget: 5,
      maxPhotoMb: 5,
      bonusOrganik: 0,
      bonusAnorganik: 5,
      bonusDaurUlang: 10,
      bonusB3: 15,
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
      bonusOrganik: num(
        AppSettingKeys.bonusOrganik,
        AppValues.categoryBonusOrganik,
      ),
      bonusAnorganik: num(
        AppSettingKeys.bonusAnorganik,
        AppValues.categoryBonusAnorganik,
      ),
      bonusDaurUlang: num(
        AppSettingKeys.bonusDaurUlang,
        AppValues.categoryBonusDaurUlang,
      ),
      bonusB3: num(AppSettingKeys.bonusB3, AppValues.categoryBonusB3),
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

  /// Bonus poin kategori organik.
  final int bonusOrganik;

  /// Bonus poin kategori anorganik.
  final int bonusAnorganik;

  /// Bonus poin kategori daur ulang.
  final int bonusDaurUlang;

  /// Bonus poin kategori B3.
  final int bonusB3;

  /// Ubah ke map key -> value untuk disimpan.
  Map<String, String> toMap() {
    return <String, String>{
      AppSettingKeys.gpsRadiusMeters: '$gpsRadiusMeters',
      AppSettingKeys.enforceGpsRadius: '$enforceGpsRadius',
      AppSettingKeys.maxWasteLogsPerDay: '$maxWasteLogsPerDay',
      AppSettingKeys.weeklyMissionTarget: '$weeklyMissionTarget',
      AppSettingKeys.maxPhotoMb: '$maxPhotoMb',
      AppSettingKeys.bonusOrganik: '$bonusOrganik',
      AppSettingKeys.bonusAnorganik: '$bonusAnorganik',
      AppSettingKeys.bonusDaurUlang: '$bonusDaurUlang',
      AppSettingKeys.bonusB3: '$bonusB3',
    };
  }
}
