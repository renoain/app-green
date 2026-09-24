// Unit test provider dasbor admin (ringkasan angka).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/admin/data/datasources/admin_dashboard_datasource.dart';
import 'package:go_green/features/admin/domain/entities/admin_dashboard_summary.dart';
import 'package:go_green/features/admin/domain/usecases/build_weekly_chart_usecase.dart';
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

  @override
  Future<List<DateTime>> getWeeklyWasteTimestamps() async {
    final DateTime now = DateTime.now();
    return <DateTime>[now, now, now.subtract(const Duration(days: 2))];
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

  test('adminWeeklyChartProvider mengelompokkan 7 batang', () async {
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        adminDashboardDatasourceProvider.overrideWithValue(
          FakeDashboardDatasource(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final List<DailyWasteCount> days =
        await container.read(adminWeeklyChartProvider.future);

    expect(days, hasLength(7));
    final int total = days.fold<int>(
      0,
      (int sum, DailyWasteCount d) => sum + d.count,
    );
    expect(total, 3);
    expect(days.last.count, 2);
  });
}
