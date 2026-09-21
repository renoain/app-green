// Unit test provider dasbor admin (ringkasan angka).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/admin/data/datasources/admin_dashboard_datasource.dart';
import 'package:go_green/features/admin/domain/entities/admin_dashboard_summary.dart';
import 'package:go_green/features/admin/presentation/providers/admin_dashboard_provider.dart';

/// Data source palsu: ringkasan tetap tanpa Supabase.
class FakeDashboardDatasource extends AdminDashboardDatasource {
  @override
  Future<AdminDashboardSummary> getSummary() async {
    return const AdminDashboardSummary(
      totalUsers: 10,
      totalCheckpoints: 4,
      wasteToday: 7,
      wastePending: 3,
      totalPoints: 1250,
    );
  }
}

void main() {
  test('adminDashboardProvider meneruskan ringkasan datasource', () async {
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        adminDashboardDatasourceProvider.overrideWithValue(
          FakeDashboardDatasource(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final AdminDashboardSummary summary =
        await container.read(adminDashboardProvider.future);

    expect(summary.totalUsers, 10);
    expect(summary.totalCheckpoints, 4);
    expect(summary.wasteToday, 7);
    expect(summary.wastePending, 3);
    expect(summary.totalPoints, 1250);
  });
}
