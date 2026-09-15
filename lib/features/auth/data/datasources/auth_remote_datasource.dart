// Data source autentikasi berbasis Supabase Auth.
//
// Membungkus operasi auth (email/password, Google, logout, profil) dengan
// klien Supabase. Dipanggil oleh repository, bukan dari widget.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../profile/data/models/profile_model.dart';

/// Data source autentikasi Go Green.
class AuthRemoteDatasource {
  /// Membuat data source auth. [client] bisa di-inject untuk test.
  ///
  /// Klien di-resolve secara lazy sehingga membuat instance data source
  /// aman dilakukan meski Supabase belum diinisialisasi (mode demo).
  AuthRemoteDatasource({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _resolvedClient =>
      _client ?? SupabaseService.instance.client;

  /// Login dengan email/password.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _resolvedClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Mendaftar akun baru. [username] masuk ke metadata dan dipakai trigger
  /// `handle_new_user` saat membuat baris profiles.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? username,
  }) {
    return _resolvedClient.auth.signUp(
      email: email,
      password: password,
      data: <String, dynamic>{'username': username},
    );
  }

  /// Login dengan akun Google (OAuth).
  ///
  /// Mengembalikan true saat halaman OAuth berhasil dibuka (hasil login
  /// tetap dipantau lewat [authStateChanges]).
  Future<bool> signInWithGoogle() {
    return _resolvedClient.auth.signInWithOAuth(OAuthProvider.google);
  }

  /// Keluar dari sesi.
  Future<void> signOut() {
    return _resolvedClient.auth.signOut();
  }

  /// User yang sedang login, atau null bila belum login.
  User? getCurrentUser() {
    return _resolvedClient.auth.currentUser;
  }

  /// Aliran perubahan status autentikasi dari Supabase.
  Stream<AuthState> get authStateChanges {
    return _resolvedClient.auth.onAuthStateChange;
  }

  /// Mengambil profil user dari tabel profiles.
  Future<ProfileModel?> getProfile(String userId) async {
    final Map<String, dynamic>? row = await _resolvedClient
        .from(AppTables.profiles)
        .select()
        .eq('id', userId)
        .maybeSingle();
    return row == null ? null : ProfileModel.fromJson(row);
  }
}