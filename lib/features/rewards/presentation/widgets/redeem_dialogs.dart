// Popup konfirmasi + sukses penukaran reward (presentation).
//
// Animasi scale + fade 350ms seperti popup poin. Tombol Batal selalu
// di kiri sebagai teks, aksi utama di kanan sebagai PrimaryButton.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button_widgets.dart';

/// Kerangka popup animasi; [onConfirm] true bila aksi utama ditekan.
Future<bool> _showAnimatedPopup({
  required BuildContext context,
  required IconData icon,
  required String title,
  String? detail,
  required String message,
  required String cancelText,
  required String confirmText,
  bool stackActions = false,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (
      BuildContext dialogContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 30, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: AppTypography.headlineSm,
                  textAlign: TextAlign.center,
                ),
                if (detail != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    detail,
                    style: AppTypography.labelLg.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message,
                  style: AppTypography.bodySm,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (stackActions) ...<Widget>[
                  PrimaryButton(
                    text: confirmText,
                    onPressed: () =>
                        Navigator.of(dialogContext).pop(true),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    text: cancelText,
                    onPressed: () =>
                        Navigator.of(dialogContext).pop(false),
                  ),
                ] else
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SecondaryButton(
                          text: cancelText,
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: PrimaryButton(
                          text: confirmText,
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final CurvedAnimation curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: curved, child: child),
      );
    },
  ).then((bool? value) => value ?? false);
}

/// Popup konfirmasi penukaran; true bila user menekan Tukar.
Future<bool> showRedeemConfirmDialog(
  BuildContext context, {
  required String rewardTitle,
  required int pointCost,
}) {
  return _showAnimatedPopup(
    context: context,
    icon: LucideIcons.gift,
    title: AppStrings.redeemConfirmTitle,
    detail: '$rewardTitle • '
        '${formatIndonesianNumber(pointCost)} ${AppStrings.rewardPointSuffix}',
    message: AppStrings.redeemConfirmMessage,
    cancelText: AppStrings.cancelButton,
    confirmText: AppStrings.rewardExchangeButton,
  );
}

/// Popup penukaran berhasil; true bila user menekan Lihat Voucher Saya.
Future<bool> showRedeemSuccessDialog(BuildContext context) {
  return _showAnimatedPopup(
    context: context,
    icon: LucideIcons.check,
    title: AppStrings.redeemSuccessTitle,
    message: AppStrings.redeemSuccessMessage,
    cancelText: AppStrings.redeemCloseButton,
    confirmText: AppStrings.redeemGoVoucherButton,
    stackActions: true,
  );
}
