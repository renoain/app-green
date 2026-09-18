// Komponen LocationStatusCard sesuai docs/COMPONENT_LIBRARY.md (Waste &
// Checkpoint). Kartu status radius GPS user terhadap checkpoint terpilih.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/app_button_widgets.dart';
import '../../../../../core/widgets/status_widgets.dart';

/// Kartu status lokasi user terhadap radius checkpoint.
///
/// Menampilkan label "Berhasil" bila [withinRadius] true, "Di luar radius"
/// bila false, beserta jarak saat ini dan radius checkpoint.
class LocationStatusCard extends StatelessWidget {
  /// Membuat kartu status lokasi.
  const LocationStatusCard({
    super.key,
    required this.withinRadius,
    required this.distanceMeters,
    required this.radiusMeters,
    this.onCheckLocation,
  });

  /// Apakah user berada di dalam radius checkpoint.
  final bool withinRadius;

  /// Jarak user ke checkpoint dalam meter.
  final double distanceMeters;

  /// Radius checkpoint dalam meter.
  final double radiusMeters;

  /// Aksi saat tombol "cek ulang" ditekan.
  final VoidCallback? onCheckLocation;

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        withinRadius ? AppColors.success : AppColors.error;
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: withinRadius
                      ? AppColors.secondaryContainer
                      : AppColors.surfaceDim,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  withinRadius
                      ? LucideIcons.shield_check
                      : LucideIcons.shield_alert,
                  size: 20,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      AppStrings.wasteGpsTitle,
                      style: AppTypography.labelLg,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${formatIndonesianNumber(distanceMeters.round())} m '
                      'dari checkpoint (radius ${formatIndonesianNumber(radiusMeters.round())} m)',
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: withinRadius
                    ? AppStrings.activityStatusSuccess
                    : AppStrings.wasteGpsOutsideLabel,
                type: withinRadius ? StatusType.success : StatusType.error,
              ),
            ],
          ),
          if (onCheckLocation != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: AppTextButton(
                text: AppStrings.retryButton,
                onPressed: onCheckLocation!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}