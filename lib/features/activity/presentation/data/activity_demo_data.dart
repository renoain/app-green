// Data demo aktivitas Go Green (placeholder sampai layer data terpasang).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/widgets/status_widgets.dart';

/// Data aktivitas pembuangan sampah.
class ActivityDemo {
  const ActivityDemo({
    required this.id,
    required this.description,
    required this.date,
    required this.point,
    required this.status,
    required this.checkpoint,
    required this.icon,
  });

  /// Identitas aktivitas.
  final String id;

  /// Deskripsi aktivitas.
  final String description;

  /// Tanggal aktivitas.
  final DateTime date;

  /// Poin yang didapat atau dipakai.
  final int point;

  /// Status verifikasi.
  final StatusType status;

  /// Checkpoint tempat membuang sampah.
  final String checkpoint;

  /// Ikon representasi aktivitas.
  final IconData icon;
}

/// Daftar aktivitas demo (non-const karena [date] memakai [DateTime]).
final List<ActivityDemo> demoActivities = <ActivityDemo>[
  ActivityDemo(
    id: '1',
    description: 'Buang sampah organik di TPS Kelurahan',
    date: DateTime(2026, 9, 12, 14, 32),
    point: 25,
    status: StatusType.success,
    checkpoint: 'TPS Kelurahan',
    icon: LucideIcons.recycle,
  ),
  ActivityDemo(
    id: '2',
    description: 'Buang sampah untuk daur ulang di Bank Sampah',
    date: DateTime(2026, 9, 10, 9, 15),
    point: 40,
    status: StatusType.warning,
    checkpoint: 'Bank Sampah Berseri',
    icon: LucideIcons.trash,
  ),
];