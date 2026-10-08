// Tombol next onboarding yang berubah bentuk mengikuti slide terakhir.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Tombol next onboarding ala template referensi: lingkaran panah di slide
/// awal, melebar jadi pil berlabel di slide terakhir. Animasi hanya memakai
/// widget bawaan Flutter agar tanpa dependency baru.
class MorphingNextButton extends StatelessWidget {
  const MorphingNextButton({
    super.key,
    required this.label,
    required this.expanded,
    required this.onPressed,
  });

  /// Teks pil saat [expanded] true (mis. Mulai).
  final String label;

  /// True di slide terakhir sehingga tombol melebar jadi pil.
  final bool expanded;

  /// Aksi saat tombol ditekan.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 480),
      curve: Curves.fastOutSlowIn,
      height: 58,
      width: expanded ? 200 : 58,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          expanded ? AppRadius.lg : AppRadius.full,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            expanded ? AppRadius.lg : AppRadius.full,
          ),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 480),
              child: expanded
                  ? Row(
                      key: const ValueKey<String>('morph-pill'),
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            label,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: AppTypography.labelLg.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(
                          LucideIcons.arrow_right,
                          color: AppColors.textOnPrimary,
                        ),
                      ],
                    )
                  : const Icon(
                      key: ValueKey<String>('morph-circle'),
                      LucideIcons.arrow_right,
                      color: AppColors.textOnPrimary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
