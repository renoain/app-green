// Widget test navigasi admin: bottom bar, sheet usap-atas, Mode Pengguna.
//
// Bottom bar diuji langsung dengan callback; Mode Pengguna diuji lewat
// shell asli dengan role admin vs petugas.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/domain/entities/admin_dashboard_summary.dart';
import 'package:go_green/features/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_providers.dart';
import 'package:go_green/features/admin/presentation/widgets/admin_bottom_nav.dart';
import 'package:go_green/features/profile/presentation/pages/profile_page.dart';

Widget _shellApp(UserRole role) {
  return ProviderScope(
    overrides: <Override>[
      adminRoleProvider.overrideWith((Ref ref) async => role),
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
  testWidgets('bottom bar tampil 3 menu utama', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          bottomNavigationBar: AdminBottomBar(
            currentIndex: 0,
            visibleCount: 6,
            showUserMode: true,
            onSelectBranch: (_) {},
            onUserMode: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AdminBottomBar), findsOneWidget);
    expect(find.text(AppStrings.adminDashboard), findsOneWidget);
    expect(find.text(AppStrings.adminManageTps), findsOneWidget);
    expect(find.text(AppStrings.adminVerifyWaste), findsOneWidget);
    expect(find.text(AppStrings.adminManageReward), findsNothing);
  });

  testWidgets('ketuk tombol bottom bar memanggil branch', (WidgetTester tester) async {
    int selected = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          bottomNavigationBar: AdminBottomBar(
            currentIndex: 0,
            visibleCount: 6,
            showUserMode: true,
            onSelectBranch: (int index) => selected = index,
            onUserMode: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.adminManageTps));
    expect(selected, 1);
  });

  testWidgets('usap navbar ke atas membuka semua menu + Mode Pengguna',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          bottomNavigationBar: AdminBottomBar(
            currentIndex: 0,
            visibleCount: 6,
            showUserMode: true,
            onSelectBranch: (_) {},
            onUserMode: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.fling(
      find.byType(AdminBottomBar),
      const Offset(0, -300),
      800,
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminMoreMenu), findsOneWidget);
    expect(find.text(AppStrings.adminManageReward), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(AppStrings.adminUserMode),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text(AppStrings.adminUserMode), findsOneWidget);
  });

  testWidgets('sheet tanpa Mode Pengguna bila bukan admin',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          bottomNavigationBar: AdminBottomBar(
            currentIndex: 0,
            visibleCount: 3,
            showUserMode: false,
            onSelectBranch: (_) {},
            onUserMode: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.fling(
      find.byType(AdminBottomBar),
      const Offset(0, -300),
      800,
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminMoreMenu), findsOneWidget);
    expect(find.text(AppStrings.adminUserMode), findsNothing);
  });

  testWidgets('drawer admin menampilkan Mode Pengguna',
      (WidgetTester tester) async {
    await tester.pumpWidget(_shellApp(UserRole.admin));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminUserMode), findsOneWidget);
  });

  testWidgets('Mode Pengguna kembali ke profil user',
      (WidgetTester tester) async {
    await tester.pumpWidget(_shellApp(UserRole.admin));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.adminUserMode));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
  });

  testWidgets('drawer petugas tanpa Mode Pengguna',
      (WidgetTester tester) async {
    await tester.pumpWidget(_shellApp(UserRole.petugas));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminUserMode), findsNothing);
    expect(find.text(AppStrings.adminManageTps), findsWidgets);
  });
}
