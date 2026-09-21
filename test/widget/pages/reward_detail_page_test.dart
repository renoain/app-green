// Widget test halaman detail reward.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/points/presentation/pages/reward_detail_page.dart';
import 'package:go_green/features/rewards/presentation/pages/vouchers_page.dart';

Widget _detailApp() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: const RewardDetailPage(rewardId: '1'),
  );
}

Widget _detailRouter() {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: '/reward/2',
        routes: appRoutes,
      ),
    ),
  );
}

void main() {
  testWidgets('menampilkan nama, biaya, benefit, dan tombol tukar',
      (WidgetTester tester) async {
    await tester.pumpWidget(_detailApp());

    expect(find.text(AppStrings.rewardDetailTitle), findsOneWidget);
    expect(find.text(AppStrings.rewardSembako), findsOneWidget);
    expect(find.text('300 Poin'), findsOneWidget);
    expect(find.text(AppStrings.rewardBenefitLabel), findsOneWidget);
    expect(find.text(AppStrings.rewardSembakoDesc), findsOneWidget);
    expect(find.text(AppStrings.rewardExchangeButton), findsOneWidget);
  });

  testWidgets('tombol tukar menampilkan popup konfirmasi animasi',
      (WidgetTester tester) async {
    await tester.pumpWidget(_detailApp());

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.redeemConfirmTitle), findsOneWidget);
    expect(find.text(AppStrings.redeemConfirmMessage), findsOneWidget);
    expect(find.text(AppStrings.cancelButton), findsOneWidget);
  });

  testWidgets('membatalkan penukaran menutup popup',
      (WidgetTester tester) async {
    await tester.pumpWidget(_detailApp());

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.cancelButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.redeemConfirmTitle), findsNothing);
    expect(find.text(AppStrings.redeemSuccessTitle), findsNothing);
  });

  testWidgets('mengonfirmasi penukaran menampilkan popup sukses',
      (WidgetTester tester) async {
    await tester.pumpWidget(_detailApp());

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.rewardExchangeButton).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.redeemSuccessTitle), findsOneWidget);
    expect(find.text(AppStrings.redeemSuccessMessage), findsOneWidget);
    expect(find.text(AppStrings.redeemGoVoucherButton), findsOneWidget);
  });

  testWidgets('popup sukses mengarah ke Voucher Saya',
      (WidgetTester tester) async {
    await tester.pumpWidget(_detailRouter());
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.rewardExchangeButton).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.redeemGoVoucherButton));
    await tester.pumpAndSettle();

    expect(find.byType(VouchersPage), findsOneWidget);
    expect(find.text(AppStrings.voucherTitle), findsOneWidget);
  });
}