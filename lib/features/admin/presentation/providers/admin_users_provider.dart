// Provider daftar user admin (presentation).
//
// State daftar user terbaru + cari/filter role + ubah role via
// ManageUserUsecase (cegah admin mencabut role sendiri).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_enums.dart';
import '../../data/datasources/admin_audit_datasource.dart';
import '../../data/datasources/admin_users_datasource.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/usecases/manage_user_usecase.dart';
import 'admin_audit_provider.dart';

/// Provider data source daftar user admin.
final Provider<AdminUsersDatasource> adminUsersDatasourceProvider =
    Provider<AdminUsersDatasource>(
  (Ref ref) => AdminUsersDatasource(),
);

/// Provider use case kelola user admin.
final Provider<ManageUserUsecase> manageUserUsecaseProvider =
    Provider<ManageUserUsecase>(
  (Ref ref) => ManageUserUsecase(ref.watch(adminUsersDatasourceProvider)),
);

/// Kata kunci cari user admin (nama/email).
final StateProvider<String> adminUserSearchProvider =
    StateProvider<String>((Ref ref) => '');

/// Filter role user admin (null berarti semua).
final StateProvider<UserRole?> adminUserRoleFilterProvider =
    StateProvider<UserRole?>((Ref ref) => null);

/// Notifier daftar user admin.
class AdminUsersNotifier extends StateNotifier<AsyncValue<List<AdminUser>>> {
  /// Membuat notifier dengan use case yang di-inject.
  AdminUsersNotifier(this._usecase, this._datasource, {AdminAuditDatasource? audit})
      : _audit = audit ?? AdminAuditDatasource(),
        super(const AsyncLoading<List<AdminUser>>());

  final ManageUserUsecase _usecase;
  final AdminUsersDatasource _datasource;
  final AdminAuditDatasource _audit;

  /// Memuat daftar user terbaru.
  Future<void> load({int limit = 50}) async {
    state = const AsyncLoading<List<AdminUser>>();
    state = await AsyncValue.guard<List<AdminUser>>(
      () => _datasource.getUsers(limit: limit),
    );
  }

  /// Daftar tersaring kata kunci + role.
  List<AdminUser> filtered(String query, UserRole? role) {
    final List<AdminUser> all = state.maybeWhen(
      data: (List<AdminUser> value) => value,
      orElse: () => <AdminUser>[],
    );
    final String keyword = query.trim().toLowerCase();
    return all.where((AdminUser user) {
      if (role != null && user.role != role) return false;
      if (keyword.isEmpty) return true;
      final String name = (user.username ?? '').toLowerCase();
      final String email = (user.email ?? '').toLowerCase();
      return name.contains(keyword) || email.contains(keyword);
    }).toList();
  }

  /// Ubah role user lalu muat ulang daftar.
  Future<void> updateRole({
    required String currentUserId,
    required String targetId,
    required UserRole role,
  }) async {
    await _usecase.updateRole(
      currentUserId: currentUserId,
      targetId: targetId,
      role: role,
    );
    await _audit.log(
      action: AuditAction.changeRole,
      entity: AuditEntity.user,
      entityId: targetId,
      detail: role.value,
    );
    await load();
  }
}

/// Provider state daftar user admin.
final StateNotifierProvider<AdminUsersNotifier, AsyncValue<List<AdminUser>>>
    adminUsersProvider =
    StateNotifierProvider<AdminUsersNotifier, AsyncValue<List<AdminUser>>>(
  (Ref ref) => AdminUsersNotifier(
    ref.watch(manageUserUsecaseProvider),
    ref.watch(adminUsersDatasourceProvider),
    audit: ref.watch(adminAuditDatasourceProvider),
  ),
);
