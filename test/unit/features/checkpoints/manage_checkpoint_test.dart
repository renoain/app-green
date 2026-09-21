// Unit test validasi kelola checkpoint admin (ManageCheckpointUsecase).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/checkpoints/domain/repositories/checkpoint_repository.dart';
import 'package:go_green/features/checkpoints/domain/usecases/manage_checkpoint_usecase.dart';

/// Repository palsu untuk test validasi (tanpa Supabase).
class FakeCheckpointRepository implements CheckpointRepository {
  int createCalls = 0;

  @override
  Future<Checkpoint> createCheckpoint({
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
    createCalls++;
    return Checkpoint(
      id: 'new-id',
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
      createdAt: DateTime(2026, 9, 20),
    );
  }

  @override
  Future<void> deleteCheckpoint(String id) async {}

  @override
  Future<Checkpoint> insertCheckpoint({
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
  }) =>
      createCheckpoint(
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        qrCode: qrCode,
      );

  @override
  Future<Checkpoint> updateCheckpointRecord({
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
  }) =>
      updateCheckpoint(
        id: id,
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        qrCode: qrCode,
      );

  @override
  Future<void> deactivateCheckpoint(String id) => deleteCheckpoint(id);

  @override
  Future<List<Checkpoint>> getAllCheckpoints() async => <Checkpoint>[];

  @override
  Future<Checkpoint?> getCheckpointById(String id) async => null;

  @override
  Future<Checkpoint?> getCheckpointByQrCode(String qrCode) async => null;

  @override
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  }) async =>
      <Checkpoint>[];

  @override
  Future<Checkpoint> updateCheckpoint({
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
    return Checkpoint(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      createdAt: DateTime(2026, 9, 20),
    );
  }
}

void main() {
  group('ManageCheckpointUsecase.validateInput', () {
    test('nama kosong ditolak tanpa memanggil repository', () async {
      final FakeCheckpointRepository repository = FakeCheckpointRepository();
      final ManageCheckpointUsecase usecase =
          ManageCheckpointUsecase(repository);

      await expectLater(
        usecase.create(
          name: '  ',
          latitude: -6.2,
          longitude: 106.8,
          radius: 100,
        ),
        throwsA(isA<CheckpointValidationException>()),
      );
      expect(repository.createCalls, 0);
    });

    test('latitude di luar -90 sampai 90 ditolak', () {
      final ManageCheckpointUsecase usecase =
          ManageCheckpointUsecase(FakeCheckpointRepository());
      expect(
        () => usecase.validateInput(
          name: 'TPS A',
          latitude: -91,
          longitude: 106.8,
          radius: 100,
        ),
        throwsA(isA<CheckpointValidationException>()),
      );
    });

    test('radius nol ditolak', () {
      final ManageCheckpointUsecase usecase =
          ManageCheckpointUsecase(FakeCheckpointRepository());
      expect(
        () => usecase.validateInput(
          name: 'TPS A',
          latitude: -6.2,
          longitude: 106.8,
          radius: 0,
        ),
        throwsA(isA<CheckpointValidationException>()),
      );
    });

    test('input valid memanggil repository', () async {
      final FakeCheckpointRepository repository = FakeCheckpointRepository();
      final ManageCheckpointUsecase usecase =
          ManageCheckpointUsecase(repository);

      final Checkpoint created = await usecase.create(
        name: 'TPS A',
        latitude: -6.2,
        longitude: 106.8,
        radius: 100,
      );
      expect(created.name, 'TPS A');
      expect(repository.createCalls, 1);
    });
  });
}
