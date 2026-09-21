// Use case kelola checkpoint untuk admin (domain).
//
// Validasi bisnis (nama, koordinat, radius) tinggal di domain agar widget
// tetap tipis. Murni Dart sehingga mudah diuji.

import '../../../../core/constants/app_strings.dart';
import '../entities/checkpoint.dart';
import '../repositories/checkpoint_repository.dart';

/// Exception validasi form checkpoint; [message] aman tampil ke user.
class CheckpointValidationException implements Exception {
  /// Membuat exception dengan pesan ramah user.
  const CheckpointValidationException(this.message);

  /// Pesan kesalahan.
  final String message;

  @override
  String toString() => message;
}

/// Use case tambah/ubah/hapus checkpoint oleh admin.
class ManageCheckpointUsecase {
  /// Membuat use case.
  const ManageCheckpointUsecase(this._repository);

  final CheckpointRepository _repository;

  /// Validasi input form checkpoint.
  void validateInput({
    required String name,
    required double latitude,
    required double longitude,
    required int radius,
  }) {
    if (name.trim().isEmpty) {
      throw const CheckpointValidationException(
        AppStrings.adminCheckpointNameEmpty,
      );
    }
    if (latitude < -90 || latitude > 90) {
      throw const CheckpointValidationException(
        AppStrings.adminCheckpointLatInvalid,
      );
    }
    if (longitude < -180 || longitude > 180) {
      throw const CheckpointValidationException(
        AppStrings.adminCheckpointLngInvalid,
      );
    }
    if (radius <= 0) {
      throw const CheckpointValidationException(
        AppStrings.adminCheckpointRadiusInvalid,
      );
    }
  }

  /// Tambah checkpoint baru setelah validasi.
  Future<Checkpoint> create({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) async {
    validateInput(
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
    return _repository.createCheckpoint(
      name: name.trim(),
      address: address?.trim().isEmpty ?? true ? null : address?.trim(),
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
      code: code?.trim().isEmpty ?? true ? null : code?.trim(),
      provinceCode: _cleanCode(provinceCode),
      cityCode: _cleanCode(cityCode),
      districtCode: _cleanCode(districtCode),
      subdistrict:
          subdistrict?.trim().isEmpty ?? true ? null : subdistrict?.trim(),
    );
  }

  /// Ubah checkpoint setelah validasi.
  Future<Checkpoint> update({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) async {
    validateInput(
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
    return _repository.updateCheckpoint(
      id: id,
      name: name.trim(),
      address: address?.trim().isEmpty ?? true ? null : address?.trim(),
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
      code: code?.trim().isEmpty ?? true ? null : code?.trim(),
      provinceCode: _cleanCode(provinceCode),
      cityCode: _cleanCode(cityCode),
      districtCode: _cleanCode(districtCode),
      subdistrict:
          subdistrict?.trim().isEmpty ?? true ? null : subdistrict?.trim(),
    );
  }

  /// Normalisasi kode wilayah (kosong menjadi null).
  String? _cleanCode(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Hapus checkpoint.
  Future<void> delete(String id) => _repository.deleteCheckpoint(id);

  /// Nonaktifkan checkpoint (tanpa kolom is_active = hapus permanen).
  Future<void> deactivate(String id) =>
      _repository.deactivateCheckpoint(id);
}
