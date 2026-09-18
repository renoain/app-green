// Widget test halaman poin dan reward.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/points/presentation/pages/points_page.dart';
import 'package:go_green/features/points/presentation/pages/reward_detail_page.dart';

void main() {
  testWidgets('menampilkan judul, saldo, reward, dan riwayat poin',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const PointsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.pointsTitle), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
    expect(find.text(AppStrings.rewardsSectionTitle), findsOneWidget);
    expect(find.text(AppStrings.rewardSembako), findsOneWidget);
    expect(find.text(AppStrings.rewardVoucher), findsOneWidget);
    expect(find.text(AppStrings.rewardWallet), findsOneWidget);
    expect(find.text(AppStrings.rewardDonasi), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(AppStrings.pointsHistoryTitle),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(AppStrings.pointsHistoryTitle), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('300 Poin'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('300 Poin'), findsOneWidget);
  });

  testWidgets('membuka detail saat reward ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/points',
            routes: appRoutes,
          ),
        ),
      ),
    );

    await tester.tap(find.text(AppStrings.rewardSembako));
    await tester.pumpAndSettle();

    expect(find.byType(RewardDetailPage), findsOneWidget);
    expect(find.text(AppStrings.rewardDetailTitle), findsOneWidget);
  });
}