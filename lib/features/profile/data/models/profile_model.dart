// Model Profile (data layer).
//
// extends Profile untuk dipakai domain; fromJson/toJson menyesuaikan
// format kolom tabel profiles (snake_case).

import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/profile.dart';

/// Model data [Profile] untuk komunikasi dengan Supabase.
class ProfileModel extends Profile {
  /// Membuat model dari field entity.
  const ProfileModel({
    required super.id,
    required super.email,
    super.username,
    required super.role,
    required super.createdAt,
  });

  /// Membangun model dari respons JSON Supabase.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String?,
      role: UserRole.fromDb(json['role'] as String?),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Representasi JSON untuk operasi insert/update.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'role': role.value,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}