// Penyimpanan token sesi di keystore perangkat (bukan SharedPreferences polos).

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';

/// Menyimpan dan membaca token sesi memakai keystore perangkat.
///
/// Android memakai EncryptedSharedPreferences, iOS memakai Keychain. Bila
/// keystore tidak tersedia (web, Linux tanpa keyring, atau lingkungan widget
/// test yang tidak punya platform channel), service otomatis jatuh ke
/// penyimpanan in-memory supaya aplikasi tetap berjalan.
///
/// Nilai token lama yang masih tersimpan di SharedPreferences (sebelum migrasi
/// ke secure storage) dipindahkan sekali lalu dihapus dari sana.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  /// Kunci token sesi Laravel.
  static const String laravelTokenKey = 'laravel_token';

  final FlutterSecureStorage _storage;
  final Map<String, String> _fallbackStore = <String, String>{};
  bool _fallbackActive = kIsWeb;

  /// Menulis nilai untuk [key].
  Future<void> write(String key, String value) async {
    if (_fallbackActive) {
      _fallbackStore[key] = value;
      return;
    }
    try {
      await _storage.write(key: key, value: value);
    } catch (error, stackTrace) {
      _useFallback('write', error, stackTrace);
      _fallbackStore[key] = value;
    }
  }

  /// Membaca nilai [key], atau null bila tidak ada atau gagal dibaca.
  Future<String?> read(String key) async {
    if (_fallbackActive) return _fallbackStore[key];
    try {
      final String? value = await _storage.read(key: key);
      await _migrateLegacyToken(key);
      return value;
    } catch (error, stackTrace) {
      _useFallback('read', error, stackTrace);
      return _fallbackStore[key];
    }
  }

  /// Menghapus nilai [key].
  Future<void> delete(String key) async {
    _fallbackStore.remove(key);
    if (_fallbackActive) return;
    try {
      await _storage.delete(key: key);
    } catch (error, stackTrace) {
      _useFallback('delete', error, stackTrace);
    }
  }

  /// Menandai keystore tidak bisa dipakai dan berpindah ke in-memory.
  void _useFallback(String operation, Object error, StackTrace stackTrace) {
    _fallbackActive = true;
    AppLogger.warning(
      'Keystore tidak tersedia pada operasi $operation, '
      'token disimpan sementara di memori saja.',
    );
  }

  /// Memindahkan token lama dari SharedPreferences ke secure storage lalu
  /// menghapus salinannya, agar token tidak lagi tersimpan di file polos.
  Future<void> _migrateLegacyToken(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? legacy = prefs.getString(key);
      if (legacy == null || legacy.isEmpty) return;
      await _storage.write(key: key, value: legacy);
      await prefs.remove(key);
    } catch (error, stackTrace) {
      AppLogger.error(
        'TokenStorage migrasi token lama gagal',
        error,
        stackTrace,
      );
    }
  }
}

/// Instance tunggal untuk dipakai seluruh lapisan data.
final TokenStorage tokenStorage = TokenStorage();

/// Header Authorization untuk request terautentikasi. Kosong bila belum login.
Future<Options> authOptions() async {
  return Options(headers: await authHeaders());
}

/// Header Authorization untuk request terautentikasi. Kosong bila belum login.
Future<Map<String, dynamic>> authHeaders() async {
  final String? token = await tokenStorage.read(TokenStorage.laravelTokenKey);
  if (token == null || token.isEmpty) return const <String, dynamic>{};
  return <String, dynamic>{'Authorization': 'Bearer $token'};
}