// Unit test AuthErrorMapper: pemetaan error auth ke enum hasil.

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:go_green/features/auth/data/mappers/auth_error_mapper.dart';
import 'package:go_green/features/auth/domain/repositories/auth_repository.dart';

void main() {
  group('AuthErrorMapper.mapSignInError', () {
    test('kredensial salah -> invalidCredentials', () {
      const AuthException error = AuthException(
        'Invalid login credentials',
        code: 'invalid_credentials',
      );
      expect(
        AuthErrorMapper.mapSignInError(error),
        SignInResult.invalidCredentials,
      );
    });

    test('email belum dikonfirmasi -> notConfirmed', () {
      const AuthException error = AuthException(
        'Email not confirmed',
        code: 'email_not_confirmed',
      );
      expect(AuthErrorMapper.mapSignInError(error), SignInResult.notConfirmed);
    });

    test('kredensial salah tanpa kode -> invalidCredentials', () {
      const AuthException error = AuthException('Invalid login credentials');
      expect(
        AuthErrorMapper.mapSignInError(error),
        SignInResult.invalidCredentials,
      );
    });

    test('email belum dikonfirmasi tanpa kode -> notConfirmed', () {
      const AuthException error = AuthException('Email not confirmed');
      expect(AuthErrorMapper.mapSignInError(error), SignInResult.notConfirmed);
    });

    test('AuthException umum -> error', () {
      const AuthException error = AuthException('Something failed');
      expect(AuthErrorMapper.mapSignInError(error), SignInResult.error);
    });

    test('SocketException -> networkError', () {
      const SocketException error = SocketException('Failed host lookup');
      expect(
        AuthErrorMapper.mapSignInError(error),
        SignInResult.networkError,
      );
    });

    test('TimeoutException -> networkError', () {
      expect(
        AuthErrorMapper.mapSignInError(TimeoutException('timeout')),
        SignInResult.networkError,
      );
    });

    test('error umum -> error', () {
      expect(
        AuthErrorMapper.mapSignInError(Exception('something broke')),
        SignInResult.error,
      );
    });
  });

  group('AuthErrorMapper.mapSignUpError', () {
    test('email sudah terdaftar -> alreadyRegistered', () {
      const AuthException error = AuthException('User already registered');
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.alreadyRegistered,
      );
    });

    test('kata sandi lemah -> weakPassword', () {
      const AuthException error = AuthException('Weak password: too short');
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.weakPassword,
      );
    });

    test('AuthWeakPasswordException (mis. password bocor 123456) -> weakPassword',
        () {
      final AuthWeakPasswordException error = AuthWeakPasswordException(
        message: 'Password is too weak or leaked',
        statusCode: '422',
        reasons: const <String>['leaked'],
      );
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.weakPassword,
      );
    });

    test('kode user_already_exists -> alreadyRegistered', () {
      const AuthException error = AuthException(
        'User already exists',
        code: 'user_already_exists',
      );
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.alreadyRegistered,
      );
    });

    test('signup dimatikan -> error umum', () {
      const AuthException error = AuthException(
        'Signups not allowed for this instance',
        code: 'signup_disabled',
      );
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.error,
      );
    });

    test('rate limit email -> rateLimited', () {
      const AuthException error = AuthException(
        'Email rate limit exceeded',
        code: 'over_email_send_rate_limit',
      );
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.rateLimited,
      );
    });

    test('username duplikat constraint -> usernameTaken', () {
      const AuthException error = AuthException(
        'duplicate key value violates unique constraint "profiles_username_key"',
        code: '23505',
      );
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.usernameTaken,
      );
    });

    test('username sudah dipakai -> usernameTaken', () {
      const AuthException error = AuthException(
        'Username already exists',
      );
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.usernameTaken,
      );
    });

    test('jaringan -> networkError', () {
      const SocketException error = SocketException('Connection refused');
      expect(
        AuthErrorMapper.mapSignUpError(error),
        SignUpResult.networkError,
      );
    });

    test('error umum -> error', () {
      expect(
        AuthErrorMapper.mapSignUpError(Exception('something broke')),
        SignUpResult.error,
      );
    });
  });
}