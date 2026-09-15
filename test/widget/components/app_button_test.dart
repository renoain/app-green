// Widget test untuk komponen tombol: PrimaryButton, SecondaryButton,
// dan AppTextButton.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/app_button_widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('PrimaryButton', () {
    testWidgets('menampilkan label', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        const PrimaryButton(text: 'Masuk', onPressed: null),
      ),);

      expect(find.text('Masuk'), findsOneWidget);
    });

    testWidgets('memicu onPressed saat ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        PrimaryButton(text: 'Masuk', onPressed: () => tapped = true),
      ),);

      await tester.tap(find.byType(PrimaryButton));
      expect(tapped, isTrue);
    });

    testWidgets('menampilkan indikator loading saat isLoading', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        PrimaryButton(text: 'Masuk', onPressed: () {}, isLoading: true),
      ),);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Masuk'), findsNothing);
    });
  });

  group('SecondaryButton', () {
    testWidgets('menampilkan label dan memicu onPressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        SecondaryButton(text: 'Batal', onPressed: () => tapped = true),
      ),);

      expect(find.text('Batal'), findsOneWidget);
      await tester.tap(find.byType(SecondaryButton));
      expect(tapped, isTrue);
    });
  });

  group('AppTextButton', () {
    testWidgets('menampilkan label dan memicu onPressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        AppTextButton(text: 'Daftar di sini', onPressed: () => tapped = true),
      ),);

      expect(find.text('Daftar di sini'), findsOneWidget);
      await tester.tap(find.byType(AppTextButton));
      expect(tapped, isTrue);
    });
  });
}