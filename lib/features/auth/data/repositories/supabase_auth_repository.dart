// Implementasi repository autentikasi berbasis Supabase (data layer).
//
// Menerjemahkan operasi Supabase Auth menjadi enum hasil yang aman untuk
// UI. Dalam mode demo (Supabase belum terinisialisasi, misal saat test
// widget) operasi disimulasikan agar UI tetap bisa berjalan.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/auth_error_mapper.dart';

/// Repository autentikasi Go Green berbasis Supabase.
class SupabaseAuthRepository implements AuthRepository {
  /// Membuat repository. [datasource] bisa di-inject untuk test.
  /// [isDemoOverride] memaksa mode demo/non-demo (hanya untuk test;
  /// produksi memakai status inisialisasi Supabase).
  SupabaseAuthRepository({AuthRemoteDatasource? datasource, bool? isDemoOverride})
      : _datasource = datasource ?? AuthRemoteDatasource(),
        _isDemoOverride = isDemoOverride;

  final AuthRemoteDatasource _datasource;
  final bool? _isDemoOverride;

  bool get _isDemo =>
      _isDemoOverride ?? !SupabaseService.instance.isInitialized;

  @override
  Future<SignInResult> signIn({
    required String identifier,
    required String password,
  }) async {
    if (_isDemo) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return SignInResult.success;
    }
    try {
      final String trimmed = identifier.trim();
      String loginEmail = trimmed;
      if (!trimmed.contains('@')) {
        final String? resolved =
            await _datasource.findEmailByUsername(trimmed.toLowerCase());
        if (resolved == null || resolved.isEmpty) {
          AppLogger.warning('Login gagal: username tidak ditemukan');
          return SignInResult.invalidCredentials;
        }
        loginEmail = resolved;
      }
      await _datasource.signInWithEmail(email: loginEmail, password: password);
      return SignInResult.success;
    } catch (error) {
      AppLogger.error('Sign in gagal', error);
      return AuthErrorMapper.mapSignInError(error);
    }
  }

  @override
  Future<SignInResult> signInWithGoogle() async {
    if (_isDemo) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return SignInResult.success;
    }
    try {
      final bool oauthStarted = await _datasource.signInWithGoogle();
      return oauthStarted ? SignInResult.success : SignInResult.error;
    } catch (error) {
      AppLogger.error('Sign in Google gagal', error);
      if (AuthErrorMapper.mapSignInError(error) == SignInResult.networkError) {
        return SignInResult.networkError;
      }
      return SignInResult.error;
    }
  }

  @override
  Future<SignUpResult> signUp({
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) async {
    if (_isDemo) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return SignUpResult.success;
    }
    final String normalizedUsername = username.trim().toLowerCase();
    try {
      final bool taken =
          await _datasource.isUsernameTaken(normalizedUsername);
      if (taken) {
        AppLogger.warning('Registrasi gagal: username sudah dipakai');
        return SignUpResult.usernameTaken;
      }
      final AuthResponse response = await _datasource.signUpWithEmail(
        email: email.trim(),
        password: password,
        username: normalizedUsername,
        displayName: displayName.trim(),
      );
      final User? user = response.user;
      AppLogger.debug(
        'Sign up ${email.trim()}: user=${user?.id != null}, '
        'session=${response.session != null}',
      );
      if (user == null || response.session == null) {
        // User baru perlu konfirmasi email, atau email sudah terdaftar
        // (sesi baru tidak dibuat); keduanya diarahkan ke proses konfirmasi.
        return SignUpResult.needsConfirmation;
      }
      return SignUpResult.success;
    } catch (error) {
      AppLogger.error('Sign up gagal untuk ${email.trim()}', error);
      return AuthErrorMapper.mapSignUpError(error);
    }
  }

  @override
  Future<void> signOut() async {
    if (_isDemo) {
      return;
    }
    await _datasource.signOut();
  }

  @override
  Future<bool> isUsernameTaken(String username) async {
    if (_isDemo) {
      return false;
    }
    try {
      return await _datasource.isUsernameTaken(username);
    } catch (error) {
      AppLogger.error('Cek username gagal', error);
      return false;
    }
  }

  @override
  AuthSession get currentSession {
    if (_isDemo) {
      return const AuthSession();
    }
    final User? user = _datasource.getCurrentUser();
    final Map<String, dynamic>? metadata = user?.userMetadata;
    return AuthSession(
      userEmail: user?.email,
      displayName: metadata?['display_name'] as String?,
      username: metadata?['username'] as String?,
    );
  }

  @override
  ({String? email, String? displayName, String? username, String? phone})
  get currentAccount {
    if (_isDemo) {
      return (email: null, displayName: null, username: null, phone: null);
    }
    final User? user = _datasource.getCurrentUser();
    final Map<String, dynamic>? metadata = user?.userMetadata;
    return (
      email: user?.email,
      displayName: metadata?['display_name'] as String?,
      username: metadata?['username'] as String?,
      phone: metadata?['phone'] as String?,
    );
  }

  @override
  Future<bool> updateProfile({String? displayName, String? phone}) async {
    if (_isDemo) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return true;
    }
    final Map<String, dynamic> data = <String, dynamic>{
      if (displayName != null) 'display_name': displayName.trim(),
      if (phone != null) 'phone': phone.trim(),
    };
    if (data.isEmpty) {
      return true;
    }
    try {
      final UserResponse response =
          await _datasource.updateUserMetadata(data);
      return response.user != null;
    } catch (error) {
      AppLogger.error('Update profil gagal', error);
      return false;
    }
  }

  @override
  Stream<AuthSession> get authStateChanges {
    if (_isDemo) {
      return Stream<AuthSession>.value(const AuthSession());
    }
    return _datasource.authStateChanges.map((AuthState state) {
      final Map<String, dynamic>? metadata =
          state.session?.user.userMetadata;
      return AuthSession(
        userEmail: state.session?.user.email,
        displayName: metadata?['display_name'] as String?,
        username: metadata?['username'] as String?,
      );
    });
  }
}