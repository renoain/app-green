// Provider kelola reward admin (presentation).
//
// Daftar semua reward (aktif + nonaktif) + tulis via ManageRewardUsecase.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../rewards/data/repositories/reward_repository_impl.dart';
import '../../../rewards/domain/entities/reward.dart';
import '../../../rewards/domain/repositories/reward_repository.dart';
import '../../../rewards/domain/usecases/manage_reward_usecase.dart';
import '../../../rewards/presentation/providers/reward_provider.dart';

/// Provider repository reward admin.
final Provider<RewardRepository> adminRewardRepositoryProvider =
    Provider<RewardRepository>(
  (Ref ref) => RewardRepositoryImpl(
    ref.watch(rewardRemoteDatasourceProvider),
  ),
);

/// Provider use case kelola reward admin.
final Provider<ManageRewardUsecase> manageRewardUsecaseProvider =
    Provider<ManageRewardUsecase>(
  (Ref ref) => ManageRewardUsecase(ref.watch(adminRewardRepositoryProvider)),
);

/// Notifier daftar reward untuk admin (semua + tulis).
class AdminRewardListNotifier
    extends StateNotifier<AsyncValue<List<Reward>>> {
  /// Membuat notifier admin reward.
  AdminRewardListNotifier(this._usecase, this._repository)
      : super(const AsyncLoading<List<Reward>>());

  final ManageRewardUsecase _usecase;
  final RewardRepository _repository;

  /// Muat semua reward (aktif + nonaktif).
  Future<void> loadAll() async {
    state = const AsyncLoading<List<Reward>>();
    state = await AsyncValue.guard<List<Reward>>(
      () => _repository.getAllForAdmin(),
    );
  }

  /// Tambah reward baru.
  Future<Reward> create({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    final Reward created = await _usecase.create(
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: imageUrl,
      isActive: isActive,
    );
    await loadAll();
    return created;
  }

  /// Ubah reward.
  Future<Reward> update({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    final Reward updated = await _usecase.update(
      id: id,
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: imageUrl,
      isActive: isActive,
    );
    await loadAll();
    return updated;
  }

  /// Ubah status aktif reward.
  Future<void> setActive({required String id, required bool isActive}) async {
    await _usecase.setActive(id: id, isActive: isActive);
    await loadAll();
  }

  /// Hapus reward.
  Future<void> remove(String id) async {
    await _usecase.delete(id);
    await loadAll();
  }
}

/// Provider state daftar reward admin.
final StateNotifierProvider<AdminRewardListNotifier,
        AsyncValue<List<Reward>>> adminRewardListProvider =
    StateNotifierProvider<AdminRewardListNotifier, AsyncValue<List<Reward>>>(
  (Ref ref) => AdminRewardListNotifier(
    ref.watch(manageRewardUsecaseProvider),
    ref.watch(adminRewardRepositoryProvider),
  ),
);
