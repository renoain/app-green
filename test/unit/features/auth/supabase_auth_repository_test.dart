// Unit test SupabaseAuthRepository mode demo: Supabase belum
// diinisialisasi sehingga semua operasi disimulasikan lokal.

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/domain/repositories/auth_repository.dart';

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
        email: 'budi@mail.com',
        password: 'rahasia123',
      );
      expect(result, SignInResult.success);
    });

    test('signUp mengembalikan success', () async {
      final SignUpResult result = await repository.signUp(
        name: 'Budi',
        email: 'budi@mail.com',
        password: 'rahasia123',
      );
      expect(result, SignUpResult.success);
    });

    test('signOut tidak melempar error', () async {
      await expectLater(repository.signOut(), completes);
    });
  });
}