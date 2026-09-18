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

  /// Kode error Supabase untuk kata sandi lemah/bocor.
  static const String _weakPasswordCode = 'weak_password';

  /// Kode error Supabase untuk pembatasan laju permintaan.
  static const Set<String> _rateLimitCodes = <String>{
    'over_request_rate_limit',
    'over_email_send_rate_limit',
    'over_sms_send_rate_limit',
  };

  /// Kode error Supabase untuk email yang sudah terdaftar.
  static const Set<String> _alreadyRegisteredCodes = <String>{
    'user_already_exists',
    'email_exists',
    'identity_already_exists',
  };

  /// Memetakan error login.
  static SignInResult mapSignInError(Object error) {
    if (error is AuthException) {
      final String code = error.code?.toLowerCase() ?? '';
      final String message = error.message.toLowerCase();
      if (code == _invalidCredentialsCode ||
          message.contains('invalid login credentials') ||
          message.contains(_invalidCredentialsCode)) {
        return SignInResult.invalidCredentials;
      }
      if (code == _emailNotConfirmedCode ||
          message.contains('email not confirmed') ||
          message.contains(_emailNotConfirmedCode)) {
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
    if (error is AuthWeakPasswordException) {
      return SignUpResult.weakPassword;
    }
    if (error is AuthException) {
      final String code = error.code?.toLowerCase() ?? '';
      final String message = error.message.toLowerCase();
      if (_isUsernameTakenError(code, message)) {
        return SignUpResult.usernameTaken;
      }
      if (_alreadyRegisteredCodes.contains(code) ||
          message.contains('already registered') ||
          message.contains('already been registered') ||
          message.contains('already exists') ||
          message.contains('email already')) {
        return SignUpResult.alreadyRegistered;
      }
      if (code == _weakPasswordCode ||
          message.contains('weak password') ||
          message.contains('weak_password') ||
          message.contains('password should be') ||
          message.contains('password is too') ||
          message.contains('password must') ||
          message.contains('leaked') ||
          message.contains('compromised') ||
          message.contains('breached')) {
        return SignUpResult.weakPassword;
      }
      if (_rateLimitCodes.contains(code) ||
          message.contains('rate limit') ||
          message.contains('rate_limit') ||
          message.contains('too many')) {
        return SignUpResult.rateLimited;
      }
    }
    final String message = error.toString().toLowerCase();
    if (_isUsernameTakenError('', message)) {
      return SignUpResult.usernameTaken;
    }
    if (_isNetworkError(error)) {
      return SignUpResult.networkError;
    }
    return SignUpResult.error;
  }

  /// Deteksi error username duplikat (constraint profiles_username_key atau
  /// pesan unik/duplikat yang menyebut username).
  static bool _isUsernameTakenError(String code, String message) {
    if (message.contains('profiles_username_key')) {
      return true;
    }
    if (code == '23505' && message.contains('username')) {
      return true;
    }
    final bool mentionsUsername = message.contains('username');
    final bool mentionsTaken = message.contains('already exists') ||
        message.contains('already taken') ||
        message.contains('duplicate') ||
        message.contains('unique') ||
        message.contains('sudah dipakai') ||
        message.contains('sudah digunakan');
    return mentionsUsername && mentionsTaken;
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