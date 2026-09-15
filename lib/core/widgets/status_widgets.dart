// Komponen status sesuai docs/COMPONENT_LIBRARY.md (Status).
// Dikelompokkan dalam satu file: StatusType, StatusChip.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Tipe status untuk chip.
enum StatusType { success, warning, error, info }

/// Chip label status berwarna sesuai tipe (Aktivitas, Reward, Verifikasi).
class StatusChip extends StatelessWidget {
  /// Membuat chip status.
  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusType.success,
  });

  /// Teks status.
  final String label;

  /// Tipe status yang menentukan warna.
  final StatusType type;

  Color get _background {
    switch (type) {
      case StatusType.success:
        return AppColors.secondaryContainer;
      case StatusType.warning:
      case StatusType.info:
        return AppColors.tertiaryLight;
      case StatusType.error:
        return AppColors.surfaceDim;
    }
  }

  Color get _foreground {
    switch (type) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.warning:
        return AppColors.warning;
      case StatusType.error:
        return AppColors.error;
      case StatusType.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: _foreground),
      ),
    );
  }
}