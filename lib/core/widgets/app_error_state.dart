// Komponen AppErrorState sesuai docs/COMPONENT_LIBRARY.md (Feedback).
// Tampilan state kosong bergaya error dengan opsi retry, berbasis
// EmptyState agar visual konsisten.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../constants/app_strings.dart';
import 'feedback_widgets.dart';

/// State error untuk halaman yang gagal memuat data.
///
/// Menampilkan ikon, judul generik, pesan [message], dan tombol "Coba
/// Lagi" bila [onRetry] disediakan.
class AppErrorState extends StatelessWidget {
  /// Membuat state error.
  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  /// Pesan detail kesalahan.
  final String message;

  /// Aksi coba lagi. Null menyembunyikan tombol retry.
  final VoidCallback? onRetry;

  /// Ikon opsional; null memakai ikon peringatan default.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: icon ?? LucideIcons.circle_alert,
      title: AppStrings.genericError,
      message: message,
      actionText: onRetry == null ? null : AppStrings.retryButton,
      onAction: onRetry,
    );
  }
}