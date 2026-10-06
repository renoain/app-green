// Data source autentikasi dummy berbasis json-server (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';

/// Data source auth untuk mode dummy. Register/login baca/tulis tabel
/// profiles di json-server; password tersimpan plain text khusus testing.
class AuthDummyDatasource {
  AuthDummyDatasource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.dummyApiUrl));

  final Dio _dio;

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final Object? data = response.data;
    if (data is List) {
      return data
          .map((Object? item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    return Map<String, dynamic>.from(response.data as Map);
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('AuthDummyDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Cari baris profiles berdasarkan email (exact match).
  Future<Map<String, dynamic>?> findByEmail(String email) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.profiles}',
        queryParameters: <String, dynamic>{'email': email.trim()},
      );
      final List<Map<String, dynamic>> rows = _asList(response);
      return rows.isEmpty ? null : rows.first;
    } catch (error, stackTrace) {
      _logAndRethrow('findByEmail', error, stackTrace);
    }
  }

  /// Cari baris profiles berdasarkan username (lowercase, exact match).
  Future<Map<String, dynamic>?> findByUsername(String username) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.profiles}',
        queryParameters: <String, dynamic>{
          'username': username.trim().toLowerCase(),
        },
      );
      final List<Map<String, dynamic>> rows = _asList(response);
      return rows.isEmpty ? null : rows.first;
    } catch (error, stackTrace) {
      _logAndRethrow('findByUsername', error, stackTrace);
    }
  }

  /// Mengecek apakah username sudah dipakai user lain di json-server.
  Future<bool> isUsernameTaken(String username) async {
    final String normalized = username.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    return (await findByUsername(normalized)) != null;
  }

  /// Mencari email dari username untuk login username di mode dummy.
  Future<String?> findEmailByUsername(String username) async {
    final Map<String, dynamic>? row =
        await findByUsername(username.trim().toLowerCase());
    final String? email = row?['email'] as String?;
    return (email == null || email.isEmpty) ? null : email;
  }

  /// Mendaftarkan akun baru ke json-server. Lempar [AuthException] bila username atau email sudah dipakai.
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    try {
      final String normalizedUsername = username.trim().toLowerCase();
      if (await isUsernameTaken(normalizedUsername)) {
        throw const AuthException(
          'Username already taken',
          code: 'username_taken',
        );
      }
      if (await findByEmail(email.trim()) != null) {
        throw const AuthException(
          'User already registered',
          code: 'user_already_exists',
        );
      }
      final Response<dynamic> response = await _dio.post(
        '/${AppTables.profiles}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'email': email.trim(),
          'username': normalizedUsername,
          'password': password,
          'role': 'user',
          'fcm_token': null,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      return _asMap(response);
    } on AuthException {
      rethrow;
    } catch (error, stackTrace) {
      _logAndRethrow('signUp', error, stackTrace);
    }
  }

  /// Login dengan email/password ke json-server. Lempar [AuthException] bila email tidak ada atau password salah.
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic>? row = await findByEmail(email.trim());
      if (row == null) {
        throw const AuthException(
          'Invalid login credentials',
          code: 'invalid_credentials',
        );
      }
      if ((row['password'] as String?) != password) {
        throw const AuthException(
          'Invalid login credentials',
          code: 'invalid_credentials',
        );
      }
      return row;
    } on AuthException {
      rethrow;
    } catch (error, stackTrace) {
      _logAndRethrow('signIn', error, stackTrace);
    }
  }

  /// Keluar dari sesi dummy (tidak ada state server; sesi dipegang repository).
  Future<void> signOut() async {}
}
