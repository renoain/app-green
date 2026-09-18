// Komponen AppIcon sesuai docs/COMPONENT_LIBRARY.md (Base).
// Ikon konsisten Go Green: Lucide (varians lucide) atau SVG aset
// (varians asset) dengan pewarnaan opsional.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// Ikon Go Green dengan dua varians: lucide dan asset (SVG).
///
/// - [AppIcon.lucide]: memakai ikon flutter_lucide (pakai LucideIcons).
/// - [AppIcon.asset]: memakai SVG dari asset (mis. AppAssets.iconPoint).
class AppIcon extends StatelessWidget {
  /// Ikon Lucide.
  const AppIcon.lucide(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
  }) : path = null;

  /// Ikon SVG dari asset.
  const AppIcon.asset(
    this.path, {
    super.key,
    this.size = 20,
    this.color,
  }) : icon = null;

  /// Ikon Lucide (varians lucide).
  final IconData? icon;

  /// Path SVG (varians asset).
  final String? path;

  /// Ukuran ikon.
  final double size;

  /// Warna ikon. Null memakai warna bawaan.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppColors.textPrimary;
    if (path != null) {
      return SvgPicture.asset(
        path!,
        width: size,
        height: size,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(
                effectiveColor,
                BlendMode.srcIn,
              ),
      );
    }
    return Icon(icon, size: size, color: effectiveColor);
  }
}