// Data source autentikasi Laravel via Sanctum (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/utils/logger.dart';

/// Kunci penyimpanan token Sanctum di SharedPreferences.
const String laravelTokenKey = 'laravel_token';

/// Data source auth untuk mode Laravel. Token Sanctum disimpan di
/// SharedPreferences dan dikirim sebagai header Bearer.
class AuthLaravelDatasource {
  AuthLaravelDatasource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.laravelApiUrl));

  final Dio _dio;

  Map<String, dynamic> _dataMap(Response<dynamic> response) {
    final Object? body = response.data;
    if (body is Map) {
      final Object? data = body['data'];
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    }
    return const <String, dynamic>{};
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('AuthLaravelDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  Options _authOptions(String? token) {
    if (token == null || token.isEmpty) {
      return Options();
    }
    return Options(
      headers: <String, dynamic>{'Authorization': 'Bearer $token'},
    );
  }

  /// Mendaftarkan akun baru ke Laravel. Mengembalikan data {user, profile, token}.
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/register',
        data: <String, dynamic>{
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        },
      );
      final Map<String, dynamic> data = _dataMap(response);
      final String? token = data['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await saveToken(token);
      }
      return data;
    } catch (error, stackTrace) {
      _logAndRethrow('register', error, stackTrace);
    }
  }

  /// Login email/password ke Laravel. Mengembalikan data {user, profile, token}.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/login',
        data: <String, dynamic>{
          'email': email.trim(),
          'password': password,
        },
      );
      final Map<String, dynamic> data = _dataMap(response);
      final String? token = data['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await saveToken(token);
      }
      return data;
    } catch (error, stackTrace) {
      _logAndRethrow('login', error, stackTrace);
    }
  }

  /// Logout dari Laravel dan hapus token lokal.
  Future<void> logout() async {
    try {
      final String? token = await getToken();
      await _dio.post('/logout', options: _authOptions(token));
    } catch (error, stackTrace) {
      AppLogger.error('AuthLaravelDatasource.logout gagal', error, stackTrace);
    } finally {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(laravelTokenKey);
    }
  }

  /// Mengambil profil user saat ini dari Laravel, atau null bila belum login.
  Future<Map<String, dynamic>?> me() async {
    try {
      final String? token = await getToken();
      if (token == null || token.isEmpty) {
        return null;
      }
      final Response<dynamic> response = await _dio.get(
        '/me',
        options: _authOptions(token),
      );
      final Map<String, dynamic> data = _dataMap(response);
      return data.isEmpty ? null : data;
    } catch (error, stackTrace) {
      _logAndRethrow('me', error, stackTrace);
    }
  }

  /// Menyimpan token Sanctum.
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(laravelTokenKey, token);
  }

  /// Membaca token Sanctum, atau null bila belum login.
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(laravelTokenKey);
  }
}
