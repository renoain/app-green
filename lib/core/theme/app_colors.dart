// Menyimpan seluruh token warna aplikasi sesuai docs/DESIGN_SYSTEM.md.
//
// Wajib dipakai sebagai satu-satunya sumber warna. Dilarang hardcode
// Color(0xFF...) langsung di widget.

import 'package:flutter/material.dart';

/// Token warna aplikasi Go Green.
///
/// Sumber kebenaran: docs/DESIGN_SYSTEM.md -> Color Tokens.
class AppColors {
  AppColors._();

  /// Warna utama aplikasi.
  static const Color primary = Color(0xFF1E4633);

  /// Variasi terang dari warna utama.
  static const Color primaryLight = Color(0xFF2D6A4F);

  /// Variasi gelap dari warna utama.
  static const Color primaryDark = Color(0xFF042F1E);

  /// Warna sekunder, dipakai untuk ikon/badge/accent.
  static const Color secondary = Color(0xFF52B788);

  /// Variasi terang dari warna sekunder.
  static const Color secondaryLight = Color(0xFF74C69D);

  /// Latar badge/tag sekunder.
  static const Color secondaryContainer = Color(0xFF92F7C3);

  /// Warna tersier, border aktif/separator.
  static const Color tertiary = Color(0xFFA3C9A8);

  /// Variasi terang dari warna tersier.
  static const Color tertiaryLight = Color(0xFFD8E8D5);

  /// Latar utama aplikasi.
  static const Color background = Color(0xFFEAF4E8);

  /// Latar alternatif (input field).
  static const Color backgroundAlt = Color(0xFFF4F8F3);

  /// Permukaan card/sheet/modal.
  static const Color surface = Color(0xFFFFFFFF);

  /// Permukaan redup (card disabled/skeleton).
  static const Color surfaceDim = Color(0xFFE6F8ED);

  /// Teks utama/judul.
  static const Color textPrimary = Color(0xFF24332C);

  /// Teks sekunder/deskripsi.
  static const Color textSecondary = Color(0xFF6B7F75);

  /// Teks disabled.
  static const Color textDisabled = Color(0xFF8FA599);

  /// Teks di atas elemen primary.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Status berhasil.
  static const Color success = Color(0xFF52B788);

  /// Status peringatan.
  static const Color warning = Color(0xFFF4A261);

  /// Status gagal/error.
  static const Color error = Color(0xFFBA1A1A);

  /// Status informasi.
  static const Color info = Color(0xFF4A90E2);

  /// Border default.
  static const Color border = Color(0xFFD4E4D3);

  /// Border ringan.
  static const Color borderLight = Color(0xFFE2EFE0);

  /// Outline aktif/focus.
  static const Color outline = Color(0xFF717973);
}