// Entity AuthSession (domain).
//
// Representasi sesi login yang ringan untuk lapisan domain/presentation,
// tanpa ketergantungan ke tipe Supabase.

/// Sesi autentikasi user.
class AuthSession {
  /// Membuat sesi autentikasi.
  ///
  /// [userEmail] null berarti user belum login.
  const AuthSession({this.userEmail});

  /// Email user yang sedang login (null bila belum login).
  final String? userEmail;

  /// Apakah user sudah login.
  bool get isLoggedIn => userEmail != null;
}