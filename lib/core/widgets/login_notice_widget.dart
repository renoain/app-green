// Komponen notice login yang bisa di-tutup, dipakai di Home dan Profile.
// Menampilkan pesan singkat, aksi "Masuk", dan tombol tutup opsional.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button_widgets.dart';

/// Notice login dengan aksi Masuk dan tombol tutup opsional.
class LoginNoticeCard extends StatelessWidget {
  /// Membuat notice login.
  const LoginNoticeCard({
    super.key,
    required this.message,
    required this.onLogin,
    this.onDismiss,
    this.actionLabel = AppStrings.homeLoginNoticeAction,
  });

  /// Teks pesan notice.
  final String message;

  /// Label aksi login.
  final String actionLabel;

  /// Aksi saat tombol login ditekan.
  final VoidCallback onLogin;

  /// Bila diisi, tombol tutup (x) tampil.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            LucideIcons.user,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySm,
            ),
          ),
          AppTextButton(
            text: actionLabel,
            onPressed: onLogin,
          ),
          if (onDismiss != null) ...<Widget>[
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              tooltip: AppStrings.homeLoginNoticeDismiss,
              onPressed: onDismiss,
              icon: const Icon(LucideIcons.x, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}