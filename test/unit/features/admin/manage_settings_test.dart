// Unit test kelola pengaturan operasional + AppConfig runtime.
//
// Validasi batas wajar, fallback default saat backend gagal, dan
// override AppConfig yang deterministik di test.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_green/core/constants/app_config.dart';
import 'package:go_green/core/constants/app_values.dart';
import 'package:go_green/features/admin/data/datasources/admin_settings_datasource.dart';
import 'package:go_green/features/admin/domain/entities/app_settings_values.dart';
import 'package:go_green/features/admin/domain/usecases/manage_settings_usecase.dart';

/// Datasource palsu (gagal atau berhasil sesuai flag).
class _FakeSettingsDatasource extends AdminSettingsDatasource {
  _FakeSettingsDatasource({this.fail = false}) : super(client: null);

  final bool fail;
  Map<String, String>? saved;

  @override
  Future<Map<String, String>> getAll() async {
    if (fail) throw Exception('offline');
    return AppSettingsValues.defaults().toMap();
  }

  @override
  Future<void> saveAll(Map<String, String> values) async {
    saved = values;
  }
}

void main() {
  setUp(AppConfig.clear);
  tearDown(AppConfig.clear);

  test('radius di luar 10-1000 ditolak', () {
    final ManageSettingsUsecase usecase =
        ManageSettingsUsecase(_FakeSettingsDatasource());
    const AppSettingsValues values = AppSettingsValues(
      gpsRadiusMeters: 5,
      enforceGpsRadius: true,
      maxWasteLogsPerDay: 5,
      weeklyMissionTarget: 5,
      maxPhotoMb: 5,
    );
    expect(
      () => usecase.validate(values),
      throwsA(isA<SettingsValidationException>()),
    );
  });

  test('batas harian nol ditolak, foto 11MB ditolak', () {
    final ManageSettingsUsecase usecase =
        ManageSettingsUsecase(_FakeSettingsDatasource());
    expect(
      () => usecase.validate(
        const AppSettingsValues(
          gpsRadiusMeters: 100,
          enforceGpsRadius: true,
          maxWasteLogsPerDay: 0,
          weeklyMissionTarget: 5,
          maxPhotoMb: 5,
        ),
      ),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => usecase.validate(
        const AppSettingsValues(
          gpsRadiusMeters: 100,
          enforceGpsRadius: true,
          maxWasteLogsPerDay: 5,
          weeklyMissionTarget: 5,
          maxPhotoMb: 11,
        ),
      ),
      throwsA(isA<SettingsValidationException>()),
    );
  });

  test('nilai default lolos validasi + tersimpan', () async {
    final _FakeSettingsDatasource ds = _FakeSettingsDatasource();
    final ManageSettingsUsecase usecase = ManageSettingsUsecase(ds);
    await usecase.save(AppSettingsValues.defaults());
    expect(ds.saved?[AppSettingKeys.gpsRadiusMeters], '100');
  });

  test('load gagal memakai fallback default', () async {
    final ManageSettingsUsecase usecase =
        ManageSettingsUsecase(_FakeSettingsDatasource(fail: true));
    final AppSettingsValues values = await usecase.load();
    expect(values.gpsRadiusMeters, 100);
    expect(values.enforceGpsRadius, isTrue);
  });

  test('AppConfig default sama dengan AppValues', () {
    expect(AppConfig.gpsRadiusMeters, AppValues.gpsRadiusMeters);
    expect(AppConfig.enforceGpsRadius, AppValues.enforceGpsRadius);
    expect(AppConfig.maxWasteLogsPerDay, AppValues.maxWasteLogsPerDay);
    expect(
      AppConfig.weeklyMissionTargetDisposals,
      AppValues.weeklyMissionTargetDisposals,
    );
  });

  test('AppConfig override berlaku lalu clear kembali', () {
    AppConfig.apply(<String, String>{
      AppSettingKeys.gpsRadiusMeters: '250',
      AppSettingKeys.enforceGpsRadius: 'false',
      AppSettingKeys.maxWasteLogsPerDay: '10',
    });
    expect(AppConfig.gpsRadiusMeters, 250);
    expect(AppConfig.enforceGpsRadius, isFalse);
    expect(AppConfig.maxWasteLogsPerDay, 10);
    AppConfig.clear();
    expect(AppConfig.gpsRadiusMeters, AppValues.gpsRadiusMeters);
  });
}
