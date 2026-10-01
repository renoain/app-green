import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Ikon bottom nav dengan 3 gaya aktif (circle, elevated, pill).
///
/// Gaya dipilih via AppValues.bottomNavActiveStyle:
/// - 1: Circle background (ikon putih di lingkaran primary).
/// - 2: Elevated icon (ikon primary + shadow + scale).
/// - 3: Pill indicator (ikon primary + pill di atas).
class BottomNavActiveIcon extends StatelessWidget {
  /// Membuat ikon bottom nav aktif.
  const BottomNavActiveIcon({
    super.key,
    required this.icon,
    required this.selected,
    required this.style,
  });

  /// Ikon yang ditampilkan.
  final IconData icon;

  /// Apakah item sedang aktif.
  final bool selected;

  /// Versi gaya (1, 2, atau 3).
  final int style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case 2:
        return _buildElevated();
      case 3:
        return _buildPill();
      case 1:
      default:
        return _buildCircle();
    }
  }

  /// Versi 1: circle background.
  Widget _buildCircle() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(selected ? AppSpacing.sm : 0),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: selected ? AppElevation.level1 : null,
      ),
      child: Icon(
        icon,
        size: selected ? 22 : 24,
        color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
      ),
    );
  }

  /// Versi 2: elevated icon.
  Widget _buildElevated() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: selected ? AppElevation.level2 : null,
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: selected ? 1.15 : 1.0,
        child: Icon(
          icon,
          size: 24,
          color: selected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  /// Versi 3: pill indicator.
  Widget _buildPill() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: selected ? 20 : 0,
          height: 3,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Icon(
          icon,
          size: 24,
          color: selected ? AppColors.primary : AppColors.textSecondary,
        ),
      ],
    );
  }
}
