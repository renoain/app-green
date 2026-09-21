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
    super.code,
    super.provinceCode,
    super.cityCode,
    super.districtCode,
    super.subdistrict,
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
      code: json['code'] as String?,
      provinceCode: json['province_code'] as String?,
      cityCode: json['city_code'] as String?,
      districtCode: json['district_code'] as String?,
      subdistrict: json['subdistrict'] as String?,
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
      'code': code,
      'province_code': provinceCode,
      'city_code': cityCode,
      'district_code': districtCode,
      'subdistrict': subdistrict,
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