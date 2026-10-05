// Entity user untuk daftar admin (domain).

import '../../../../core/constants/app_enums.dart';

/// Ringkasan user untuk daftar admin.
class AdminUser {
  const AdminUser({
    required this.id,
    this.username,
    this.email,
    required this.role,
    required this.createdAt,
  });

  /// ID profil (sama dengan auth user id).
  final String id;

  /// Username unik.
  final String? username;

  /// Email user.
  final String? email;

  /// Role user.
  final UserRole role;

  /// Waktu profil dibuat.
  final DateTime createdAt;
}
