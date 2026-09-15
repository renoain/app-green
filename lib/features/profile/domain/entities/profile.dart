// Entity Profile (domain).
//
// Representasi bisnis profil user tanpa ketergantungan ke data layer.
// Field mengikuti kolom tabel profiles (docs/DATABASE_SCHEMA.md).

import '../../../../core/constants/app_enums.dart';

/// Profil dan role user.
class Profile {
  /// Membuat profil user.
  const Profile({
    required this.id,
    required this.email,
    this.username,
    required this.role,
    required this.createdAt,
  });

  /// ID profil, sama dengan auth.users.id.
  final String id;

  /// Email user (dari auth.users.email).
  final String email;

  /// Username unik.
  final String? username;

  /// Role user.
  final UserRole role;

  /// Waktu profil dibuat.
  final DateTime createdAt;
}