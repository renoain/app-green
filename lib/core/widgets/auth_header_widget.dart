// Header reusable untuk halaman responsif Login & Register Go Green.
//
// Menampilkan logo daun, judul halaman, dan deskripsi singkat dengan
// spacing konsisten. Widget ini dipakai bersama oleh LoginPage dan
// RegisterPage agar kedua halaman punya tampilan yang seragam.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Header halaman autentikasi (logo + judul + deskripsi).
class AuthHeaderWidget extends StatelessWidget {
  /// Membuat header autentikasi.
  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  /// Judul halaman (misal "Masuk" / "Daftar").
  final String title;

  /// Deskripsi singkat di bawah judul.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: const Icon(
            LucideIcons.leaf,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          title,
          style: AppTypography.headlineLg,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: AppTypography.bodyMd,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
