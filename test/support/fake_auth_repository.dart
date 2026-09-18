// Fake AuthRepository untuk test widget (mode status sesi terkontrol).
// Tidak menyentuh jaringan maupun Supabase.

import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/domain/repositories/auth_repository.dart';

/// Implementasi tiruan [AuthRepository] dengan sesi tetap.
class FakeAuthRepository implements AuthRepository {
  /// Membuat fake dengan [session] yang sudah ditentukan.
  FakeAuthRepository({
    AuthSession session = const AuthSession(),
    Set<String> takenUsernames = const <String>{},
  })  : _session = session,
        _takenUsernames = takenUsernames;

  final AuthSession _session;
  final Set<String> _takenUsernames;

  @override
  AuthSession get currentSession => _session;

  @override
  Stream<AuthSession> get authStateChanges => Stream<AuthSession>.value(_session);

  @override
  Future<SignInResult> signIn({
    required String identifier,
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
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) async {
    if (_takenUsernames.contains(username.trim().toLowerCase())) {
      return SignUpResult.usernameTaken;
    }
    return SignUpResult.success;
  }

  @override
  Future<bool> isUsernameTaken(String username) async {
    return _takenUsernames.contains(username.trim().toLowerCase());
  }

  @override
  ({String? email, String? displayName, String? username, String? phone})
  get currentAccount {
    return (
      email: _session.userEmail,
      displayName: _session.displayName,
      username: _session.username,
      phone: null,
    );
  }

  @override
  Future<bool> updateProfile({String? displayName, String? phone}) async {
    return true;
  }

  @override
  Future<void> signOut() async {}
}
