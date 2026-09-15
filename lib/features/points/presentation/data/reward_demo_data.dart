// Data reward demo untuk tahap placeholder.
//
// Akan diganti oleh layer data (repository + Supabase) saat terpasang.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';

/// Reward demo untuk daftar Poin & Reward dan halaman detail.
class RewardDemo {
  const RewardDemo({
    required this.id,
    required this.title,
    required this.description,
    required this.pointCost,
    required this.icon,
  });

  /// Identitas reward.
  final String id;

  /// Nama reward.
  final String title;

  /// Deskripsi reward.
  final String description;

  /// Harga reward dalam poin.
  final int pointCost;

  /// Ikon reward.
  final IconData icon;
}

/// Daftar reward demo aplikasi.
const List<RewardDemo> demoRewards = <RewardDemo>[
  RewardDemo(
    id: '1',
    title: AppStrings.rewardSembako,
    description: AppStrings.rewardSembakoDesc,
    pointCost: 300,
    icon: LucideIcons.gift,
  ),
  RewardDemo(
    id: '2',
    title: AppStrings.rewardVoucher,
    description: AppStrings.rewardVoucherDesc,
    pointCost: 500,
    icon: LucideIcons.shopping_bag,
  ),
  RewardDemo(
    id: '3',
    title: AppStrings.rewardWallet,
    description: AppStrings.rewardWalletDesc,
    pointCost: 150,
    icon: LucideIcons.wallet,
  ),
  RewardDemo(
    id: '4',
    title: AppStrings.rewardDonasi,
    description: AppStrings.rewardDonasiDesc,
    pointCost: 50,
    icon: LucideIcons.heart_handshake,
  ),
];