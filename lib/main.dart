// Entry point aplikasi Go Green.
//
// Memuat bahasa tersimpan, menginisialisasi Supabase, membungkus
// aplikasi dengan ProviderScope, dan menampilkan MaterialApp.router
// dengan tema, router, dan locale aplikasi.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/localization/app_locale.dart';
import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Locale savedLocale = await loadSavedLocale();
  unawaited(_initSupabase());
  runApp(
    ProviderScope(
      overrides: <Override>[
        localeProvider.overrideWith((Ref ref) => savedLocale),
      ],
      child: const GoGreenApp(),
    ),
  );
}

/// Inisialisasi Supabase tanpa memblokir render awal.
Future<void> _initSupabase() async {
  try {
    await SupabaseService.instance.init();
  } catch (error, stackTrace) {
    AppLogger.error('Gagal inisialisasi Supabase', error, stackTrace);
  }
}

/// Widget root aplikasi Go Green.
class GoGreenApp extends ConsumerWidget {
  /// Membuat widget root aplikasi.
  const GoGreenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: AppLanguages.supported,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
