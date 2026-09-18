// Provider data reward.
//
// Menyediakan datasource dan notifier daftar reward + pengajuan penukaran
// agar halaman Poin & Reward bisa memuat data tanpa akses langsung ke data
// layer.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/reward.dart';
import '../../data/datasources/reward_remote_datasource.dart';

/// Provider data source reward.
final Provider<RewardRemoteDatasource> rewardRemoteDatasourceProvider =
    Provider<RewardRemoteDatasource>(
  (Ref ref) => RewardRemoteDatasource(),
);

/// Notifier daftar reward aktif.
class RewardNotifier extends StateNotifier<AsyncValue<List<Reward>>> {
  /// Membuat notifier dengan data source yang di-inject.
  RewardNotifier(this._datasource) : super(const AsyncLoading<List<Reward>>());

  final RewardRemoteDatasource _datasource;

  /// Memuat daftar reward aktif.
  Future<void> load() async {
    state = const AsyncLoading<List<Reward>>();
    state = await AsyncValue.guard<List<Reward>>(
      () => _datasource.getAllRewards(),
    );
  }

  /// Mengajukan penukaran reward untuk user.
  Future<String> redeem({
    required String userId,
    required String rewardId,
  }) {
    return _datasource.redeemReward(userId: userId, rewardId: rewardId);
  }
}

/// Provider state daftar reward aktif.
final StateNotifierProvider<RewardNotifier, AsyncValue<List<Reward>>>
    rewardNotifierProvider =
    StateNotifierProvider<RewardNotifier, AsyncValue<List<Reward>>>(
  (Ref ref) => RewardNotifier(ref.watch(rewardRemoteDatasourceProvider)),
);