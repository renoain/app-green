// Entity Redemption (domain).

import '../../../../core/constants/app_enums.dart';

/// Penukaran reward oleh user.
class Redemption {
  const Redemption({
    required this.id,
    this.rewardId,
    this.rewardName,
    required this.status,
    this.voucherCode,
    required this.createdAt,
  });

  /// ID unik redemption.
  final String id;

  /// ID reward yang ditukar (null bila reward dihapus).
  final String? rewardId;

  /// Nama reward dari join (null bila reward dihapus).
  final String? rewardName;

  /// Status penukaran.
  final RedemptionStatus status;

  /// Kode voucher unik.
  final String? voucherCode;

  /// Waktu penukaran dibuat.
  final DateTime createdAt;
}
