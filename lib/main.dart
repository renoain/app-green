// Entry point aplikasi Go Green.
//
// Menginisialisasi Supabase, membungkus aplikasi dengan ProviderScope,
// dan menampilkan MaterialApp.router dengan tema dan router aplikasi.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(_initSupabase());
  runApp(const ProviderScope(child: GoGreenApp()));
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
class GoGreenApp extends StatelessWidget {
  /// Membuat widget root aplikasi.
  const GoGreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}