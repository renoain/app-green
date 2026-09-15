// Implementasi repository autentikasi berbasis Supabase (data layer).
//
// Menerjemahkan operasi Supabase Auth menjadi enum hasil yang aman untuk
// UI. Dalam mode demo (Supabase belum terinisialisasi, misal saat test
// widget) operasi disimulasikan agar UI tetap bisa berjalan.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/auth_error_mapper.dart';

/// Repository autentikasi Go Green berbasis Supabase.
class SupabaseAuthRepository implements AuthRepository {
  /// Membuat repository. [datasource] bisa di-inject untuk test.
  SupabaseAuthRepository({AuthRemoteDatasource? datasource})
      : _datasource = datasource ?? AuthRemoteDatasource();

  final AuthRemoteDatasource _datasource;

  bool get _isDemo => !SupabaseService.instance.isInitialized;

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    if (_isDemo) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return SignInResult.success;
    }
    try {
      await _datasource.signInWithEmail(email: email.trim(), password: password);
      return SignInResult.success;
    } catch (error) {
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
      if (AuthErrorMapper.mapSignInError(error) == SignInResult.networkError) {
        return SignInResult.networkError;
      }
      return SignInResult.error;
    }
  }

  @override
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_isDemo) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return SignUpResult.success;
    }
    try {
      final AuthResponse response = await _datasource.signUpWithEmail(
        email: email.trim(),
        password: password,
        username: name.trim(),
      );
      final User? user = response.user;
      if (user == null || response.session == null) {
        // User baru perlu konfirmasi email, atau email sudah terdaftar
        // (sesi baru tidak dibuat); keduanya diarahkan ke proses konfirmasi.
        return SignUpResult.needsConfirmation;
      }
      return SignUpResult.success;
    } catch (error) {
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
  AuthSession get currentSession {
    if (_isDemo) {
      return const AuthSession();
    }
    final User? user = _datasource.getCurrentUser();
    return AuthSession(userEmail: user?.email);
  }

  @override
  Stream<AuthSession> get authStateChanges {
    if (_isDemo) {
      return Stream<AuthSession>.value(const AuthSession());
    }
    return _datasource.authStateChanges.map(
      (AuthState state) => AuthSession(userEmail: state.session?.user.email),
    );
  }
}