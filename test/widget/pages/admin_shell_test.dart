// Widget test kerangka admin (regresi layar merah).
//
// Memompa route asli /admin/dashboard: AdminShell tidak boleh menulis
// state provider saat widget tree dibangun (addPostFrameCallback),
// dan tombol menu harus membuka drawer.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/domain/entities/admin_dashboard_summary.dart';
import 'package:go_green/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:go_green/features/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_providers.dart';

Widget _testApp() {
  return ProviderScope(
    overrides: <Override>[
      adminRoleProvider.overrideWith(
        (Ref ref) async => UserRole.admin,
      ),
      adminDashboardProvider.overrideWith(
        (Ref ref) async => const AdminDashboardSummary(
          totalUsers: 10,
          totalCheckpoints: 3,
          wasteToday: 5,
          wastePending: 2,
          totalPoints: 120,
        ),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: '/admin/dashboard',
        routes: appRoutes,
      ),
    ),
  );
}

void main() {
  testWidgets('shell admin terpasang tanpa error provider',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AdminDashboardPage), findsOneWidget);
  });

  testWidgets('tombol menu membuka drawer', (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Drawer), findsOneWidget);
  });
}
