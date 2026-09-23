// Provider daftar user admin (presentation).
//
// State daftar user terbaru untuk halaman Kelola User.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/admin_users_datasource.dart';
import '../../domain/entities/admin_user.dart';

/// Provider data source daftar user admin.
final Provider<AdminUsersDatasource> adminUsersDatasourceProvider =
    Provider<AdminUsersDatasource>(
  (Ref ref) => AdminUsersDatasource(),
);

/// Notifier daftar user admin.
class AdminUsersNotifier extends StateNotifier<AsyncValue<List<AdminUser>>> {
  /// Membuat notifier dengan data source yang di-inject.
  AdminUsersNotifier(this._datasource)
      : super(const AsyncLoading<List<AdminUser>>());

  final AdminUsersDatasource _datasource;

  /// Memuat daftar user terbaru.
  Future<void> load({int limit = 50}) async {
    state = const AsyncLoading<List<AdminUser>>();
    state = await AsyncValue.guard<List<AdminUser>>(
      () => _datasource.getUsers(limit: limit),
    );
  }
}

/// Provider state daftar user admin.
final StateNotifierProvider<AdminUsersNotifier, AsyncValue<List<AdminUser>>>
    adminUsersProvider =
    StateNotifierProvider<AdminUsersNotifier, AsyncValue<List<AdminUser>>>(
  (Ref ref) => AdminUsersNotifier(ref.watch(adminUsersDatasourceProvider)),
);
