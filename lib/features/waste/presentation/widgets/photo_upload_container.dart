// Komponen PhotoUploadContainer sesuai docs/COMPONENT_LIBRARY.md (Waste &
// Checkpoint). Pemicu kamera in-app di halaman Buang Sampah dengan border
// putus-putus (dashed border) via CustomPainter.

import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Container upload foto bukti dengan border putus-putus dan ikon kamera.
///
/// Saat [hasPhoto] true, indikator foto terpasang ditampilkan menggantikan
/// ikon kamera.
class PhotoUploadContainer extends StatelessWidget {
  /// Membuat container upload foto.
  const PhotoUploadContainer({
    super.key,
    this.label = AppStrings.takePhotoButton,
    this.hint,
    this.hasPhoto = false,
    this.onTap,
  });

  /// Label utama, default "Ambil Foto".
  final String label;

  /// Hint tambahan opsional.
  final String? hint;

  /// Apakah foto sudah terpasang.
  final bool hasPhoto;

  /// Aksi saat container ditekan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.border,
          radius: AppRadius.lg,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: hasPhoto
                      ? AppColors.secondaryContainer
                      : AppColors.tertiaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasPhoto ? LucideIcons.check : LucideIcons.camera,
                  size: 24,
                  color: hasPhoto
                      ? AppColors.success
                      : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                hasPhoto ? AppStrings.photoAttachedLabel : label,
                style: AppTypography.labelLg,
              ),
              if (hint != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                Text(hint!, style: AppTypography.bodySm),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Painter border putus-putus mengelilingi container.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final RRect rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    const double dashLength = 6;
    const double spaceLength = 4;

    final Path path = Path()..addRRect(rect);
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashLength),
          paint,
        );
        distance += dashLength + spaceLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}