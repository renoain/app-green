// Use case kelola pengaturan operasional (domain).
//
// Validasi batas wajar tinggal di domain agar widget tetap tipis.

import '../../../../core/constants/app_strings.dart';
import '../../data/datasources/admin_settings_datasource.dart';
import '../entities/app_settings_values.dart';

/// Exception validasi pengaturan; [message] aman tampil ke user.
class SettingsValidationException implements Exception {
  /// Membuat exception dengan pesan ramah user.
  const SettingsValidationException(this.message);

  /// Pesan kesalahan.
  final String message;

  @override
  String toString() => message;
}

/// Use case baca/simpan pengaturan operasional oleh admin.
class ManageSettingsUsecase {
  /// Membuat use case.
  const ManageSettingsUsecase(this._datasource);

  final AdminSettingsDatasource _datasource;

  /// Ambil nilai efektif (fallback default bila tabel kosong/gagal).
  Future<AppSettingsValues> load() async {
    try {
      return AppSettingsValues.fromMap(await _datasource.getAll());
    } catch (_) {
      return AppSettingsValues.defaults();
    }
  }

  /// Validasi nilai form pengaturan.
  void validate(AppSettingsValues values) {
    if (values.gpsRadiusMeters < 10 || values.gpsRadiusMeters > 1000) {
      throw const SettingsValidationException(
        AppStrings.adminSettingsRadiusInvalid,
      );
    }
    if (values.maxWasteLogsPerDay < 1 || values.maxWasteLogsPerDay > 20) {
      throw const SettingsValidationException(
        AppStrings.adminSettingsRateInvalid,
      );
    }
    if (values.weeklyMissionTarget < 1 || values.weeklyMissionTarget > 30) {
      throw const SettingsValidationException(
        AppStrings.adminSettingsTargetInvalid,
      );
    }
    if (values.maxPhotoMb < 1 || values.maxPhotoMb > 10) {
      throw const SettingsValidationException(
        AppStrings.adminSettingsPhotoInvalid,
      );
    }
    for (final int bonus in <int>[
      values.bonusOrganik,
      values.bonusAnorganik,
      values.bonusDaurUlang,
      values.bonusB3,
    ]) {
      if (bonus < 0 || bonus > 50) {
        throw const SettingsValidationException(
          AppStrings.adminSettingsBonusInvalid,
        );
      }
    }
  }

  /// Simpan nilai setelah validasi.
  Future<void> save(AppSettingsValues values) async {
    validate(values);
    await _datasource.saveAll(values.toMap());
  }
}
