// Komponen CustomBottomNavBar sesuai docs/COMPONENT_LIBRARY.md (Navigation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../constants/app_strings.dart';
import '../constants/app_values.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'bottom_nav_active_icon.dart';

/// Satu item bottom nav (label + ikon).
class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

/// Kumpulan item bottom navigation Go Green (sesuai UI_PAGES Home).
final List<_BottomNavItem> _items = <_BottomNavItem>[
  _BottomNavItem(label: AppStrings.navHome, icon: LucideIcons.house),
  _BottomNavItem(label: AppStrings.navActivity, icon: LucideIcons.activity),
  _BottomNavItem(label: AppStrings.navWaste, icon: LucideIcons.recycle),
  _BottomNavItem(label: AppStrings.navPoints, icon: LucideIcons.star),
  _BottomNavItem(label: AppStrings.navProfile, icon: LucideIcons.user),
];

/// Bottom nav 5 item setara, gaya aktif via BottomNavActiveIcon.
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppElevation.level2,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: List<Widget>.generate(_items.length, (int index) {
              return Expanded(
                child: _buildItem(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final _BottomNavItem item = _items[index];
    final bool selected = index == currentIndex;

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BottomNavActiveIcon(
            icon: item.icon,
            selected: selected,
            style: AppValues.bottomNavActiveStyle,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.label,
            style: _itemLabelStyle(selected),
          ),
          _buildActiveIndicator(selected),
        ],
      ),
    );
  }

  Widget _buildActiveIndicator(bool selected) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }
}

/// Label nav: primary saat aktif, abu saat tidak aktif.
TextStyle _itemLabelStyle(bool selected) {
  return AppTypography.labelSm.copyWith(
    color: selected ? AppColors.primary : AppColors.textSecondary,
  );
}
