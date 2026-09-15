// Komponen feedback sesuai docs/COMPONENT_LIBRARY.md (Feedback).
// Dikelompokkan dalam satu file: EmptyState.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button_widgets.dart';

/// State kosong: daftar kosong atau pencarian tanpa hasil.
class EmptyState extends StatelessWidget {
  /// Membuat empty state.
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  /// Ikon utama.
  final IconData icon;

  /// Judul empty state.
  final String title;

  /// Pesan penjelasan.
  final String message;

  /// Label tombol aksi opsional.
  final String? actionText;

  /// Aksi tombol opsional.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.tertiaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headlineSm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMd,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              AppTextButton(text: actionText!, onPressed: onAction!),
            ],
          ],
        ),
      ),
    );
  }
}