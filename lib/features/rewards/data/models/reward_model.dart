// Model Reward (data layer).
//
// extends Reward untuk dipakai domain; fromJson/toJson menyesuaikan
// format kolom tabel rewards (snake_case).

import '../../domain/entities/reward.dart';

/// Model data [Reward] untuk komunikasi dengan Supabase.
class RewardModel extends Reward {
  /// Membuat model dari field entity.
  const RewardModel({
    required super.id,
    required super.name,
    super.description,
    required super.pointsCost,
    required super.stock,
    super.imageUrl,
    required super.isActive,
    required super.createdAt,
  });

  /// Membangun model dari respons JSON Supabase.
  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      pointsCost: json['points_cost'] as int,
      stock: json['stock'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Representasi JSON untuk operasi insert/update.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'points_cost': pointsCost,
      'stock': stock,
      'image_url': imageUrl,
      'is_active': isActive,
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