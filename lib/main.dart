// Entry point aplikasi Go Green.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/localization/app_locale.dart';
import 'core/router/app_router.dart';
import 'core/services/push_notification_service.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'features/auth/domain/entities/auth_session.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/profile/data/datasources/push_token_datasource.dart';

/// Layanan push global (best effort, nonaktif tanpa Firebase).
final PushNotificationService pushService = PushNotificationService(
  saveToken: ({required String userId, required String token}) =>
      PushTokenDatasource().saveToken(userId: userId, token: token),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  final Locale savedLocale = await loadSavedLocale();
  unawaited(_initSupabase());
  unawaited(_initPush());
  runApp(
    ProviderScope(
      overrides: <Override>[
        localeProvider.overrideWith((Ref ref) => savedLocale),
      ],
      child: const GoGreenApp(),
    ),
  );
}

/// Memuat .env sebelum runApp agar AppEnv.dataSource sudah benar saat
/// provider pertama dibuat (hindari fallback supabase karena race).
Future<void> _loadEnv() async {
  if (dotenv.isInitialized) {
    return;
  }
  try {
    await dotenv.load(fileName: '.env');
  } catch (error, stackTrace) {
    AppLogger.error('Gagal memuat .env', error, stackTrace);
  }
}

/// Inisialisasi Supabase tanpa memblokir render awal.
Future<void> _initSupabase() async {
  try {
    await SupabaseService.instance.init();
  } catch (error, stackTrace) {
    AppLogger.error('Gagal inisialisasi Supabase', error, stackTrace);
  }
}

/// Inisialisasi push tanpa memblokir render awal.
Future<void> _initPush() async {
  try {
    await pushService.init(
      onRoute: (String routeName) {
        try {
          appRouter.goNamed(routeName);
        } catch (error, stackTrace) {
          AppLogger.error('Gagal buka route push', error, stackTrace);
        }
      },
    );
    await pushService.saveTokenForCurrentUser();
  } catch (error, stackTrace) {
    AppLogger.error('Gagal inisialisasi push', error, stackTrace);
  }
}

/// Widget root aplikasi Go Green.
class GoGreenApp extends ConsumerWidget {
  const GoGreenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(localeProvider);
    ref.listen<AuthSession>(authNotifierProvider, (_, AuthSession next) {
      if (next.isLoggedIn) unawaited(pushService.saveTokenForCurrentUser());
    });
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
