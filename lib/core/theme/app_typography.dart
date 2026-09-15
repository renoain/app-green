// Menyimpan seluruh token tipografi aplikasi sesuai docs/DESIGN_SYSTEM.md.
//
// Headline memakai font Manrope, body/label memakai font Geist.
// Sumber kebenaran: docs/DESIGN_SYSTEM.md -> Typography.

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Token tipografi aplikasi Go Green.
class AppTypography {
  AppTypography._();

  /// Nama font untuk headline.
  static const String fontManrope = 'Manrope';

  /// Nama font untuk body.
  static const String fontGeist = 'Geist';

  /// Headline terbesar, untuk judul halaman utama.
  static const TextStyle headlineXl = TextStyle(
    fontFamily: fontManrope,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.02,
    color: AppColors.textPrimary,
  );

  /// Headline besar, untuk judul section.
  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontManrope,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.015,
    color: AppColors.textPrimary,
  );

  /// Headline sedang.
  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontManrope,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.textPrimary,
  );

  /// Headline kecil.
  static const TextStyle headlineSm = TextStyle(
    fontFamily: fontManrope,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.textPrimary,
  );

  /// Body besar, teks paragraf utama.
  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontGeist,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  /// Body sedang, teks deskripsi.
  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontGeist,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textSecondary,
  );

  /// Body kecil, teks tambahan.
  static const TextStyle bodySm = TextStyle(
    fontFamily: fontGeist,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );

  /// Label besar, tombol/aksi utama.
  static const TextStyle labelLg = TextStyle(
    fontFamily: fontGeist,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
    color: AppColors.textPrimary,
  );

  /// Label sedang, form field.
  static const TextStyle labelMd = TextStyle(
    fontFamily: fontGeist,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 18 / 13,
    color: AppColors.textPrimary,
  );

  /// Label kecil, badge/caption.
  static const TextStyle labelSm = TextStyle(
    fontFamily: fontGeist,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    letterSpacing: 0.02,
    color: AppColors.textSecondary,
  );
}