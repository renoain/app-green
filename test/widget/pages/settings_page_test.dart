// Widget test halaman pengaturan.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/profile/presentation/pages/settings_page.dart';

void main() {
  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: GoRouter(
          initialLocation: '/settings',
          routes: appRoutes,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('menampilkan menu akun, preferensi, dan informasi',
      (WidgetTester tester) async {
    await pumpSettings(tester);

    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
    expect(find.text(AppStrings.settingsAccountTitle), findsOneWidget);
    expect(find.text(AppStrings.settingsPreferencesTitle), findsOneWidget);
    expect(find.text(AppStrings.settingsNotification), findsOneWidget);
    expect(find.text(AppStrings.settingsNotificationDesc), findsOneWidget);
    expect(find.text(AppStrings.settingsDarkMode), findsOneWidget);
    expect(find.text(AppStrings.settingsDarkModeDesc), findsOneWidget);
    expect(find.text(AppStrings.settingsInfoTitle), findsOneWidget);
    expect(find.text(AppStrings.settingsVersion), findsOneWidget);
    expect(find.text(AppStrings.settingsVersionValue), findsOneWidget);
    expect(find.text(AppStrings.settingsAbout), findsOneWidget);
  });

  testWidgets('toggle mode gelap dapat diaktifkan dan dinonaktifkan',
      (WidgetTester tester) async {
    await pumpSettings(tester);

    final Finder darkSwitch = find.byType(Switch).at(1);
    expect(tester.widget<Switch>(darkSwitch).value, isFalse);

    await tester.tap(darkSwitch);
    await tester.pump();
    expect(tester.widget<Switch>(darkSwitch).value, isTrue);

    await tester.tap(darkSwitch);
    await tester.pump();
    expect(tester.widget<Switch>(darkSwitch).value, isFalse);
  });

  testWidgets('menampilkan dialog tentang saat baris tentang ditekan',
      (WidgetTester tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text(AppStrings.settingsAbout));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(AppStrings.appName), findsWidgets);
  });
}