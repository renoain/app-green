// Merakit token desain menjadi ThemeData aplikasi Go Green.
//
// Sumber kebenaran: docs/DESIGN_SYSTEM.md. Gunakan AppTheme.light()
// sebagai tema aplikasi di MaterialApp.

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Theme aplikasi Go Green.
class AppTheme {
  AppTheme._();

  /// Membangun ThemeData light untuk aplikasi.
  static ThemeData light() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontManrope,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSm,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// Memetakan AppTypography ke TextTheme Flutter.
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: AppTypography.headlineXl,
      headlineLarge: AppTypography.headlineLg,
      headlineMedium: AppTypography.headlineMd,
      headlineSmall: AppTypography.headlineSm,
      bodyLarge: AppTypography.bodyLg,
      bodyMedium: AppTypography.bodyMd,
      bodySmall: AppTypography.bodySm,
      labelLarge: AppTypography.labelLg,
      labelMedium: AppTypography.labelMd,
      labelSmall: AppTypography.labelSm,
    );
  }

  /// Style tombol elevated sesuai komponen PrimaryButton.
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.surfaceDim,
        disabledForegroundColor: AppColors.textDisabled,
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        textStyle: AppTypography.labelLg,
      ),
    );
  }

  /// Style input sesuai komponen CustomTextField.
  static InputDecorationTheme _buildInputDecorationTheme() {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.border),
    );
    final OutlineInputBorder focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.outline, width: 2),
    );
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.error),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundAlt,
      border: border,
      enabledBorder: border,
      focusedBorder: focusBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      labelStyle: AppTypography.labelMd,
      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textDisabled),
      errorStyle: AppTypography.bodySm.copyWith(color: AppColors.error),
    );
  }
}