// Model WasteLog (data layer).
//
// extends WasteLog untuk dipakai domain; fromJson/toJson menyesuaikan
// format kolom tabel waste_logs (snake_case).

import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/waste_log.dart';

/// Model data [WasteLog] untuk komunikasi dengan Supabase.
class WasteLogModel extends WasteLog {
  /// Membuat model dari field entity.
  const WasteLogModel({
    required super.id,
    required super.userId,
    super.checkpointId,
    required super.category,
    super.photoUrl,
    super.hash,
    super.latitude,
    super.longitude,
    required super.serverTimestamp,
    required super.status,
    super.verifiedBy,
    super.verifiedAt,
    super.notes,
    super.source,
    required super.createdAt,
    super.submitterName,
    super.checkpointName,
  });

  /// Membangun model dari respons JSON Supabase.
  factory WasteLogModel.fromJson(Map<String, dynamic> json) {
    final Object? profile = json['profiles'];
    final Object? checkpoint = json['checkpoints'];
    return WasteLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      checkpointId: json['checkpoint_id'] as String?,
      category: WasteCategory.fromDb(json['category'] as String?),
      photoUrl: json['photo_url'] as String?,
      hash: json['hash'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      serverTimestamp: _parseDateTime(json['server_timestamp']),
      status: WasteLogStatus.fromDb(json['status'] as String?),
      verifiedBy: json['verified_by'] as String?,
      verifiedAt: _parseDateTimeOrNull(json['verified_at']),
      notes: json['notes'] as String?,
      source: WasteSource.fromDb(json['source'] as String?),
      createdAt: _parseDateTime(json['created_at']),
      submitterName: profile is Map<String, dynamic>
          ? profile['username'] as String?
          : null,
      checkpointName: checkpoint is Map<String, dynamic>
          ? checkpoint['name'] as String?
          : null,
    );
  }

  /// Representasi JSON untuk operasi insert/update.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'checkpoint_id': checkpointId,
      'category': category.value,
      'photo_url': photoUrl,
      'hash': hash,
      'latitude': latitude,
      'longitude': longitude,
      'server_timestamp': serverTimestamp.toIso8601String(),
      'status': status.value,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'notes': notes,
      'source': source.value,
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

  static DateTime? _parseDateTimeOrNull(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}