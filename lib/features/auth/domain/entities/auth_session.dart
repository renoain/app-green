// Entity AuthSession (domain).

/// Sesi autentikasi user.
class AuthSession {
  /// [userEmail] null berarti user belum login. [displayName] dan [username] dari metadata auth untuk tampilan (null bila belum login).
  const AuthSession({this.userEmail, this.displayName, this.username});

  /// Email user yang sedang login (null bila belum login).
  final String? userEmail;

  /// Nama tampilan user (null bila belum login atau belum diisi).
  final String? displayName;

  /// Username unik user (lowercase, null bila belum login).
  final String? username;

  /// Apakah user sudah login.
  bool get isLoggedIn => userEmail != null;
}
