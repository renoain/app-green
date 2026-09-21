// Drawer navigasi admin (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Item menu drawer admin.
class AdminMenuItem {
  /// Membuat item menu drawer admin.
  const AdminMenuItem({required this.title, required this.icon});

  /// Judul menu.
  final String title;

  /// Ikon menu.
  final IconData icon;
}

/// Daftar menu admin lengkap (petugas hanya memakai 3 pertama).
const List<AdminMenuItem> adminMenuItems = <AdminMenuItem>[
  AdminMenuItem(title: AppStrings.adminDashboard, icon: LucideIcons.layout_dashboard),
  AdminMenuItem(title: AppStrings.adminManageTps, icon: LucideIcons.map_pin),
  AdminMenuItem(title: AppStrings.adminVerifyWaste, icon: LucideIcons.shield_check),
  AdminMenuItem(title: AppStrings.adminManageReward, icon: LucideIcons.gift),
  AdminMenuItem(title: AppStrings.adminManageUser, icon: LucideIcons.users),
  AdminMenuItem(title: AppStrings.adminSettings, icon: LucideIcons.settings),
];

/// Drawer sidebar admin dengan header identitas dan menu.
class AdminDrawer extends StatelessWidget {
  /// Membuat drawer admin.
  const AdminDrawer({
    super.key,
    required this.displayName,
    required this.roleLabel,
    required this.currentIndex,
    required this.visibleCount,
    required this.onSelect,
    required this.onLogout,
  });

  /// Nama admin yang login.
  final String displayName;

  /// Label role (admin/petugas).
  final String roleLabel;

  /// Index menu aktif.
  final int currentIndex;

  /// Jumlah menu tampil (petugas lebih sedikit).
  final int visibleCount;

  /// Aksi pilih menu.
  final ValueChanged<int> onSelect;

  /// Aksi logout.
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final List<AdminMenuItem> items =
        adminMenuItems.take(visibleCount).toList();
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    AppStrings.appName,
                    style: AppTypography.headlineSm,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(displayName, style: AppTypography.labelLg),
                  Text(roleLabel, style: AppTypography.bodySm),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.sm),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final AdminMenuItem item = items[index];
                  final bool selected = index == currentIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      selected: selected,
                      selectedTileColor: AppColors.surfaceDim,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                      ),
                      leading: Icon(item.icon, size: 20),
                      title: Text(item.title),
                      onTap: () => onSelect(index),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(LucideIcons.log_out, size: 20),
              title: const Text(AppStrings.logout),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
