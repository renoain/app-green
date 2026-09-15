// Interface repository autentikasi (domain).
//
// Implementasi data layer (SupabaseAuthRepository) wajib mengikuti kontrak
// ini. Hasil operasi berupa enum hasil agar UI bisa menampilkan pesan
// yang sesuai, bukan exception mentah.

import '../entities/auth_session.dart';

/// Hasil operasi login.
enum SignInResult {
  /// Login berhasil.
  success,

  /// Email atau kata sandi salah.
  invalidCredentials,

  /// Email terdaftar tetapi belum dikonfirmasi.
  notConfirmed,

  /// Gagal karena masalah jaringan.
  networkError,

  /// Gagal karena sebab lain.
  error,
}

/// Hasil operasi registrasi.
enum SignUpResult {
  /// Registrasi berhasil (bisa langsung login).
  success,

  /// Email sudah terdaftar.
  alreadyRegistered,

  /// Registrasi berhasil tetapi butuh konfirmasi email.
  needsConfirmation,

  /// Kata sandi terlalu lemah.
  weakPassword,

  /// Gagal karena masalah jaringan.
  networkError,

  /// Gagal karena sebab lain.
  error,
}

/// Kontrak repository autentikasi Go Green.
abstract interface class AuthRepository {
  /// Login email/password.
  Future<SignInResult> signIn({
    required String email,
    required String password,
  });

  /// Login sekali klik dengan akun Google (OAuth), tanpa isi email manual.
  Future<SignInResult> signInWithGoogle();

  /// Registrasi akun baru.
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Keluar dari sesi.
  Future<void> signOut();

  /// Sesi saat ini (belum login bila null email).
  AuthSession get currentSession;

  /// Aliran perubahan sesi login.
  Stream<AuthSession> get authStateChanges;
}