// Komponen CustomAppBar dan LoadingIndicator sesuai
// docs/COMPONENT_LIBRARY.md (Navigation, Feedback).

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// App bar custom aplikasi Go Green.
///
/// Memakai tema [ThemeData.appBarTheme]. Mendukung ikon leading,
/// callback leading, dan aksi di sisi kanan.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Membuat app bar custom.
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.onLeadingTap,
    this.actions,
  });

  /// Judul app bar.
  final String title;

  /// Ikon kiri (default: chevron-left dengan navigasi kembali otomatis).
  final IconData? leading;

  /// Callback saat ikon kiri ditekan. Default: pop/goBack.
  final VoidCallback? onLeadingTap;

  /// Aksi di sisi kanan app bar.
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleLeadingTap(BuildContext context) {
    if (onLeadingTap != null) {
      onLeadingTap!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTypography.headlineSm),
      leading: leading != null
          ? IconButton(
              onPressed: () => _handleLeadingTap(context),
              icon: Icon(leading),
            )
          : null,
      actions: actions,
    );
  }
}

/// Indikator loading aplikasi Go Green.
///
/// Dipakai untuk state loading di halaman atau bagian tertentu.
class LoadingIndicator extends StatelessWidget {
  /// Membuat indikator loading.
  const LoadingIndicator({
    super.key,
    this.size = 32,
    this.color = AppColors.primary,
  });

  /// Ukuran indikator.
  final double size;

  /// Warna indikator.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: color, strokeWidth: 3),
      ),
    );
  }
}