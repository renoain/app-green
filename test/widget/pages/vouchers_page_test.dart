// Widget test halaman Voucher Saya (mode tamu).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/rewards/presentation/pages/vouchers_page.dart';

void main() {
  testWidgets('tamu melihat judul dan notice login',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const VouchersPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.voucherTitle), findsOneWidget);
    expect(find.text(AppStrings.profileLoginNotice), findsOneWidget);
    expect(find.text(AppStrings.voucherEmptyMessage), findsNothing);
  });
}
