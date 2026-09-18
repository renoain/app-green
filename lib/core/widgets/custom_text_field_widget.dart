// Komponen CustomTextField dan SearchField sesuai docs/COMPONENT_LIBRARY.md
// dan docs/DESIGN_SYSTEM.md (Input).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Text field custom aplikasi Go Green.
///
/// Memakai tema input dari [ThemeData.inputDecorationTheme] (lihat
/// lib/core/theme/app_theme.dart) dengan dukungan label, hint, ikon,
/// validasi, dan mode rahasia.
class CustomTextField extends StatelessWidget {
  /// Membuat text field custom.
  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.onSuffixTap,
    this.onChanged,
    this.onFieldSubmitted,
  });

  /// Label field (opsional).
  final String? label;

  /// Hint text (opsional).
  final String? hint;

  /// Ikon di sisi kiri field (opsional).
  final IconData? prefixIcon;

  /// Ikon di sisi kanan field (opsional).
  final IconData? suffixIcon;

  /// Controller text (opsional).
  final TextEditingController? controller;

  /// Validator (opsional).
  final String? Function(String?)? validator;

  /// Tipe keyboard (default: text).
  final TextInputType? keyboardType;

  /// Mode rahasia (mis. password).
  final bool obscureText;

  /// Apakah field bisa diisi (false untuk tampilan baca-saja).
  final bool enabled;

  /// Aksi saat ikon kanan ditekan (mis. toggle password visibility).
  final VoidCallback? onSuffixTap;

  /// Callback saat nilai berubah.
  final ValueChanged<String>? onChanged;

  /// Callback saat tombol submit ditekan.
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTypography.bodyLg,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: AppColors.textSecondary)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixTap,
                icon: Icon(suffixIcon, size: 20, color: AppColors.textSecondary),
              )
            : null,
      ),
    );
  }
}

/// Field pencarian (search) aplikasi Go Green.
///
/// Dipakai untuk pencarian artikel dan filter aktivitas.
class SearchField extends StatelessWidget {
  /// Membuat field pencarian.
  const SearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
  });

  /// Hint text.
  final String hint;

  /// Controller text (opsional).
  final TextEditingController? controller;

  /// Callback saat nilai berubah.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          LucideIcons.search,
          size: 20,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}