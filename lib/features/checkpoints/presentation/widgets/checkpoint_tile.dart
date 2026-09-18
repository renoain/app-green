// Komponen CheckpointTile sesuai docs/COMPONENT_LIBRARY.md (Waste &
// Checkpoint). Menampilkan satu baris checkpoint dengan status terpilih.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Baris item checkpoint yang bisa dipilih di halaman Buang Sampah.
///
/// Saat [selected] true, ditampilkan ikon centang dan border warna
/// [AppColors.primary].
class CheckpointTile extends StatelessWidget {
  /// Membuat item checkpoint.
  const CheckpointTile({
    super.key,
    required this.name,
    this.address,
    this.icon = LucideIcons.map_pin,
    this.selected = false,
    this.distanceLabel,
    this.onTap,
  });

  /// Nama checkpoint.
  final String name;

  /// Alamat checkpoint.
  final String? address;

  /// Ikon utama (default map_pin).
  final IconData icon;

  /// Status terpilih.
  final bool selected;

  /// Label jarak, misal "120 m".
  final String? distanceLabel;

  /// Aksi saat baris ditekan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.borderLight,
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.secondaryContainer
                      : AppColors.tertiaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? AppColors.success : AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name, style: AppTypography.labelLg),
                    if (address != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xs),
                      Text(address!, style: AppTypography.bodySm),
                    ],
                  ],
                ),
              ),
              if (distanceLabel != null) ...<Widget>[
                Text(
                  distanceLabel!,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (selected)
                const Icon(
                  LucideIcons.circle_check,
                  size: 20,
                  color: AppColors.success,
                )
              else
                const Icon(
                  LucideIcons.circle,
                  size: 20,
                  color: AppColors.border,
                ),
            ],
          ),
        ),
      ),
    );
  }
}