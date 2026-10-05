// Model Redemption (data layer).

import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/redemption.dart';

/// Model data [Redemption] untuk komunikasi dengan Supabase.
class RedemptionModel extends Redemption {
  const RedemptionModel({
    required super.id,
    super.rewardId,
    super.rewardName,
    required super.status,
    super.voucherCode,
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
      voucherCode: json['voucher_code'] as String?,
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
