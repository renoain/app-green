// Implementasi repository autentikasi Laravel via Sanctum (data layer).

import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_laravel_datasource.dart';

/// Repository auth mode Laravel. Sesi dipegang di memori dan dipulihkan
/// dari token Sanctum tersimpan; login username tidak didukung server
/// sehingga identifier non-email langsung gagal.
class LaravelAuthRepository implements AuthRepository {
  LaravelAuthRepository({AuthLaravelDatasource? datasource})
      : _datasource = datasource ?? AuthLaravelDatasource();

  final AuthLaravelDatasource _datasource;
  final StreamController<AuthSession> _sessions =
      StreamController<AuthSession>.broadcast();

  Map<String, dynamic>? _currentData;

  AuthSession _sessionOf(Map<String, dynamic>? data) {
    if (data == null) {
      return const AuthSession();
    }
    final Object? user = data['user'];
    final Object? profile = data['profile'];
    final String? email = user is Map
        ? user['email'] as String?
        : profile is Map
            ? profile['email'] as String?
            : null;
    if (email == null || email.isEmpty) {
      return const AuthSession();
    }
    final String? username =
        profile is Map ? profile['username'] as String? : null;
    final String? name = user is Map ? user['name'] as String? : null;
    return AuthSession(
      userEmail: email,
      displayName: name ?? username,
      username: username,
    );
  }

  @override
  Future<SignInResult> signIn({
    required String identifier,
    required String password,
  }) async {
    final String trimmed = identifier.trim();
    if (!trimmed.contains('@')) {
      AppLogger.warning('Login Laravel gagal: username tidak didukung server');
      return SignInResult.invalidCredentials;
    }
    try {
      _currentData = await _datasource.login(
        email: trimmed,
        password: password,
      );
      _sessions.add(_sessionOf(_currentData));
      return SignInResult.success;
    } on DioException catch (error) {
      AppLogger.error('Sign in Laravel gagal', error);
      if (error.response?.statusCode == 401) {
        return SignInResult.invalidCredentials;
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.connectionError) {
        return SignInResult.networkError;
      }
      return SignInResult.error;
    } catch (error) {
      AppLogger.error('Sign in Laravel gagal', error);
      return SignInResult.error;
    }
  }

  @override
  Future<SignInResult> signInWithGoogle() async {
    AppLogger.warning('Login Google tidak didukung di mode Laravel');
    return SignInResult.error;
  }

  @override
  Future<SignUpResult> signUp({
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final String name =
          displayName.trim().isEmpty ? username.trim() : displayName.trim();
      _currentData = await _datasource.register(
        name: name,
        email: email.trim(),
        password: password,
      );
      _sessions.add(_sessionOf(_currentData));
      return SignUpResult.success;
    } on DioException catch (error) {
      final int? status = error.response?.statusCode;
      if (status == 422) {
        final Object? body = error.response?.data;
        final String text = body is Map
            ? body.toString().toLowerCase()
            : error.toString().toLowerCase();
        if (text.contains('email') && text.contains('taken') ||
            text.contains('unique') ||
            text.contains('already')) {
          return SignUpResult.alreadyRegistered;
        }
        if (text.contains('password')) {
          return SignUpResult.weakPassword;
        }
        if (status == 429) {
          return SignUpResult.rateLimited;
        }
        return SignUpResult.error;
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.connectionError) {
        return SignUpResult.networkError;
      }
      AppLogger.error('Sign up Laravel gagal untuk ${email.trim()}', error);
      return SignUpResult.error;
    } catch (error) {
      AppLogger.error('Sign up Laravel gagal untuk ${email.trim()}', error);
      return SignUpResult.error;
    }
  }

  @override
  Future<void> signOut() async {
    _currentData = null;
    _sessions.add(const AuthSession());
    await _datasource.logout();
  }

  @override
  Future<bool> isUsernameTaken(String username) async {
    return false;
  }

  @override
  AuthSession get currentSession => _sessionOf(_currentData);

  @override
  ({String? email, String? displayName, String? username, String? phone})
      get currentAccount {
    final AuthSession session = currentSession;
    return (
      email: session.userEmail,
      displayName: session.displayName,
      username: session.username,
      phone: null,
    );
  }

  @override
  Future<bool> updateProfile({String? displayName, String? phone}) async {
    return displayName != null || phone != null;
  }

  @override
  Stream<AuthSession> get authStateChanges => _sessions.stream;
}
