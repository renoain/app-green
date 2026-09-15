// Widget test halaman scan QR.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/scan/presentation/pages/scan_page.dart';

void main() {
  testWidgets('menampilkan viewfinder dan petunjuk', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const ScanPage(),
      ),
    );

    expect(find.text(AppStrings.scanTitle), findsOneWidget);
    expect(find.text(AppStrings.scanHint), findsOneWidget);
    expect(find.text(AppStrings.scanNote), findsOneWidget);
  });
}