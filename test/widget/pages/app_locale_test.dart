// Widget + unit test dwibahasa aplikasi (ID/EN).
//
// AppStrings mengikuti locale aktif; pilihan tersimpan permanen;
// fallback selalu Indonesia.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/localization/app_locale.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/profile/presentation/pages/settings_page.dart';

void main() {
  setUp(() {
    AppStrings.locale = AppLanguages.indonesian;
  });

  tearDown(() {
    AppStrings.locale = AppLanguages.indonesian;
  });

  test('default Indonesia + Inggris tersedia', () {
    expect(AppStrings.locale, AppLanguages.indonesian);
    expect(AppStrings.loginTitle, 'Masuk');

    AppStrings.locale = AppLanguages.english;
    expect(AppStrings.loginTitle, 'Sign In');
    expect(AppStrings.adminDashboard, 'Admin Dashboard');
    expect(AppStrings.settingsLanguage, 'Language');
  });

  test('kode tak dikenal fallback Indonesia', () {
    AppStrings.locale = 'xx';
    expect(AppStrings.locale, AppLanguages.indonesian);
    expect(AppStrings.loginTitle, 'Masuk');
  });

  test('bahasa tersimpan dimuat saat startup', () async {
    SharedPreferences.setMockInitialValues(
      <String, Object>{'app_locale': 'en'},
    );

    final Locale locale = await loadSavedLocale();

    expect(locale, const Locale('en'));
    expect(AppStrings.locale, AppLanguages.english);
    expect(AppStrings.loginTitle, 'Sign In');
  });

  test('tanpa simpanan default Indonesia', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    final Locale locale = await loadSavedLocale();

    expect(locale, const Locale('id'));
    expect(AppStrings.loginTitle, 'Masuk');
  });

  testWidgets('ganti bahasa di Pengaturan mengubah teks UI',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pengaturan'), findsOneWidget);

    await tester.tap(find.text('Inggris'));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsWidgets);
    expect(find.text('English'), findsWidgets);
  });
}
