// Provider jejak audit admin (presentation).
//
// Daftar log terbaru untuk halaman Log Audit; datasource dipakai ulang
// notifier tulis lain untuk mencatat aksi.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/admin_audit_datasource.dart';
import '../../domain/entities/audit_log.dart';

/// Provider data source audit admin.
final Provider<AdminAuditDatasource> adminAuditDatasourceProvider =
    Provider<AdminAuditDatasource>(
  (Ref ref) => AdminAuditDatasource(),
);

/// Notifier daftar log audit terbaru.
class AdminAuditNotifier extends StateNotifier<AsyncValue<List<AuditLog>>> {
  /// Membuat notifier audit.
  AdminAuditNotifier(this._datasource)
      : super(const AsyncLoading<List<AuditLog>>());

  final AdminAuditDatasource _datasource;

  /// Muat log terbaru.
  Future<void> load({int limit = 50}) async {
    state = const AsyncLoading<List<AuditLog>>();
    state = await AsyncValue.guard<List<AuditLog>>(
      () => _datasource.getRecent(limit: limit),
    );
  }
}

/// Provider state daftar log audit.
final StateNotifierProvider<AdminAuditNotifier, AsyncValue<List<AuditLog>>>
    adminAuditProvider =
    StateNotifierProvider<AdminAuditNotifier, AsyncValue<List<AuditLog>>>(
  (Ref ref) => AdminAuditNotifier(ref.watch(adminAuditDatasourceProvider)),
);
