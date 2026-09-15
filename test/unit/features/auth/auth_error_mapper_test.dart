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