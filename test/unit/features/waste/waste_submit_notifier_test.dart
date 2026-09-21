// Unit test WasteSubmitNotifier (pengiriman bukti buang sampah).

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/waste/domain/entities/waste_log.dart';
import 'package:go_green/features/waste/domain/repositories/waste_repository.dart';
import 'package:go_green/features/waste/domain/usecases/calculate_points_usecase.dart';
import 'package:go_green/features/waste/domain/usecases/submit_waste_usecase.dart';
import 'package:go_green/features/waste/domain/usecases/validate_photo_usecase.dart';
import 'package:go_green/features/waste/presentation/providers/waste_provider.dart';

/// Repository palsu: sukses kecuali [duplicateHash] true.
class FakeWasteRepository implements WasteRepository {
  FakeWasteRepository({this.duplicateHash = false});

  final bool duplicateHash;

  @override
  Future<String> uploadPhoto({
    required String fileName,
    required Uint8List bytes,
  }) async =>
      'stored/$fileName';

  @override
  Future<WasteLog> insertWasteLog({
    required String userId,
    String? checkpointId,
    required WasteCategory category,
    required String photoUrl,
    required String hash,
    double? latitude,
    double? longitude,
    WasteSource source = WasteSource.manual,
  }) async {
    final DateTime now = DateTime.utc(2026, 9, 18);
    return WasteLog(
      id: 'log-1',
      userId: userId,
      checkpointId: checkpointId,
      category: category,
      photoUrl: photoUrl,
      hash: hash,
      latitude: latitude,
      longitude: longitude,
      serverTimestamp: now,
      status: WasteLogStatus.pending,
      source: source,
      createdAt: now,
    );
  }

  @override
  Future<List<WasteLog>> getWasteLogs(String userId) async =>
      <WasteLog>[];

  @override
  Future<List<WasteLog>> getPendingWasteLogs() async => <WasteLog>[];

  @override
  Future<WasteLog> verifyWasteLog({
    required String id,
    required WasteLogStatus status,
    required String verifiedBy,
    String? notes,
  }) async =>
      throw UnimplementedError();

  @override
  Future<WasteLog> approveWasteLog({
    required String id,
    required String verifiedBy,
  }) async =>
      throw UnimplementedError();

  @override
  Future<WasteLog> rejectWasteLog({
    required String id,
    required String verifiedBy,
    required String reason,
  }) async =>
      throw UnimplementedError();

  @override
  Future<String> getPhotoSignedUrl(String path) async => 'signed/$path';

  @override
  Future<bool> checkDuplicateHash(String hash) async => duplicateHash;

  @override
  Future<int> countTodayWasteLogs(String userId) async => 0;
}

Checkpoint _checkpoint() {
  return Checkpoint(
    id: 'cp-1',
    name: 'TPS Kelurahan',
    latitude: -6.2,
    longitude: 106.816667,
    radius: 100,
    createdAt: DateTime.utc(2026, 9, 18),
  );
}

WasteSubmitNotifier _notifier({bool duplicateHash = false}) {
  final FakeWasteRepository repo =
      FakeWasteRepository(duplicateHash: duplicateHash);
  final ValidatePhotoUsecase validate = ValidatePhotoUsecase(
    repo,
    distanceCalculator: (a, b, c, d) => 10,
  );
  final SubmitWasteUsecase usecase = SubmitWasteUsecase(
    wasteRepository: repo,
    validatePhoto: validate,
    calculatePoints: const CalculatePointsUsecase(),
  );
  return WasteSubmitNotifier(usecase);
}

/// Membangun usecase dengan pencatat poin palsu untuk verifikasi
/// pemanggilan pencatatan earn.
SubmitWasteUsecase _usecaseWithRecorder(
  List<({String userId, int amount, String referenceId})> calls,
) {
  final FakeWasteRepository repo = FakeWasteRepository();
  return SubmitWasteUsecase(
    wasteRepository: repo,
    validatePhoto: ValidatePhotoUsecase(
      repo,
      distanceCalculator: (a, b, c, d) => 10,
    ),
    calculatePoints: const CalculatePointsUsecase(),
    recordEarnPoints: ({
      required String userId,
      required int amount,
      required String referenceId,
      required String description,
    }) async {
      calls.add((userId: userId, amount: amount, referenceId: referenceId));
    },
  );
}

void main() {
  group('WasteSubmitNotifier.submit', () {
    test('sukses menyimpan log dan menghitung poin', () async {
      final WasteSubmitNotifier notifier = _notifier();
      expect(notifier.state, isA<AsyncData<SubmitWasteResult?>>());

      await notifier.submit(
        userId: 'user-1',
        checkpoint: _checkpoint(),
        category: WasteCategory.anorganik,
        photoBytes: Uint8List.fromList(<int>[1, 2, 3]),
        latitude: -6.2,
        longitude: 106.816667,
      );

      final AsyncValue<SubmitWasteResult?> state = notifier.state;
      expect(state.hasError, isFalse);
      expect(state.value?.log.id, 'log-1');
      expect(state.value?.estimatedPoints, 30);
    });

    test('gagal saat hash duplikat', () async {
      final WasteSubmitNotifier notifier =
          _notifier(duplicateHash: true);

      await notifier.submit(
        userId: 'user-1',
        checkpoint: _checkpoint(),
        category: WasteCategory.organik,
        photoBytes: Uint8List.fromList(<int>[1, 2, 3]),
        latitude: -6.2,
        longitude: 106.816667,
      );

      expect(notifier.state.hasError, isTrue);
    });

    test('reset kembali ke idle', () async {
      final WasteSubmitNotifier notifier = _notifier();
      await notifier.submit(
        userId: 'user-1',
        checkpoint: _checkpoint(),
        category: WasteCategory.organik,
        photoBytes: Uint8List.fromList(<int>[1, 2, 3]),
        latitude: -6.2,
        longitude: 106.816667,
      );
      notifier.reset();
      expect(notifier.state.valueOrNull, isNull);
    });
  });

  group('SubmitWasteUsecase.recordEarnPoints', () {
    test('mencatat poin earn dengan referensi log', () async {
      final List<({String userId, int amount, String referenceId})> calls =
          <({String userId, int amount, String referenceId})>[];
      final SubmitWasteUsecase usecase = _usecaseWithRecorder(calls);

      final SubmitWasteResult result = await usecase.execute(
        userId: 'user-1',
        checkpoint: _checkpoint(),
        category: WasteCategory.anorganik,
        photoBytes: Uint8List.fromList(<int>[4, 5, 6]),
        latitude: -6.2,
        longitude: 106.816667,
      );

      expect(calls, hasLength(1));
      expect(calls.single.userId, 'user-1');
      expect(calls.single.amount, 30);
      expect(calls.single.referenceId, result.log.id);
    });

    test('tanpa pencatat berarti hanya estimasi', () async {
      final FakeWasteRepository repo = FakeWasteRepository();
      final SubmitWasteUsecase usecase = SubmitWasteUsecase(
        wasteRepository: repo,
        validatePhoto: ValidatePhotoUsecase(
          repo,
          distanceCalculator: (a, b, c, d) => 10,
        ),
        calculatePoints: const CalculatePointsUsecase(),
      );

      final SubmitWasteResult result = await usecase.execute(
        userId: 'user-1',
        checkpoint: _checkpoint(),
        category: WasteCategory.organik,
        photoBytes: Uint8List.fromList(<int>[7, 8, 9]),
        latitude: -6.2,
        longitude: 106.816667,
      );

      expect(result.estimatedPoints, 25);
    });
  });
}
