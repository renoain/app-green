// Komponen AppCheckbox sesuai docs/COMPONENT_LIBRARY.md (Form).
// Checkbox dengan label teks dan tautan opsional di dalam label.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Checkbox berkonsep Go Green dengan label dan tautan opsional.
///
/// Dipakai untuk persetujuan Syarat & Ketentuan di Register dan
/// "Ingat saya" di Login.
class AppCheckbox extends StatelessWidget {
  /// Membuat checkbox dengan label.
  const AppCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.linkText,
    this.onLinkTap,
  });

  /// Nilai centang saat ini.
  final bool value;

  /// Teks label.
  final String label;

  /// Callback saat nilai berubah.
  final ValueChanged<bool>? onChanged;

  /// Teks tautan opsional di dalam label (mis. "Syarat & Ketentuan").
  final String? linkText;

  /// Aksi saat tautan ditekan. Null menonaktifkan tautan.
  final VoidCallback? onLinkTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged?.call(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: value,
              activeColor: AppColors.primary,
              onChanged: onChanged == null
                  ? null
                  : (bool? checked) => onChanged!(checked ?? false),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text.rich(
              TextSpan(
                text: label,
                style: AppTypography.bodySm,
                children: <TextSpan>[
                  if (linkText != null) ...<TextSpan>[
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: linkText,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: onLinkTap != null
                          ? (TapGestureRecognizer()
                            ..onTap = onLinkTap!)
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}