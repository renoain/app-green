// Unit test generate kode TPS wilayah (GenerateTpsCodeUsecase).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/checkpoints/domain/repositories/checkpoint_repository.dart';
import 'package:go_green/features/checkpoints/domain/usecases/generate_tps_code_usecase.dart';

/// Repository palsu berisi daftar kode existing (tanpa Supabase).
class FakeRegionCheckpointRepository implements CheckpointRepository {
  FakeRegionCheckpointRepository(this.items);

  final List<Checkpoint> items;

  Checkpoint _stub({
    String? code,
    String? cityCode,
    String? districtCode,
  }) {
    return Checkpoint(
      id: 'id-$code',
      name: 'TPS',
      latitude: -7.2,
      longitude: 112.7,
      radius: 100,
      code: code,
      cityCode: cityCode,
      districtCode: districtCode,
      createdAt: DateTime(2026, 9, 21),
    );
  }

  @override
  Future<List<Checkpoint>> getAllCheckpoints() async => items;

  @override
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  }) async =>
      items;

  @override
  Future<Checkpoint?> getCheckpointById(String id) async => null;

  @override
  Future<Checkpoint?> getCheckpointByQrCode(String qrCode) async => null;

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
  }) async =>
      _stub(code: code, cityCode: cityCode, districtCode: districtCode);

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
  }) async =>
      _stub(code: code, cityCode: cityCode, districtCode: districtCode);

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
  }) async =>
      _stub(code: code, cityCode: cityCode, districtCode: districtCode);

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
  }) async =>
      _stub(code: code, cityCode: cityCode, districtCode: districtCode);

  @override
  Future<void> deactivateCheckpoint(String id) async {}
}

Checkpoint _tps(String code, {String? city, String? district}) {
  return Checkpoint(
    id: 'id-$code',
    name: 'TPS',
    latitude: -7.2,
    longitude: 112.7,
    radius: 100,
    code: code,
    cityCode: city,
    districtCode: district,
    createdAt: DateTime(2026, 9, 21),
  );
}

void main() {
  group('GenerateTpsCodeUsecase.abbreviate', () {
    test('membuang awalan KOTA dan mengambil 3 huruf', () {
      expect(
        GenerateTpsCodeUsecase.abbreviate('KOTA SURABAYA'),
        'SUR',
      );
    });

    test('membuang awalan KECAMATAN', () {
      expect(
        GenerateTpsCodeUsecase.abbreviate('KECAMATAN KETINTANG'),
        'KET',
      );
    });

    test('nama pendek di-pad menjadi 3 huruf', () {
      expect(GenerateTpsCodeUsecase.abbreviate('Yo'), 'YOX');
    });
  });

  group('GenerateTpsCodeUsecase.nextCode', () {
    test('daftar kosong mulai dari 01', () async {
      final GenerateTpsCodeUsecase usecase = GenerateTpsCodeUsecase(
        FakeRegionCheckpointRepository(<Checkpoint>[]),
      );
      expect(
        await usecase.nextCode(
          cityName: 'KOTA SURABAYA',
          districtName: 'Ketintang',
        ),
        'SUR-KET-01',
      );
    });

    test('nomor lanjut dari kode se-wilayah terbesar', () async {
      final GenerateTpsCodeUsecase usecase = GenerateTpsCodeUsecase(
        FakeRegionCheckpointRepository(<Checkpoint>[
          _tps('SUR-KET-01'),
          _tps('SUR-KET-02'),
          _tps('SUR-WON-01'),
        ]),
      );
      expect(
        await usecase.nextCode(
          cityName: 'Surabaya',
          districtName: 'Ketintang',
        ),
        'SUR-KET-03',
      );
    });

    test('kode beda kota tidak ikut dihitung bila cityCode beda', () async {
      final GenerateTpsCodeUsecase usecase = GenerateTpsCodeUsecase(
        FakeRegionCheckpointRepository(<Checkpoint>[
          _tps('SUR-KET-05', city: '3579', district: '3579010'),
        ]),
      );
      expect(
        await usecase.nextCode(
          cityName: 'Surabaya',
          districtName: 'Ketintang',
          cityCode: '3578',
          districtCode: '3578010',
        ),
        'SUR-KET-01',
      );
    });
  });
}
