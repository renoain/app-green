// Entity user untuk daftar admin (domain).
//
// Ringkasan profil tanpa data sensitif berlebih; hanya yang tampil
// di daftar kelola user.

import '../../../../core/constants/app_enums.dart';

/// Ringkasan user untuk daftar admin.
class AdminUser {
  /// Membuat ringkasan user admin.
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
