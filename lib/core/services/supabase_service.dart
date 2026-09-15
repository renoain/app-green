// Service inisialisasi Supabase.
//
// Kredensial dibaca berurutan:
// 1. --dart-define (SUPABASE_URL / SUPABASE_ANON_KEY) saat run,
//    contoh: flutter run --dart-define=SUPABASE_URL=...
//    --dart-define=SUPABASE_ANON_KEY=...
// 2. File .env (di-gitignore) bila dart-define kosong.
//
// Dilarang hardcode secret di file ini.

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service Supabase untuk Go Green.
///
/// Memastikan Supabase terinisialisasi sekali sebelum aplikasi berjalan
/// dan menyediakan akses ke [client].
class SupabaseService {
  SupabaseService._();

  /// Instance tunggal service.
  static final SupabaseService instance = SupabaseService._();

  bool _isInitialized = false;
  bool _isInitializing = false;

  /// Apakah Supabase sudah berhasil diinisialisasi.
  bool get isInitialized => _isInitialized;

  /// Menginisialisasi Supabase dengan kredensial dari environment.
  Future<void> init() async {
    if (_isInitialized || _isInitializing) {
      return;
    }
    _isInitializing = true;
    try {
      await _loadDotenvIfNeeded();
      final String supabaseUrl = _valueOrEmpty(
        const String.fromEnvironment('SUPABASE_URL'),
        dotenv.env['SUPABASE_URL'],
      );
      final String supabaseAnonKey = _valueOrEmpty(
        const String.fromEnvironment('SUPABASE_ANON_KEY'),
        dotenv.env['SUPABASE_ANON_KEY'],
      );
      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw StateError(
          'Kredensial Supabase belum tersedia. Isi .env atau '
          'pakai --dart-define SUPABASE_URL dan SUPABASE_ANON_KEY.',
        );
      }
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseAnonKey,
      );
      _isInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _loadDotenvIfNeeded() async {
    if (dotenv.isInitialized) {
      return;
    }
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // File .env boleh tidak ada; pakai --dart-define sebagai fallback.
    }
  }

  /// Mengembalikan nilai pertama yang tidak kosong dari dua sumber.
  String _valueOrEmpty(String primary, String? fallback) {
    if (primary.isNotEmpty) {
      return primary;
    }
    final String? trimmed = fallback?.trim();
    return (trimmed == null || trimmed.isEmpty) ? '' : trimmed;
  }

  /// Client Supabase yang sudah aktif.
  SupabaseClient get client => Supabase.instance.client;

  /// User yang sedang login, atau null bila belum login atau Supabase
  /// belum terinisialisasi (mode demo / test widget).
  User? get currentUser {
    if (!_isInitialized) {
      return null;
    }
    return client.auth.currentUser;
  }

  /// Keluar dari sesi. Aman dipanggil meski Supabase belum terinisialisasi.
  Future<void> signOut() async {
    if (!_isInitialized) {
      return;
    }
    await client.auth.signOut();
  }
}