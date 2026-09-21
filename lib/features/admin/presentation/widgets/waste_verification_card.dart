// Kartu item antrean verifikasi admin (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../waste/domain/entities/waste_log.dart';

/// Kartu satu waste log pending: kategori, pengirim, waktu, aksi detail.
class WasteVerificationCard extends StatelessWidget {
  /// Membuat kartu verifikasi.
  const WasteVerificationCard({
    super.key,
    required this.log,
    required this.onTap,
  });

  /// Waste log yang ditampilkan.
  final WasteLog log;

  /// Aksi buka detail.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.surfaceDim,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.image,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    log.category.value,
                    style: AppTypography.labelLg,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    log.submitterName ?? log.userId,
                    style: AppTypography.bodySm,
                  ),
                  Text(
                    formatIndonesianTimestamp(
                      log.createdAt.toLocal(),
                    ),
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevron_right,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
