// Widget test halaman detail reward.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/points/presentation/pages/reward_detail_page.dart';

void main() {
  testWidgets('menampilkan nama, biaya, benefit, dan tombol tukar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const RewardDetailPage(rewardId: '1'),
      ),
    );

    expect(find.text(AppStrings.rewardDetailTitle), findsOneWidget);
    expect(find.text(AppStrings.rewardSembako), findsOneWidget);
    expect(find.text('300 Poin'), findsOneWidget);
    expect(find.text(AppStrings.rewardBenefitLabel), findsOneWidget);
    expect(find.text(AppStrings.rewardSembakoDesc), findsOneWidget);
    expect(find.text(AppStrings.rewardExchangeButton), findsOneWidget);
  });

  testWidgets('tombol tukar menampilkan dialog konfirmasi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const RewardDetailPage(rewardId: '2'),
      ),
    );

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(AppStrings.redeemConfirmTitle), findsOneWidget);
    expect(find.text(AppStrings.redeemConfirmMessage), findsOneWidget);
    expect(find.text(AppStrings.cancelButton), findsOneWidget);
  });

  testWidgets('membatalkan penukaran tidak menampilkan pesan sukses',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const RewardDetailPage(rewardId: '2'),
      ),
    );

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.cancelButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text(AppStrings.redeemSuccess), findsNothing);
  });

  testWidgets('mengonfirmasi penukaran menampilkan pesan sukses',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const RewardDetailPage(rewardId: '2'),
      ),
    );

    await tester.tap(find.text(AppStrings.rewardExchangeButton));
    await tester.pumpAndSettle();

    final Finder dialogExchange = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text(AppStrings.rewardExchangeButton),
    );
    await tester.tap(dialogExchange);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.redeemSuccess), findsOneWidget);
  });
}