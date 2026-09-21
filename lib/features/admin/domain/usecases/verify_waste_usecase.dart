// Use case verifikasi waste oleh admin/petugas (domain).

import 'dart:math' as math;

import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../checkpoints/domain/repositories/checkpoint_repository.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../../../waste/domain/repositories/waste_repository.dart';
import '../../../waste/domain/usecases/calculate_points_usecase.dart';

/// Use case approve/reject waste log untuk admin dan petugas.
class VerifyWasteUsecase {
  /// Membuat use case.
  const VerifyWasteUsecase({
    required WasteRepository wasteRepository,
    required CheckpointRepository checkpointRepository,
    CalculatePointsUsecase calculatePoints = const CalculatePointsUsecase(),
  })  : _wasteRepository = wasteRepository,
        _checkpointRepository = checkpointRepository,
        _calculatePoints = calculatePoints;

  final WasteRepository _wasteRepository;
  final CheckpointRepository _checkpointRepository;
  final CalculatePointsUsecase _calculatePoints;

  /// Menyetujui log. Poin earn sudah tercatat saat submit, jadi approve
  /// hanya mengubah status tanpa insert poin ulang.
  Future<WasteLog> approve({
    required String id,
    required String verifiedBy,
  }) {
    return _wasteRepository.approveWasteLog(id: id, verifiedBy: verifiedBy);
  }

  /// Menolak log dengan alasan wajib diisi.
  Future<WasteLog> reject({
    required String id,
    required String verifiedBy,
    required String reason,
  }) {
    return _wasteRepository.rejectWasteLog(
      id: id,
      verifiedBy: verifiedBy,
      reason: reason,
    );
  }

  /// Estimasi poin log untuk ditampilkan di detail (tanpa mencatat ulang).
  int estimatePoints(WasteLog log) {
    return _calculatePoints.calculate(category: log.category);
  }

  /// Jarak meter posisi log ke checkpointnya, null bila data tak lengkap.
  Future<int?> distanceToCheckpoint(WasteLog log) async {
    final String? checkpointId = log.checkpointId;
    final double? latitude = log.latitude;
    final double? longitude = log.longitude;
    if (checkpointId == null || latitude == null || longitude == null) {
      return null;
    }
    final Checkpoint? checkpoint =
        await _checkpointRepository.getCheckpointById(checkpointId);
    if (checkpoint == null) return null;
    return _haversineMeters(
      latitude,
      longitude,
      checkpoint.latitude,
      checkpoint.longitude,
    );
  }

  static int _haversineMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371000;
    final double dLat = _radians(lat2 - lat1);
    final double dLng = _radians(lng2 - lng1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_radians(lat1)) *
            math.cos(_radians(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return (earthRadius * c).round();
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
