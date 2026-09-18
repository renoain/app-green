// Data yang dikirim dari daftar aktivitas ke halaman detail saat item
// berasal dari waste log Supabase (bukan demo).

import '../../../../core/constants/app_enums.dart';

/// Data ekstra route detail aktivitas untuk log real.
class ActivityDetailExtra {
  const ActivityDetailExtra({
    required this.description,
    required this.date,
    required this.status,
    required this.checkpointName,
    required this.points,
  });

  /// Deskripsi aktivitas (kategori + checkpoint).
  final String description;

  /// Tanggal pembuangan.
  final DateTime date;

  /// Status verifikasi log.
  final WasteLogStatus status;

  /// Nama checkpoint.
  final String checkpointName;

  /// Estimasi poin log.
  final int points;
}
