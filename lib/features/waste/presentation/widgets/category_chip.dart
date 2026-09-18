// Komponen CategoryChip sesuai docs/COMPONENT_LIBRARY.md (Waste &
// Checkpoint). Chip pemilihan kategori sampah di halaman Buang Sampah.

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Chip kategori sampah yang bisa dipilih.
///
/// Saat [selected] true, latar [AppColors.primary] dan teks
/// [AppColors.textOnPrimary]; sebaliknya latar surface dan teks primary.
class CategoryChip extends StatelessWidget {
  /// Membuat chip kategori.
  const CategoryChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  /// Label kategori.
  final String label;

  /// Ikon opsional di samping label.
  final IconData? icon;

  /// Status terpilih.
  final bool selected;

  /// Aksi saat chip ditekan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                size: 16,
                color: selected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.labelMd.copyWith(
                color: selected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}