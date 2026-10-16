// Pemetaan nama reward ke ikon (dipakai bersama oleh daftar dan detail reward).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

/// Ikon Lucide yang paling cocok untuk nama reward [name].
///
/// Dipakai bersama oleh halaman daftar poin dan detail reward agar kategori
/// reward tampil dengan ikon yang sama di dua tempat.
IconData rewardIconForName(String name) {
  final String lower = name.toLowerCase();
  if (lower.contains('voucher') || lower.contains('belanja')) {
    return LucideIcons.shopping_bag;
  }
  if (lower.contains('wallet') ||
      lower.contains('saldo') ||
      lower.contains('e-wallet') ||
      lower.contains('ewallet')) {
    return LucideIcons.wallet;
  }
  if (lower.contains('donasi') || lower.contains('donation')) {
    return LucideIcons.heart_handshake;
  }
  return LucideIcons.gift;
}