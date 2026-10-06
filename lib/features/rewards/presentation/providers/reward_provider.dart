// Provider data reward.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/redemption.dart';
import '../../domain/entities/reward.dart';
import '../../data/datasources/reward_dummy_datasource.dart';
import '../../data/datasources/reward_remote_datasource.dart';
import '../../../../core/constants/app_env.dart';

/// Provider data source reward (dummy saat [AppEnv.useDummyApi] true).
final Provider<RewardRemoteDatasource> rewardRemoteDatasourceProvider =
    Provider<RewardRemoteDatasource>(
  (Ref ref) => AppEnv.useDummyApi
      ? RewardDummyDatasource()
      : RewardRemoteDatasource(),
);

/// Notifier daftar reward aktif.
class RewardNotifier extends StateNotifier<AsyncValue<List<Reward>>> {
  RewardNotifier(this._datasource) : super(const AsyncLoading<List<Reward>>());

  final RewardRemoteDatasource _datasource;

  /// Memuat daftar reward aktif.
  Future<void> load() async {
    state = const AsyncLoading<List<Reward>>();
    state = await AsyncValue.guard<List<Reward>>(
      () => _datasource.getAllRewards(),
    );
  }

  /// Mengajukan penukaran reward untuk user. Mengembalikan voucher code.
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

/// Notifier daftar voucher (redemption) milik user.
class UserVouchersNotifier
    extends StateNotifier<AsyncValue<List<Redemption>>> {
  UserVouchersNotifier(this._datasource)
      : super(const AsyncLoading<List<Redemption>>());

  final RewardRemoteDatasource _datasource;

  /// Memuat daftar penukaran milik [userId].
  Future<void> load({required String userId}) async {
    state = const AsyncLoading<List<Redemption>>();
    state = await AsyncValue.guard<List<Redemption>>(
      () => _datasource.getUserRedemptions(userId),
    );
  }
}

/// Provider state voucher milik user.
final StateNotifierProvider<UserVouchersNotifier,
        AsyncValue<List<Redemption>>> userVouchersProvider =
    StateNotifierProvider<UserVouchersNotifier,
        AsyncValue<List<Redemption>>>(
  (Ref ref) =>
      UserVouchersNotifier(ref.watch(rewardRemoteDatasourceProvider)),
);
