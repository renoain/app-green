// Fake AuthRepository untuk test widget (mode status sesi terkontrol).
// Tidak menyentuh jaringan maupun Supabase.

import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/domain/repositories/auth_repository.dart';

/// Implementasi tiruan [AuthRepository] dengan sesi tetap.
class FakeAuthRepository implements AuthRepository {
  /// Membuat fake dengan [session] yang sudah ditentukan.
  FakeAuthRepository({AuthSession session = const AuthSession()})
      : _session = session;

  final AuthSession _session;

  @override
  AuthSession get currentSession => _session;

  @override
  Stream<AuthSession> get authStateChanges => Stream<AuthSession>.value(_session);

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    return SignInResult.success;
  }

  @override
  Future<SignInResult> signInWithGoogle() async {
    return SignInResult.success;
  }

  @override
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return SignUpResult.success;
  }

  @override
  Future<void> signOut() async {}
}
