// Komponen display sesuai docs/COMPONENT_LIBRARY.md (Display & List).
// Dikelompokkan dalam satu file: Avatar, StatItem, ListTileItem.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Avatar bulat dengan inisial nama, atau foto bila disediakan.
class Avatar extends StatelessWidget {
  /// Membuat avatar.
  const Avatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 48,
  });

  /// Nama pemilik avatar; dipakai untuk inisial.
  final String name;

  /// URL foto; bila null dipakai inisial.
  final String? imageUrl;

  /// Ukuran diameter avatar.
  final double size;

  String get _initials {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }
    final StringBuffer buffer = StringBuffer();
    buffer.write(parts.first[0].toUpperCase());
    if (parts.length > 1) {
      buffer.write(parts[1][0].toUpperCase());
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Widget fallback = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: AppTypography.labelLg.copyWith(
          color: AppColors.textOnPrimary,
          fontSize: size * 0.32,
        ),
      ),
    );

    if (imageUrl == null) {
      return fallback;
    }

    return ClipOval(
      child: Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, Object __, StackTrace? ___) => fallback,
      ),
    );
  }
}

/// Item statistik bernilai tunggal (poin, jumlah buang, dst).
class StatItem extends StatelessWidget {
  /// Membuat item statistik.
  const StatItem({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  /// Nilai statistik (sudah diformat).
  final String value;

  /// Label statistik.
  final String label;

  /// Ikon opsional di samping nilai.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(value, style: AppTypography.headlineLg),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.bodySm),
      ],
    );
  }
}

/// Baris menu/list dengan ikon dan trailing opsional.
class ListTileItem extends StatelessWidget {
  /// Membuat baris menu.
  const ListTileItem({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  /// Judul baris.
  final String title;

  /// Ikon utama.
  final IconData icon;

  /// Deskripsi opsional.
  final String? subtitle;

  /// Widget di ujung kanan; default chevron bila null dan onTap tersedia.
  final Widget? trailing;

  /// Aksi saat baris ditekan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: AppTypography.labelLg),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xs),
                      Text(subtitle!, style: AppTypography.bodySm),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              trailing ??
                  const Icon(
                    LucideIcons.chevron_right,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}