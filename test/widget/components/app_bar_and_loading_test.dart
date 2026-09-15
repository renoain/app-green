// Widget test untuk komponen CustomAppBar dan LoadingIndicator.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/app_bar_and_loading_widgets.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('menampilkan judul', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          appBar: CustomAppBar(title: 'Profil'),
          body: SizedBox(),
        ),
      ),);

      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('memanggil onLeadingTap saat leading ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          appBar: CustomAppBar(
            title: 'Profil',
            leading: LucideIcons.chevron_left,
            onLeadingTap: () => tapped = true,
          ),
          body: const SizedBox(),
        ),
      ),);

      await tester.tap(find.byIcon(LucideIcons.chevron_left));
      expect(tapped, isTrue);
    });
  });

  group('LoadingIndicator', () {
    testWidgets('menampilkan CircularProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: LoadingIndicator(size: 24),
        ),
      ),);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}