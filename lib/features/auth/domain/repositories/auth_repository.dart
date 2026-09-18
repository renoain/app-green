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

  /// Username sudah dipakai user lain (harus beda, unik).
  usernameTaken,

  /// Registrasi berhasil tetapi butuh konfirmasi email.
  needsConfirmation,

  /// Kata sandi terlalu lemah.
  weakPassword,

  /// Terlalu banyak percobaan, dibatasi sementara oleh server.
  rateLimited,

  /// Gagal karena masalah jaringan.
  networkError,

  /// Gagal karena sebab lain.
  error,
}

/// Kontrak repository autentikasi Go Green.
abstract interface class AuthRepository {
  /// Login email/password atau username/password.
  ///
  /// [identifier] berisi email atau username; implementasi menyelesaikan
  /// username menjadi email lewat RPC sebelum login.
  Future<SignInResult> signIn({
    required String identifier,
    required String password,
  });

  /// Login sekali klik dengan akun Google (OAuth), tanpa isi email manual.
  Future<SignInResult> signInWithGoogle();

  /// Registrasi akun baru.
  ///
  /// [username] dipakai untuk login dan baris profiles (unik, lowercase);
  /// [displayName] disimpan di metadata auth untuk tampilan.
  Future<SignUpResult> signUp({
    required String username,
    required String displayName,
    required String email,
    required String password,
  });

  /// Keluar dari sesi.
  Future<void> signOut();

  /// Mengecek apakah [username] sudah dipakai user lain.
  ///
  /// Normalisasi lowercase + trim sebelum cek agar konsisten dengan
  /// constraint unik di profiles. Mengembalikan true bila sudah dipakai.
  Future<bool> isUsernameTaken(String username);

  /// Sesi saat ini (belum login bila null email).
  AuthSession get currentSession;

  /// Atribut akun saat ini (email, nama tampilan, username, telepon).
  ///
  /// Nilai null bila belum login atau Supabase belum terinisialisasi.
  ({String? email, String? displayName, String? username, String? phone})
  get currentAccount;

  /// Memperbarui nama tampilan dan/atau telepon di metadata auth.
  ///
  /// Mengembalikan true bila tersimpan.
  Future<bool> updateProfile({String? displayName, String? phone});

  /// Aliran perubahan sesi login.
  Stream<AuthSession> get authStateChanges;
}