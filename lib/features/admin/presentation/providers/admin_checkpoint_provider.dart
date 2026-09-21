// Provider kelola TPS admin (presentation).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../checkpoints/domain/usecases/generate_checkpoint_qr_usecase.dart';
import '../../../checkpoints/domain/usecases/generate_tps_code_usecase.dart';
import '../../../checkpoints/domain/usecases/manage_checkpoint_usecase.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import 'admin_providers.dart' show manageCheckpointUsecaseProvider;

/// Provider use case generate kode QR checkpoint.
final Provider<GenerateCheckpointQrUsecase>
    generateCheckpointQrUsecaseProvider =
    Provider<GenerateCheckpointQrUsecase>(
  (Ref ref) => GenerateCheckpointQrUsecase(
    ref.watch(checkpointRepositoryProvider),
  ),
);

/// Provider use case generate kode TPS wilayah.
final Provider<GenerateTpsCodeUsecase> generateTpsCodeUsecaseProvider =
    Provider<GenerateTpsCodeUsecase>(
  (Ref ref) => GenerateTpsCodeUsecase(
    ref.watch(checkpointRepositoryProvider),
  ),
);

/// Filter teks pencarian daftar TPS.
final StateProvider<String> adminCheckpointSearchProvider =
    StateProvider<String>((Ref ref) => '');

/// Filter wilayah daftar TPS (id atau null berarti semua).
final StateProvider<String?> adminCheckpointProvinceFilterProvider =
    StateProvider<String?>((Ref ref) => null);

/// Filter kota daftar TPS (id atau null berarti semua).
final StateProvider<String?> adminCheckpointCityFilterProvider =
    StateProvider<String?>((Ref ref) => null);

/// Filter kecamatan daftar TPS (id atau null berarti semua).
final StateProvider<String?> adminCheckpointDistrictFilterProvider =
    StateProvider<String?>((Ref ref) => null);

/// Notifier daftar TPS untuk admin (semua + cari + tambah + ubah + hapus).
class AdminCheckpointListNotifier
    extends StateNotifier<AsyncValue<List<Checkpoint>>> {
  /// Membuat notifier daftar TPS admin.
  AdminCheckpointListNotifier(this._usecase, this._ref)
      : super(const AsyncLoading<List<Checkpoint>>());

  final ManageCheckpointUsecase _usecase;
  final Ref _ref;

  /// Muat semua checkpoint.
  Future<void> loadAll() async {
    state = const AsyncLoading<List<Checkpoint>>();
    state = await AsyncValue.guard<List<Checkpoint>>(
      () => _ref.read(checkpointRepositoryProvider).getAllCheckpoints(),
    );
  }

  /// Daftar tersaring query pencarian + filter wilayah.
  List<Checkpoint> filtered(
    String query, {
    String? provinceCode,
    String? cityCode,
    String? districtCode,
  }) {
    final List<Checkpoint> all = state.maybeWhen(
      data: (List<Checkpoint> value) => value,
      orElse: () => <Checkpoint>[],
    );
    final String keyword = query.trim().toLowerCase();
    return all.where((Checkpoint item) {
      if (provinceCode != null &&
          provinceCode.isNotEmpty &&
          item.provinceCode != provinceCode) {
        return false;
      }
      if (cityCode != null &&
          cityCode.isNotEmpty &&
          item.cityCode != cityCode) {
        return false;
      }
      if (districtCode != null &&
          districtCode.isNotEmpty &&
          item.districtCode != districtCode) {
        return false;
      }
      if (keyword.isEmpty) return true;
      final String code = (item.code ?? '').toLowerCase();
      return item.name.toLowerCase().contains(keyword) ||
          code.contains(keyword);
    }).toList();
  }

  /// Tambah TPS baru (kode QR otomatis bila kosong).
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
    String? qr = qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim();
    qr ??= await _ref
        .read(generateCheckpointQrUsecaseProvider)
        .nextCode();
    final Checkpoint created = await _usecase.create(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qr,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
    await loadAll();
    return created;
  }

  /// Ubah TPS (kode QR otomatis bila kosong).
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
    String? qr = qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim();
    qr ??= await _ref
        .read(generateCheckpointQrUsecaseProvider)
        .nextCode();
    final Checkpoint updated = await _usecase.update(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qr,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
    await loadAll();
    return updated;
  }

  /// Nonaktifkan TPS.
  Future<void> deactivate(String id) async {
    await _usecase.deactivate(id);
    await loadAll();
  }
}

/// Provider state daftar TPS admin.
final StateNotifierProvider<AdminCheckpointListNotifier,
        AsyncValue<List<Checkpoint>>> adminCheckpointListProvider =
    StateNotifierProvider<AdminCheckpointListNotifier,
        AsyncValue<List<Checkpoint>>>(
  (Ref ref) => AdminCheckpointListNotifier(
    ref.watch(manageCheckpointUsecaseProvider),
    ref,
  ),
);
