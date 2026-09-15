// Pemeta error autentikasi ke hasil enum (data layer).
//
// Dokumen acuan kode error Supabase:
// https://supabase.com/docs/guides/auth/debugging/error-codes

import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

/// Memetakan exception Supabase Auth menjadi [SignInResult]/[SignUpResult].
abstract final class AuthErrorMapper {
  /// Kode error Supabase untuk email/password salah.
  static const String _invalidCredentialsCode = 'invalid_credentials';

  /// Kode error Supabase untuk email belum dikonfirmasi.
  static const String _emailNotConfirmedCode = 'email_not_confirmed';

  /// Memetakan error login.
  static SignInResult mapSignInError(Object error) {
    if (error is AuthException) {
      if (error.code == _invalidCredentialsCode) {
        return SignInResult.invalidCredentials;
      }
      if (error.code == _emailNotConfirmedCode) {
        return SignInResult.notConfirmed;
      }
    }
    if (_isNetworkError(error)) {
      return SignInResult.networkError;
    }
    return SignInResult.error;
  }

  /// Memetakan error registrasi.
  static SignUpResult mapSignUpError(Object error) {
    if (error is AuthException) {
      final String message = error.message.toLowerCase();
      if (message.contains('already registered') ||
          message.contains('already been registered')) {
        return SignUpResult.alreadyRegistered;
      }
      if (message.contains('weak password')) {
        return SignUpResult.weakPassword;
      }
    }
    if (_isNetworkError(error)) {
      return SignUpResult.networkError;
    }
    return SignUpResult.error;
  }

  /// Deteksi umum error jaringan (tidak ada koneksi, timeout, DNS gagal).
  static bool _isNetworkError(Object error) {
    if (error is SocketException) {
      return true;
    }
    if (error is TimeoutException) {
      return true;
    }
    if (error is FormatException) {
      return true;
    }
    final String message = error.toString().toLowerCase();
    return message.contains('failed host lookup') ||
        message.contains('connection refused') ||
        message.contains('connection timed out') ||
        message.contains('network is unreachable');
  }
}