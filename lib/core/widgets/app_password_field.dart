// Komponen AppPasswordField sesuai docs/COMPONENT_LIBRARY.md (Form).
// Membungkus CustomTextField dengan mode rahasia dan toggle mata otomatis.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'custom_text_field_widget.dart';

/// Field input password dengan toggle tampil/sembunyi bawaan.
///
/// Memakai [CustomTextField] sehingga label, hint, validasi, dan tema input
/// tetap konsisten dengan halaman autentikasi.
class AppPasswordField extends StatefulWidget {
  /// Membuat field password.
  const AppPasswordField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });

  /// Label field.
  final String? label;

  /// Hint text.
  final String? hint;

  /// Controller text.
  final TextEditingController? controller;

  /// Validator.
  final String? Function(String?)? validator;

  /// Callback saat nilai berubah.
  final ValueChanged<String>? onChanged;

  /// Callback saat submit field.
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscure,
      suffixIcon: _obscure ? LucideIcons.eye : LucideIcons.eye_off,
      onSuffixTap: () => setState(() => _obscure = !_obscure),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}