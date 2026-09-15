// Halaman pengaturan sesuai docs/UI_PAGES.md (Profile).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/display_widgets.dart';

/// Halaman pengaturan aplikasi Go Green.
///
/// Berisi menu akun (edit profil), preferensi notifikasi dan mode gelap,
/// serta informasi aplikasi. Mode gelap disiapkan untuk fase berikutnya.
class SettingsPage extends StatefulWidget {
  /// Membuat halaman pengaturan.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationEnabled = true;
  bool _darkModeEnabled = false;

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.settingsVersionValue,
      applicationLegalese: '${AppStrings.appName} ${AppStrings.settingsVersionValue}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.settings,
        leading: LucideIcons.arrow_left,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _sectionTitle(AppStrings.settingsAccountTitle),
            ListTileItem(
              icon: LucideIcons.user,
              title: AppStrings.editProfile,
              onTap: () => context.pushNamed(AppRouteName.editProfile),
            ),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle(AppStrings.settingsPreferencesTitle),
            _buildSwitchTile(
              icon: LucideIcons.bell,
              title: AppStrings.settingsNotification,
              subtitle: AppStrings.settingsNotificationDesc,
              value: _notificationEnabled,
              onChanged: (bool value) {
                setState(() => _notificationEnabled = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSwitchTile(
              icon: LucideIcons.moon,
              title: AppStrings.settingsDarkMode,
              subtitle: AppStrings.settingsDarkModeDesc,
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() => _darkModeEnabled = value);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle(AppStrings.settingsInfoTitle),
            ListTileItem(
              icon: LucideIcons.info,
              title: AppStrings.settingsVersion,
              trailing: Text(
                AppStrings.settingsVersionValue,
                style: AppTypography.labelLg.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTileItem(
              icon: LucideIcons.heart_handshake,
              title: AppStrings.settingsAbout,
              onTap: _showAbout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.labelLg.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.tertiaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppTypography.labelLg),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: AppTypography.bodySm),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}