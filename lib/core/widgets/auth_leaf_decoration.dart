// Dekorasi latar halaman autentikasi (Login/Register) bertema daun.
//
// Menghadirkan lingkaran lembut dan ikon daun di sudut layar agar
// halaman tidak polos, meniru nuansa ilustrasi daun pada referensi
// assets/images/ref/login_leaves.png. Warna memakai token tema, bukan
// hardcode.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../theme/app_colors.dart';

/// Dekorasi latar (background) halaman autentikasi Go Green.
///
/// Dipakai sebagai lapisan bawah dalam [Stack] halaman Login/Register;
/// konten halaman ditulis di atasnya.
class AuthLeafDecoration extends StatelessWidget {
  /// Membuat dekorasi latar autentikasi.
  const AuthLeafDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: <Widget>[
        Positioned(
          top: -72,
          right: -72,
          child: _AuthLeafOrb(
            size: 216,
            color: AppColors.secondaryContainer,
          ),
        ),
        Positioned(
          top: -56,
          left: -56,
          child: _AuthLeafOrb(
            size: 160,
            color: AppColors.tertiaryLight,
          ),
        ),
        Positioned(
          left: -88,
          bottom: 80,
          child: _AuthLeafOrb(
            size: 128,
            color: AppColors.surfaceDim,
          ),
        ),
      ],
    );
  }
}

/// Ilustrasi daun di pojok kanan bawah halaman autentikasi.
///
/// Dipakai sebagai aksen dekoratif di akhir konten, mengikuti contoh
/// "daun di kanan bawah" pada kode login referensi.
class AuthLeafSprig extends StatelessWidget {
  /// Membuat ilustrasi daun pojok kanan bawah.
  const AuthLeafSprig({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 92,
      height: 170,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 8,
            child: Icon(
              LucideIcons.leaf,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            top: 72,
            left: 0,
            child: Icon(
              LucideIcons.leaf,
              size: 48,
              color: AppColors.secondary,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 20,
            child: Icon(
              LucideIcons.leaf,
              size: 56,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lingkaran lembut dengan ikon daun samar di tengahnya.
class _AuthLeafOrb extends StatelessWidget {
  const _AuthLeafOrb({required this.size, required this.color});

  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          LucideIcons.leaf,
          size: size * 0.5,
          color: AppColors.primary.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}