// Kontrak repository reward admin (domain). Abstraksi tulis katalog agar usecase tidak tergantung Supabase.

import '../entities/reward.dart';

/// Kontrak akses tulis katalog reward.
abstract class RewardRepository {
  /// Ambil semua reward (aktif + nonaktif) untuk admin.
  Future<List<Reward>> getAllForAdmin();

  /// Tambah reward baru.
  Future<Reward> createReward({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  });

  /// Ubah reward.
  Future<Reward> updateReward({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  });

  /// Ubah status aktif reward.
  Future<void> setRewardActive({required String id, required bool isActive});

  /// Hapus reward.
  Future<void> deleteReward(String id);
}
