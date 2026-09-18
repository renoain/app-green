// Unit test SupabaseAuthRepository: mode demo (simulasi lokal) dan jalur
// login username (resolusi username -> email, non-demo via stub).

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:go_green/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:go_green/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/domain/repositories/auth_repository.dart';

/// Stub datasource agar jalur non-demo bisa diuji tanpa jaringan.
class _StubAuthDatasource extends AuthRemoteDatasource {
  _StubAuthDatasource({
    this.emailByUsername,
    this.throwOnLookup = false,
    this.signInError,
    this.usernameTaken = false,
  });

  /// Email yang dikembalikan RPC untuk username apa pun (null = tak ada).
  final String? emailByUsername;

  /// Bila true, findEmailByUsername melempar error (simulasi RPC gagal).
  final bool throwOnLookup;

  /// Error yang dilempar signInWithEmail (null = sukses).
  final Object? signInError;

  /// Hasil isUsernameTaken.
  final bool usernameTaken;

  /// Username yang diteruskan ke RPC (sudah dinormalisasi repository).
  String? lastLookupUsername;

  /// Email yang diteruskan ke signInWithEmail.
  String? lastSignInEmail;

  /// Apakah signInWithEmail dipanggil.
  bool signInWithEmailCalled = false;

  /// Apakah signUpWithEmail dipanggil.
  bool signUpWithEmailCalled = false;

  @override
  Future<String?> findEmailByUsername(String username) async {
    lastLookupUsername = username;
    if (throwOnLookup) {
      throw Exception('rpc failed');
    }
    return emailByUsername;
  }

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    signInWithEmailCalled = true;
    lastSignInEmail = email;
    if (signInError != null) {
      throw signInError!;
    }
    return AuthResponse();
  }

  @override
  Future<bool> isUsernameTaken(String username) async => usernameTaken;

  @override
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? username,
    String? displayName,
  }) async {
    signUpWithEmailCalled = true;
    return AuthResponse();
  }

  @override
  User? getCurrentUser() => null;

  @override
  Stream<AuthState> get authStateChanges => const Stream<AuthState>.empty();
}

void main() {
  final SupabaseAuthRepository repository = SupabaseAuthRepository();

  group('SupabaseAuthRepository (mode demo)', () {
    test('currentSession berstatus belum login', () {
      expect(repository.currentSession.isLoggedIn, isFalse);
    });

    test('authStateChanges memancarkan sesi belum login', () async {
      final AuthSession session = await repository.authStateChanges.first;
      expect(session.isLoggedIn, isFalse);
    });

    test('signIn mengembalikan success', () async {
      final SignInResult result = await repository.signIn(
        identifier: 'budi@mail.com',
        password: 'rahasia123',
      );
      expect(result, SignInResult.success);
    });

    test('signUp mengembalikan success', () async {
      final SignUpResult result = await repository.signUp(
        username: 'budi_hijau',
        displayName: 'Budi',
        email: 'budi@mail.com',
        password: 'rahasia123',
      );
      expect(result, SignUpResult.success);
    });

    test('signOut tidak melempar error', () async {
      await expectLater(repository.signOut(), completes);
    });
  });

  group('SupabaseAuthRepository (login username)', () {
    SupabaseAuthRepository repository(_StubAuthDatasource stub) {
      return SupabaseAuthRepository(
        datasource: stub,
        isDemoOverride: false,
      );
    }

    test('username dinormalisasi, resolve ke email, login sukses', () async {
      final _StubAuthDatasource stub =
          _StubAuthDatasource(emailByUsername: 'budi@mail.com');
      final SignInResult result = await repository(stub).signIn(
        identifier: 'Budi_Hijau',
        password: 'rahasia123',
      );
      expect(result, SignInResult.success);
      expect(stub.lastLookupUsername, 'budi_hijau');
      expect(stub.lastSignInEmail, 'budi@mail.com');
    });

    test('username tidak ditemukan -> invalidCredentials tanpa login', () async {
      final _StubAuthDatasource stub =
          _StubAuthDatasource(emailByUsername: null);
      final SignInResult result = await repository(stub).signIn(
        identifier: 'tidak_ada',
        password: 'rahasia123',
      );
      expect(result, SignInResult.invalidCredentials);
      expect(stub.signInWithEmailCalled, isFalse);
    });

    test('RPC gagal -> error', () async {
      final _StubAuthDatasource stub =
          _StubAuthDatasource(throwOnLookup: true);
      final SignInResult result = await repository(stub).signIn(
        identifier: 'budi_hijau',
        password: 'rahasia123',
      );
      expect(result, SignInResult.error);
      expect(stub.signInWithEmailCalled, isFalse);
    });

    test('identifier email melewati RPC langsung ke signIn', () async {
      final _StubAuthDatasource stub =
          _StubAuthDatasource(emailByUsername: 'lain@mail.com');
      final SignInResult result = await repository(stub).signIn(
        identifier: 'budi@mail.com',
        password: 'rahasia123',
      );
      expect(result, SignInResult.success);
      expect(stub.lastLookupUsername, isNull);
      expect(stub.lastSignInEmail, 'budi@mail.com');
    });

    test('password salah setelah resolve -> invalidCredentials', () async {
      final _StubAuthDatasource stub = _StubAuthDatasource(
        emailByUsername: 'budi@mail.com',
        signInError: const AuthException(
          'Invalid login credentials',
          code: 'invalid_credentials',
        ),
      );
      final SignInResult result = await repository(stub).signIn(
        identifier: 'budi_hijau',
        password: 'salah123',
      );
      expect(result, SignInResult.invalidCredentials);
      expect(stub.lastSignInEmail, 'budi@mail.com');
    });

    test('signUp menolak username dipakai tanpa insert', () async {
      final _StubAuthDatasource stub =
          _StubAuthDatasource(usernameTaken: true);
      final SignUpResult result = await repository(stub).signUp(
        username: 'budi_hijau',
        displayName: 'Budi',
        email: 'budi@mail.com',
        password: 'rahasia123',
      );
      expect(result, SignUpResult.usernameTaken);
      expect(stub.signUpWithEmailCalled, isFalse);
    });
  });
}