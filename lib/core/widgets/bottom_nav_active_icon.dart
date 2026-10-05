// Ikon bottom nav dengan gaya aktif di belakang ikon tab.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Ikon bottom nav: 1=circle, 2=elevated, 3=pill, 4=pop (uji coba).
class BottomNavActiveIcon extends StatelessWidget {
  const BottomNavActiveIcon({
    super.key,
    required this.icon,
    required this.selected,
    required this.style,
  });

  final IconData icon;
  final bool selected;
  final int style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case 2:
        return _buildElevated();
      case 3:
        return _buildPill();
      case 4:
        return _buildPopCircle();
      case 1:
      default:
        return _buildCircle();
    }
  }

  /// Style 1: lingkaran primary saat aktif.
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

  /// Style 2: ikon elevated + shadow saat aktif.
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

  /// Style 3: pill kecil di atas ikon saat aktif.
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

  /// Style 4: lingkaran 44px timbul saat aktif, tetap di dalam bar.
  Widget _buildPopCircle() {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          AnimatedScale(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            scale: selected ? 1.0 : 0.0,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: AppElevation.level1,
              ),
            ),
          ),
          Icon(
            icon,
            size: 24,
            color:
                selected ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
