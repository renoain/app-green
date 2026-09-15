// Komponen PrimaryButton: tombol utama sesuai docs/COMPONENT_LIBRARY.md
// dan docs/DESIGN_SYSTEM.md (Button -> Primary).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Tombol dengan label (teks dari pemanggil).

/// Tombol utama (primary action) aplikasi Go Green.
///
/// Background [AppColors.primary], teks [AppColors.textOnPrimary],
/// tinggi 48, radius [AppRadius.lg]. Mendukung state loading.
class PrimaryButton extends StatelessWidget {
  /// Membuat tombol utama.
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
  });

  /// Label tombol.
  final String text;

  /// Aksi saat tombol ditekan. Null untuk state disabled.
  final VoidCallback? onPressed;

  /// Menampilkan indikator loading menggantikan label.
  final bool isLoading;

  /// True: tombol selebar parent. False: selebar konten.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;
    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textOnPrimary,
            ),
          )
        : Text(
            text,
            style: AppTypography.labelLg.copyWith(color: AppColors.textOnPrimary),
          );

    return SizedBox(
      height: 48,
      width: isExpanded ? double.infinity : null,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: child,
      ),
    );
  }
}

/// Tombol sekunder (secondary action) aplikasi Go Green.///
/// Background [AppColors.surface], border [AppColors.border], teks
/// [AppColors.primary], tinggi 48, radius [AppRadius.lg].
class SecondaryButton extends StatelessWidget {
  /// Membuat tombol sekunder.
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isExpanded = true,
  });

  /// Label tombol.
  final String text;

  /// Aksi saat tombol ditekan. Null untuk state disabled.
  final VoidCallback? onPressed;

  /// True: tombol selebar parent. False: selebar konten.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: isExpanded ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: AppTypography.labelLg,
        ),
        child: Text(text),
      ),
    );
  }
}

/// Tombol teks (link) aplikasi Go Green.
///
/// Dipakai untuk link seperti "Belum punya akun? Daftar di sini".
class AppTextButton extends StatelessWidget {
  /// Membuat tombol teks.
  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  /// Label tombol.
  final String text;

  /// Aksi saat tombol ditekan. Null untuk state disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        textStyle: AppTypography.labelLg,
      ),
      child: Text(text),
    );
  }
}

/// Tombol masuk/daftar dengan Google (sekali klik OAuth).
///
/// Menampilkan ikon Chrome sebagai identitas Google, gaya outlined sekunder
/// tinggi 48 dan radius [AppRadius.lg], konsisten dengan SecondaryButton.
class GoogleAuthButton extends StatelessWidget {
  /// Membuat tombol autentikasi Google.
  const GoogleAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Label tombol ("Masuk dengan Google" / "Daftar dengan Google").
  final String text;

  /// Aksi saat tombol ditekan. Null untuk state disabled.
  final VoidCallback? onPressed;

  /// Menampilkan indikator loading menggantikan label.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;
    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                const Icon(
                  LucideIcons.globe,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                text,
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          );

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        child: child,
      ),
    );
  }
}