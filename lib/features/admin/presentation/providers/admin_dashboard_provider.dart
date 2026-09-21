// Provider dasbor admin (presentation).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/admin_dashboard_datasource.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

/// Provider data source ringkasan dasbor admin.
final Provider<AdminDashboardDatasource> adminDashboardDatasourceProvider =
    Provider<AdminDashboardDatasource>(
  (Ref ref) => AdminDashboardDatasource(),
);

/// Ringkasan angka dasbor admin (total user, TPS, waste, poin).
final FutureProvider<AdminDashboardSummary> adminDashboardProvider =
    FutureProvider<AdminDashboardSummary>((Ref ref) async {
  return ref.watch(adminDashboardDatasourceProvider).getSummary();
});
