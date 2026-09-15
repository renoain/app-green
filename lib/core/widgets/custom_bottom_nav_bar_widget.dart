// Komponen CustomBottomNavBar sesuai docs/COMPONENT_LIBRARY.md (Navigation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Item tunggal pada bottom navigation bar.
class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    this.accent = false,
  });

  /// Label item.
  final String label;

  /// Ikon item.
  final IconData icon;

  /// Apakah item menjadi tombol aksen utama (tengah).
  final bool accent;
}

/// Kumpulan item bottom navigation Go Green (sesuai UI_PAGES Home).
const List<_BottomNavItem> _items = <_BottomNavItem>[
  _BottomNavItem(label: AppStrings.navHome, icon: LucideIcons.house),
  _BottomNavItem(label: AppStrings.navActivity, icon: LucideIcons.activity),
  _BottomNavItem(
    label: AppStrings.navWaste,
    icon: LucideIcons.recycle,
    accent: true,
  ),
  _BottomNavItem(label: AppStrings.navPoints, icon: LucideIcons.star),
  _BottomNavItem(label: AppStrings.navProfile, icon: LucideIcons.user),
];

/// Bottom navigation bar aplikasi Go Green.
///
/// Terdiri dari 5 item: Beranda, Aktivitas, Buang Sampah (aksen), Poin,
/// Profile. Item "Buang Sampah" tampil sebagai tombol bulat warna primary.
class CustomBottomNavBar extends StatelessWidget {
  /// Membuat bottom navigation bar.
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Index item yang sedang aktif.
  final int currentIndex;

  /// Callback saat item ditekan.
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

    if (item.accent) {
      return InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: AppElevation.level1,
              ),
              child: const Icon(
                LucideIcons.recycle,
                size: 24,
                color: AppColors.textOnPrimary,
              ),
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

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.icon,
            size: 24,
            color: selected ? AppColors.primary : AppColors.textSecondary,
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

/// Gaya label kecil untuk bottom nav; warna mengikuti status selected.
TextStyle _itemLabelStyle(bool selected) {
  return AppTypography.labelSm.copyWith(
    color: selected ? AppColors.primary : AppColors.textSecondary,
  );
}