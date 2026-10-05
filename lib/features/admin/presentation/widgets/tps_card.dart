// Kartu item TPS untuk daftar kelola admin (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import 'checkpoint_qr_sheet.dart';

/// Kartu satu TPS: nama, status, koordinat, radius, QR, aksi.
class TpsCard extends StatelessWidget {
  const TpsCard({
    super.key,
    required this.checkpoint,
    required this.onEdit,
    required this.onDeactivate,
    required this.onActivate,
  });

  /// Checkpoint yang ditampilkan.
  final Checkpoint checkpoint;

  /// Aksi ubah.
  final VoidCallback onEdit;

  /// Aksi nonaktifkan (soft-delete).
  final VoidCallback onDeactivate;

  /// Aksi aktifkan kembali.
  final VoidCallback onActivate;

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
              IconButton(
                tooltip: AppStrings.adminQrShowTooltip,
                icon: const Icon(LucideIcons.qr_code, size: 20),
                onPressed: () =>
                    showCheckpointQrDialog(context, checkpoint),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              if (checkpoint.code != null &&
                  checkpoint.code!.isNotEmpty)
                Text(
                  checkpoint.code!,
                  style: AppTypography.labelSm,
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: checkpoint.isActive
                      ? AppColors.tertiaryLight
                      : AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  checkpoint.isActive
                      ? AppStrings.adminActiveLabel
                      : AppStrings.adminInactiveLabel,
                  style: AppTypography.labelSm,
                ),
              ),
            ],
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
          const SizedBox(height: AppSpacing.xs),
          _QuotaLabel(checkpoint: checkpoint),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(LucideIcons.pencil, size: 16),
                  label: Text(AppStrings.adminEditTps),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: checkpoint.isActive
                    ? OutlinedButton.icon(
                        onPressed: onDeactivate,
                        icon: const Icon(
                          LucideIcons.power,
                          size: 16,
                          color: AppColors.error,
                        ),
                        label: Text(
                          AppStrings.adminDeactivate,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: onActivate,
                        icon: const Icon(
                          LucideIcons.power,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          AppStrings.adminActivate,
                          style:
                              const TextStyle(color: AppColors.primary),
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

/// Label sisa kuota checkpoint dengan warna status.
class _QuotaLabel extends StatelessWidget {
  const _QuotaLabel({required this.checkpoint});

  /// Checkpoint yang ditampilkan.
  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    final int? maxUses = checkpoint.maxUses;
    if (maxUses == null) {
      return Row(
        children: <Widget>[
          const Icon(
            LucideIcons.ticket,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            AppStrings.checkpointUnlimited,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }
    final int remaining = checkpoint.remainingUses ?? maxUses;
    final double ratio = maxUses <= 0 ? 0 : remaining / maxUses;
    final Color statusColor = ratio > 0.5
        ? AppColors.success
        : ratio >= 0.1
            ? AppColors.warning
            : AppColors.error;
    return Row(
      children: <Widget>[
        Icon(LucideIcons.ticket, size: 14, color: statusColor),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${AppStrings.checkpointQuotaRemaining}: $remaining / $maxUses',
          style: AppTypography.bodySm.copyWith(color: statusColor),
        ),
      ],
    );
  }
}

/// Label kecil kode QR checkpoint.
class StatusChipText extends StatelessWidget {
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
