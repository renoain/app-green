// Model Checkpoint (data layer).
//
// extends Checkpoint untuk dipakai domain; fromJson/toJson menyesuaikan
// format kolom tabel checkpoints (snake_case).

import '../../domain/entities/checkpoint.dart';

/// Model data [Checkpoint] untuk komunikasi dengan Supabase.
class CheckpointModel extends Checkpoint {
  /// Membuat model dari field entity.
  const CheckpointModel({
    required super.id,
    required super.name,
    super.address,
    required super.latitude,
    required super.longitude,
    required super.radius,
    super.qrCode,
    required super.createdAt,
  });

  /// Membangun model dari respons JSON Supabase.
  factory CheckpointModel.fromJson(Map<String, dynamic> json) {
    return CheckpointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: json['radius'] as int? ?? 100,
      qrCode: json['qr_code'] as String?,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Representasi JSON untuk operasi insert/update.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'qr_code': qrCode,
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