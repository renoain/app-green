// Implementasi repository reward admin (data).
//
// Meneruskan ke RewardRemoteDatasource; mapping model ke entity.

import '../../domain/entities/reward.dart';
import '../../domain/repositories/reward_repository.dart';
import '../datasources/reward_remote_datasource.dart';

/// Implementasi [RewardRepository] via Supabase.
class RewardRepositoryImpl implements RewardRepository {
  /// Membuat implementasi dengan datasource.
  const RewardRepositoryImpl(this._datasource);

  final RewardRemoteDatasource _datasource;

  @override
  Future<List<Reward>> getAllForAdmin() => _datasource.getAllForAdmin();

  @override
  Future<Reward> createReward({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) {
    return _datasource.createReward(
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }

  @override
  Future<Reward> updateReward({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) {
    return _datasource.updateReward(
      id: id,
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }

  @override
  Future<void> setRewardActive({
    required String id,
    required bool isActive,
  }) {
    return _datasource.setRewardActive(id: id, isActive: isActive);
  }

  @override
  Future<void> deleteReward(String id) => _datasource.deleteReward(id);
}
