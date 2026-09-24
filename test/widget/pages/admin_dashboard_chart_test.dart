// Widget test grafik dasbor admin.
//
// Judul + 7 label hari + angka tampil dari provider palsu; tanpa backend.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/data/datasources/admin_dashboard_datasource.dart';
import 'package:go_green/features/admin/domain/entities/admin_dashboard_summary.dart';
import 'package:go_green/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:go_green/features/admin/presentation/providers/admin_dashboard_provider.dart';

/// Datasource dasbor palsu dengan ringkasan + 3 setoran.
class _FakeChartDatasource extends AdminDashboardDatasource {
  _FakeChartDatasource() : super(client: null);

  @override
  Future<AdminDashboardSummary> getSummary() async {
    return const AdminDashboardSummary(
      totalUsers: 10,
      totalCheckpoints: 3,
      wasteToday: 2,
      wastePending: 1,
      totalPoints: 120,
    );
  }

  @override
  Future<List<DateTime>> getWeeklyWasteTimestamps() async {
    final DateTime now = DateTime.now();
    return <DateTime>[now, now, now.subtract(const Duration(days: 2))];
  }
}

void main() {
  testWidgets('grafik 7 hari tampil judul + batang + angka',
      (WidgetTester tester) async {
    // Viewport seukuran HP agar grid tidak mendorong kartu keluar layar.
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          adminDashboardDatasourceProvider
              .overrideWithValue(_FakeChartDatasource()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminDashboardPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminChartTitle), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.text(AppStrings.adminChartEmpty), findsNothing);
    // 7 label hari singkat selalu tampil.
    final Finder dayLabels = find.byWidgetPredicate(
      (Widget w) =>
          w is Text &&
          <String>['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
              .contains(w.data),
    );
    expect(dayLabels, findsNWidgets(7));
  });

  testWidgets('grafik kosong menampilkan pesan empty',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          adminDashboardProvider.overrideWith(
            (Ref ref) async => const AdminDashboardSummary(
              totalUsers: 0,
              totalCheckpoints: 0,
              wasteToday: 0,
              wastePending: 0,
              totalPoints: 0,
            ),
          ),
          adminWeeklyChartProvider.overrideWith((Ref ref) async => const []),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminDashboardPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminChartTitle), findsOneWidget);
    expect(find.text(AppStrings.adminChartEmpty), findsOneWidget);
  });
}
