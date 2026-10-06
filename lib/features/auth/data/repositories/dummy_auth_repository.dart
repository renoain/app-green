// Implementasi repository autentikasi dummy berbasis json-server (data layer).

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_dummy_datasource.dart';
import '../mappers/auth_error_mapper.dart';

/// Repository auth mode dummy. Sesi dipegang di memori (hilang saat restart);
/// register/login baca/tulis tabel profiles di json-server.
class DummyAuthRepository implements AuthRepository {
  DummyAuthRepository({AuthDummyDatasource? datasource})
      : _datasource = datasource ?? AuthDummyDatasource();

  final AuthDummyDatasource _datasource;
  final StreamController<AuthSession> _sessions =
      StreamController<AuthSession>.broadcast();

  Map<String, dynamic>? _currentRow;

  AuthSession _sessionOf(Map<String, dynamic>? row) {
    if (row == null) {
      return const AuthSession();
    }
    final String? email = row['email'] as String?;
    if (email == null || email.isEmpty) {
      return const AuthSession();
    }
    final String? username = row['username'] as String?;
    return AuthSession(
      userEmail: email,
      displayName: username,
      username: username,
    );
  }

  @override
  Future<SignInResult> signIn({
    required String identifier,
    required String password,
  }) async {
    try {
      final String trimmed = identifier.trim();
      String loginEmail = trimmed;
      if (!trimmed.contains('@')) {
        final String? resolved = await _datasource.findEmailByUsername(
          trimmed.toLowerCase(),
        );
        if (resolved == null || resolved.isEmpty) {
          AppLogger.warning('Login dummy gagal: username tidak ditemukan');
          return SignInResult.invalidCredentials;
        }
        loginEmail = resolved;
      }
      _currentRow = await _datasource.signIn(
        email: loginEmail,
        password: password,
      );
      _sessions.add(_sessionOf(_currentRow));
      return SignInResult.success;
    } catch (error) {
      AppLogger.error('Sign in dummy gagal', error);
      return AuthErrorMapper.mapSignInError(error);
    }
  }

  @override
  Future<SignInResult> signInWithGoogle() async {
    AppLogger.warning('Login Google tidak didukung di mode dummy');
    return SignInResult.error;
  }

  @override
  Future<SignUpResult> signUp({
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) async {
    final String normalizedUsername = username.trim().toLowerCase();
    try {
      if (await _datasource.isUsernameTaken(normalizedUsername)) {
        AppLogger.warning('Registrasi dummy gagal: username sudah dipakai');
        return SignUpResult.usernameTaken;
      }
      _currentRow = await _datasource.signUp(
        email: email.trim(),
        password: password,
        username: normalizedUsername,
        displayName: displayName.trim(),
      );
      _sessions.add(_sessionOf(_currentRow));
      return SignUpResult.success;
    } on AuthException catch (error) {
      final String code = error.code?.toLowerCase() ?? '';
      if (code == 'username_taken') {
        return SignUpResult.usernameTaken;
      }
      AppLogger.error('Sign up dummy gagal untuk ${email.trim()}', error);
      return AuthErrorMapper.mapSignUpError(error);
    } catch (error) {
      AppLogger.error('Sign up dummy gagal untuk ${email.trim()}', error);
      return AuthErrorMapper.mapSignUpError(error);
    }
  }

  @override
  Future<void> signOut() async {
    _currentRow = null;
    _sessions.add(const AuthSession());
    await _datasource.signOut();
  }

  @override
  Future<bool> isUsernameTaken(String username) async {
    try {
      return await _datasource.isUsernameTaken(username);
    } catch (error) {
      AppLogger.error('Cek username dummy gagal', error);
      return false;
    }
  }

  @override
  AuthSession get currentSession => _sessionOf(_currentRow);

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
    final Map<String, dynamic>? row = _currentRow;
    final Object? id = row?['id'];
    if (row == null || id == null) {
      return false;
    }
    final String? username = displayName?.trim().toLowerCase();
    if (username == null || username.isEmpty) {
      return true;
    }
    try {
      await Dio(
        BaseOptions(baseUrl: AppEnv.dummyApiUrl),
      ).patch(
        '/${AppTables.profiles}/$id',
        data: <String, dynamic>{
          'username': username,
        },
      );
      final Map<String, dynamic> updated = Map<String, dynamic>.from(row)
        ..['username'] = username;
      _currentRow = updated;
      _sessions.add(_sessionOf(updated));
      return true;
    } catch (error) {
      AppLogger.error('Update profil dummy gagal', error);
      return false;
    }
  }

  @override
  Stream<AuthSession> get authStateChanges => _sessions.stream;
}
