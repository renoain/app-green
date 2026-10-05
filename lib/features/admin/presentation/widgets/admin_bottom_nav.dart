// Navbar bawah admin + sheet semua menu (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bottom_nav_active_icon.dart';
import 'admin_drawer.dart';

/// Index branch untuk 3 tombol navbar bawah admin.
const List<int> adminBottomBranches = <int>[0, 1, 2];

/// Navbar bawah admin: 3 menu utama + grip usap-atas.
class AdminBottomBar extends StatelessWidget {
  const AdminBottomBar({
    super.key,
    required this.currentIndex,
    required this.visibleCount,
    required this.showUserMode,
    required this.onSelectBranch,
    required this.onUserMode,
  });

  /// Index branch aktif (bisa di luar 0-2 bila dari drawer/sheet).
  final int currentIndex;

  /// Jumlah menu tampil (petugas lebih sedikit).
  final int visibleCount;

  /// Tampilkan Mode Pengguna di sheet (khusus role admin).
  final bool showUserMode;

  /// Aksi pilih branch.
  final ValueChanged<int> onSelectBranch;

  /// Aksi kembali ke UI user.
  final VoidCallback onUserMode;

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      enableDrag: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      builder: (BuildContext sheetContext) {
        final List<AdminMenuItem> items =
            adminMenuItems.take(visibleCount).toList();
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius:
                        BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.adminMoreMenu,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (int i = 0; i < items.length; i++)
                ListTile(
                  selected: i == currentIndex,
                  selectedTileColor: AppColors.surfaceDim,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  leading: Icon(items[i].icon, size: 20),
                  title: Text(items[i].title),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSelectBranch(i);
                  },
                ),
              if (showUserMode) ...<Widget>[
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(LucideIcons.smartphone, size: 20),
                  title: Text(AppStrings.adminUserMode),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onUserMode();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AdminMenuItem> items =
        adminMenuItems.take(3).toList();
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -200) {
          _openSheet(context);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () => _openSheet(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius:
                          BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  for (int i = 0; i < items.length; i++)
                    Expanded(
                      child: _AdminBottomButton(
                        item: items[i],
                        selected: i == currentIndex,
                        onTap: () => onSelectBranch(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satu tombol navbar bawah admin.
class _AdminBottomButton extends StatelessWidget {
  const _AdminBottomButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  /// Item menu.
  final AdminMenuItem item;

  /// Apakah branch sedang aktif.
  final bool selected;

  /// Aksi saat ditekan.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BottomNavActiveIcon(
              icon: item.icon,
              selected: selected,
              style: AppValues.bottomNavActiveStyle,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.title,
              style: AppTypography.labelSm.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
