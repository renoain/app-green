// Unit test use case kelola reward admin.
//
// Validasi nama/harga/stok + delegasi create/update ke repository.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_green/features/rewards/domain/entities/reward.dart';
import 'package:go_green/features/rewards/domain/repositories/reward_repository.dart';
import 'package:go_green/features/rewards/domain/usecases/manage_reward_usecase.dart';

/// Repository palsu untuk test usecase.
class _FakeRewardRepository implements RewardRepository {
  int createCalls = 0;
  int updateCalls = 0;

  @override
  Future<List<Reward>> getAllForAdmin() async => <Reward>[];

  @override
  Future<Reward> createReward({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    createCalls++;
    return Reward(
      id: 'r1',
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: DateTime(2026, 9, 23),
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
  }) async {
    updateCalls++;
    return Reward(
      id: id,
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: DateTime(2026, 9, 23),
    );
  }

  @override
  Future<void> setRewardActive({
    required String id,
    required bool isActive,
  }) async {}

  @override
  Future<void> deleteReward(String id) async {}
}

void main() {
  test('nama kosong ditolak', () {
    final ManageRewardUsecase usecase =
        ManageRewardUsecase(_FakeRewardRepository());
    expect(
      () => usecase.validateInput(name: '  ', pointsCost: 100, stock: 1),
      throwsA(isA<RewardValidationException>()),
    );
  });

  test('harga nol ditolak', () {
    final ManageRewardUsecase usecase =
        ManageRewardUsecase(_FakeRewardRepository());
    expect(
      () => usecase.validateInput(name: 'Sembako', pointsCost: 0, stock: 1),
      throwsA(isA<RewardValidationException>()),
    );
  });

  test('stok negatif ditolak', () {
    final ManageRewardUsecase usecase =
        ManageRewardUsecase(_FakeRewardRepository());
    expect(
      () => usecase.validateInput(name: 'Sembako', pointsCost: 100, stock: -1),
      throwsA(isA<RewardValidationException>()),
    );
  });

  test('create valid memanggil repository sekali', () async {
    final _FakeRewardRepository repo = _FakeRewardRepository();
    final ManageRewardUsecase usecase = ManageRewardUsecase(repo);
    final Reward created = await usecase.create(
      name: '  Sembako  ',
      pointsCost: 300,
      stock: 5,
      isActive: true,
    );
    expect(repo.createCalls, 1);
    expect(created.name, 'Sembako');
  });

  test('update valid memanggil repository sekali', () async {
    final _FakeRewardRepository repo = _FakeRewardRepository();
    final ManageRewardUsecase usecase = ManageRewardUsecase(repo);
    await usecase.update(
      id: 'r1',
      name: 'Voucher',
      pointsCost: 500,
      stock: 0,
      isActive: false,
    );
    expect(repo.updateCalls, 1);
  });
}
