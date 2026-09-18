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
  /// `handle_new_user` saat membuat baris profiles; [displayName] tersimpan
  /// di metadata untuk tampilan (tidak ada kolom baru di profiles).
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? username,
    String? displayName,
  }) {
    final Map<String, dynamic>? data = (username == null && displayName == null)
        ? null
        : <String, dynamic>{
            if (username != null) 'username': username,
            if (displayName != null) 'display_name': displayName,
          };
    return _resolvedClient.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// Mencari email auth dari username lewat RPC `get_email_by_username`.
  ///
  /// Mengembalikan null bila username tidak ditemukan. Dipakai untuk
  /// login username karena Supabase Auth hanya menerima email.
  Future<String?> findEmailByUsername(String username) async {
    final dynamic result = await _resolvedClient.rpc(
      'get_email_by_username',
      params: <String, dynamic>{'p_username': username},
    );
    if (result == null) {
      return null;
    }
    final String email = result.toString();
    return email.isEmpty ? null : email;
  }

  /// Mengecek apakah username sudah dipakai (case-insensitive).
  ///
  /// Dipakai sebelum registrasi agar pesan "username sudah dipakai" bisa
  /// tampil jelas. Penegak akhir tetap constraint unik di database.
  Future<bool> isUsernameTaken(String username) async {
    final String normalized = username.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    final List<dynamic> rows = await _resolvedClient
        .from(AppTables.profiles)
        .select('id')
        .ilike('username', normalized)
        .limit(1);
    return rows.isNotEmpty;
  }

  /// Memperbarui metadata user saat ini (nama tampilan, telepon).
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) {
    return _resolvedClient.auth.updateUser(UserAttributes(data: data));
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