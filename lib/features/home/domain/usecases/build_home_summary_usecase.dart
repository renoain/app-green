// Use case ringkasan Home dari waste log (domain).
//
// Murni Dart agar mudah diuji: hitung total buang, buang minggu ini
// (Senin 00.00 lokal), dan yang terverifikasi dari daftar log.

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_values.dart';
import '../../../waste/domain/entities/waste_log.dart';

/// Ringkasan angka Home dari data asli.
class HomeSummary {
  /// Membuat ringkasan Home.
  const HomeSummary({
    required this.totalDisposals,
    required this.weeklyDisposals,
    required this.verifiedCount,
    required this.missionProgress,
  });

  /// Total kali buang sampah.
  final int totalDisposals;

  /// Kali buang sejak Senin minggu berjalan.
  final int weeklyDisposals;

  /// Log berstatus verified.
  final int verifiedCount;

  /// Progres misi mingguan 0..1 terhadap target.
  final double missionProgress;
}

/// Use case membangun ringkasan Home.
class BuildHomeSummaryUsecase {
  /// Membuat use case (stateless).
  const BuildHomeSummaryUsecase();

  /// Awal minggu berjalan (Senin 00.00 lokal) untuk [now].
  static DateTime weekStart(DateTime now) {
    final DateTime day = DateTime(now.year, now.month, now.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  /// Bangun ringkasan dari [logs]; [now] bisa di-inject untuk test.
  HomeSummary build({required List<WasteLog> logs, DateTime? now}) {
    final DateTime start = weekStart(now ?? DateTime.now());
    int weekly = 0;
    int verified = 0;
    for (final WasteLog log in logs) {
      if (log.status == WasteLogStatus.verified) verified++;
      if (!log.createdAt.isBefore(start)) weekly++;
    }
    final double progress =
        (weekly / AppValues.weeklyMissionTargetDisposals).clamp(0.0, 1.0);
    return HomeSummary(
      totalDisposals: logs.length,
      weeklyDisposals: weekly,
      verifiedCount: verified,
      missionProgress: progress,
    );
  }
}
