// Kartu item TPS untuk daftar kelola admin (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';

/// Kartu satu TPS: nama, koordinat, radius, QR, aksi ubah/nonaktif.
class TpsCard extends StatelessWidget {
  /// Membuat kartu TPS.
  const TpsCard({
    super.key,
    required this.checkpoint,
    required this.onEdit,
    required this.onDeactivate,
  });

  /// Checkpoint yang ditampilkan.
  final Checkpoint checkpoint;

  /// Aksi ubah.
  final VoidCallback onEdit;

  /// Aksi nonaktifkan.
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  checkpoint.name,
                  style: AppTypography.labelLg,
                ),
              ),
              if (checkpoint.qrCode != null &&
                  checkpoint.qrCode!.isNotEmpty)
                StatusChipText(code: checkpoint.qrCode!),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (checkpoint.code != null && checkpoint.code!.isNotEmpty)
            Text(
              checkpoint.code!,
              style: AppTypography.labelSm,
            ),
          Text(
            '${checkpoint.latitude.toStringAsFixed(5)}, '
            '${checkpoint.longitude.toStringAsFixed(5)} '
            '(r=${checkpoint.radius}m)',
            style: AppTypography.bodySm,
          ),
          if (checkpoint.address != null &&
              checkpoint.address!.isNotEmpty)
            Text(checkpoint.address!, style: AppTypography.bodySm),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(LucideIcons.pencil, size: 16),
                  label: const Text(AppStrings.adminEditTps),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDeactivate,
                  icon: const Icon(
                    LucideIcons.power,
                    size: 16,
                    color: AppColors.error,
                  ),
                  label: const Text(
                    AppStrings.adminDeactivate,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Label kecil kode QR checkpoint.
class StatusChipText extends StatelessWidget {
  /// Membuat label kode QR.
  const StatusChipText({super.key, required this.code});

  /// Kode QR.
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(code, style: AppTypography.labelSm),
    );
  }
}
