// Model Point (data layer).
//
// extends Point untuk dipakai domain; fromJson/toJson menyesuaikan format
// kolom tabel points (snake_case).

import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/point.dart';

/// Model data [Point] untuk komunikasi dengan Supabase.
class PointModel extends Point {
  /// Membuat model dari field entity.
  const PointModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.type,
    super.referenceId,
    super.description,
    required super.createdAt,
  });

  /// Membangun model dari respons JSON Supabase.
  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: json['amount'] as int? ?? 0,
      type: PointType.fromDb(json['type'] as String?),
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String?,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Representasi JSON untuk operasi insert/update.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'amount': amount,
      'type': type.value,
      'reference_id': referenceId,
      'description': description,
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