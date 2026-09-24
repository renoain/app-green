// Provider pengaturan operasional admin (presentation).
//
// State nilai terketik + simpan via ManageSettingsUsecase; usai simpan
// terapkan ke AppConfig agar langsung berlaku tanpa restart.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_config.dart';
import '../../data/datasources/admin_settings_datasource.dart';
import '../../domain/entities/app_settings_values.dart';
import '../../domain/usecases/manage_settings_usecase.dart';

/// Provider data source pengaturan admin.
final Provider<AdminSettingsDatasource> adminSettingsDatasourceProvider =
    Provider<AdminSettingsDatasource>(
  (Ref ref) => AdminSettingsDatasource(),
);

/// Provider use case pengaturan admin.
final Provider<ManageSettingsUsecase> manageSettingsUsecaseProvider =
    Provider<ManageSettingsUsecase>(
  (Ref ref) => ManageSettingsUsecase(ref.watch(adminSettingsDatasourceProvider)),
);

/// Notifier nilai pengaturan admin.
class AdminSettingsNotifier extends StateNotifier<AsyncValue<AppSettingsValues>> {
  /// Membuat notifier pengaturan admin.
  AdminSettingsNotifier(this._usecase)
      : super(const AsyncLoading<AppSettingsValues>());

  final ManageSettingsUsecase _usecase;

  /// Muat nilai dari server (fallback default).
  Future<void> load() async {
    state = const AsyncLoading<AppSettingsValues>();
    state = await AsyncValue.guard<AppSettingsValues>(() => _usecase.load());
  }

  /// Simpan nilai lalu terapkan ke runtime.
  Future<void> save(AppSettingsValues values) async {
    await _usecase.save(values);
    AppConfig.apply(values.toMap());
    state = AsyncData<AppSettingsValues>(values);
  }
}

/// Provider state pengaturan admin.
final StateNotifierProvider<AdminSettingsNotifier,
        AsyncValue<AppSettingsValues>> adminSettingsProvider =
    StateNotifierProvider<AdminSettingsNotifier,
        AsyncValue<AppSettingsValues>>(
  (Ref ref) => AdminSettingsNotifier(ref.watch(manageSettingsUsecaseProvider)),
);
