// Model Redemption (data layer).
//
// extends Redemption untuk dipakai domain; fromJson menyesuaikan
// format kolom tabel redemptions plus join rewards(name).

import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/redemption.dart';

/// Model data [Redemption] untuk komunikasi dengan Supabase.
class RedemptionModel extends Redemption {
  /// Membuat model dari field entity.
  const RedemptionModel({
    required super.id,
    super.rewardId,
    super.rewardName,
    required super.status,
    required super.createdAt,
  });

  /// Membangun model dari respons JSON Supabase.
  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    final dynamic rewards = json['rewards'];
    return RedemptionModel(
      id: json['id'] as String,
      rewardId: json['reward_id'] as String?,
      rewardName:
          rewards is Map<String, dynamic> ? rewards['name'] as String? : null,
      status: RedemptionStatus.fromDb(json['status'] as String?),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
