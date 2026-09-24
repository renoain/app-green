// Bahasa aplikasi Indonesia/Inggris + persistensi pilihan (presentation).
//
// AppStrings membaca bahasa aktif secara sinkron; provider ini menyimpan
// pilihan ke SharedPreferences dan menerapkannya ke AppStrings.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_strings.dart';

/// Kode bahasa yang didukung aplikasi.
abstract final class AppLanguages {
  AppLanguages._();

  /// Bahasa Indonesia.
  static const String indonesian = 'id';

  /// Bahasa Inggris.
  static const String english = 'en';

  /// Daftar locale untuk MaterialApp.
  static const List<Locale> supported = <Locale>[
    Locale(indonesian),
    Locale(english),
  ];
}

/// Kunci penyimpanan bahasa di SharedPreferences.
const String _localeKey = 'app_locale';

/// Bahasa aktif aplikasi (default Indonesia).
final StateProvider<Locale> localeProvider =
    StateProvider<Locale>((Ref ref) => const Locale(AppLanguages.indonesian));

/// Muat bahasa tersimpan sebelum runApp agar sinkron sejak awal.
Future<Locale> loadSavedLocale() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String code = prefs.getString(_localeKey) ?? AppLanguages.indonesian;
    final Locale locale = Locale(
      code == AppLanguages.english
          ? AppLanguages.english
          : AppLanguages.indonesian,
    );
    AppStrings.locale = locale.languageCode;
    return locale;
  } catch (_) {
    return const Locale(AppLanguages.indonesian);
  }
}

/// Ganti bahasa: state + AppStrings + simpan permanen.
Future<void> setAppLocale(WidgetRef ref, Locale locale) async {
  ref.read(localeProvider.notifier).state = locale;
  AppStrings.locale = locale.languageCode;
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  } catch (_) {
    // Gagal simpan tidak menggagalkan ganti bahasa sesi ini.
  }
}
