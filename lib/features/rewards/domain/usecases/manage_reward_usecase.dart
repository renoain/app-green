// Use case kelola reward untuk admin (domain). Validasi bisnis tinggal di domain agar widget tetap tipis.

import '../../../../core/constants/app_strings.dart';
import '../entities/reward.dart';
import '../repositories/reward_repository.dart';

/// Exception validasi form reward; [message] aman tampil ke user.
class RewardValidationException implements Exception {
  const RewardValidationException(this.message);

  /// Pesan kesalahan.
  final String message;

  @override
  String toString() => message;
}

/// Use case tambah/ubah/hapus reward oleh admin.
class ManageRewardUsecase {
  const ManageRewardUsecase(this._repository);

  final RewardRepository _repository;

  /// Validasi input form reward.
  void validateInput({
    required String name,
    required int pointsCost,
    required int stock,
  }) {
    if (name.trim().isEmpty) {
      throw RewardValidationException(
        AppStrings.adminRewardNameEmpty,
      );
    }
    if (pointsCost <= 0) {
      throw RewardValidationException(
        AppStrings.adminRewardCostInvalid,
      );
    }
    if (stock < 0) {
      throw RewardValidationException(
        AppStrings.adminRewardStockInvalid,
      );
    }
  }

  /// Tambah reward setelah validasi.
  Future<Reward> create({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    validateInput(name: name, pointsCost: pointsCost, stock: stock);
    return _repository.createReward(
      name: name.trim(),
      description: _cleanText(description),
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: _cleanText(imageUrl),
      isActive: isActive,
    );
  }

  /// Ubah reward setelah validasi.
  Future<Reward> update({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    validateInput(name: name, pointsCost: pointsCost, stock: stock);
    return _repository.updateReward(
      id: id,
      name: name.trim(),
      description: _cleanText(description),
      pointsCost: pointsCost,
      stock: stock,
      imageUrl: _cleanText(imageUrl),
      isActive: isActive,
    );
  }

  /// Normalisasi teks opsional (kosong menjadi null).
  String? _cleanText(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Ubah status aktif reward.
  Future<void> setActive({required String id, required bool isActive}) {
    return _repository.setRewardActive(id: id, isActive: isActive);
  }

  /// Hapus reward.
  Future<void> delete(String id) => _repository.deleteReward(id);
}
