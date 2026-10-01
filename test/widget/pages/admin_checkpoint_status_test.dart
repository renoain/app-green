// Widget test status aktif TPS admin (chip + aktifkan/nonaktifkan).
//
// Item nonaktif menampilkan chip Nonaktif + tombol Aktifkan; tekan
// Aktifkan memanggil repository lalu daftar memuat ulang.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/presentation/pages/admin_checkpoint_page.dart';
import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/checkpoints/domain/repositories/checkpoint_repository.dart';
import 'package:go_green/features/checkpoints/presentation/providers/checkpoint_provider.dart';

/// Repository checkpoint palsu: 1 aktif + 1 nonaktif, status bisa diubah.
class FakeStatusCheckpointRepository implements CheckpointRepository {
  final Map<String, bool> active = <String, bool>{'a1': true, 'n1': false};
  int activateCalls = 0;
  int deactivateCalls = 0;

  Checkpoint _item(String id, String name) {
    return Checkpoint(
      id: id,
      name: name,
      latitude: -6.2,
      longitude: 106.8,
      radius: 100,
      qrCode: 'CP-$id',
      isActive: active[id] ?? true,
      createdAt: DateTime(2026, 9, 20),
    );
  }

  List<Checkpoint> get items =>
      <Checkpoint>[_item('a1', 'TPS Aktif'), _item('n1', 'TPS Mati')];

  @override
  Future<List<Checkpoint>> getAllCheckpoints() async => items;

  @override
  Future<List<Checkpoint>> getActiveCheckpoints() async =>
      items.where((Checkpoint c) => c.isActive).toList();

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
    int? maxUses,
  }) async =>
      items.first;

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
    int? maxUses,
  }) async =>
      items.first;

  @override
  Future<void> deleteCheckpoint(String id) async {}

  @override
  Future<Checkpoint> insertCheckpoint({
    required String name,
    required double latitude,
    required double longitude,
    required int radius,
    String? address,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  }) async =>
      items.first;

  @override
  Future<Checkpoint> updateCheckpointRecord({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required int radius,
    String? address,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  }) async =>
      items.first;

  @override
  Future<void> deactivateCheckpoint(String id) async {
    deactivateCalls++;
    active[id] = false;
  }

  @override
  Future<void> activateCheckpoint(String id) async {
    activateCalls++;
    active[id] = true;
  }
}

void main() {
  testWidgets('item nonaktif tampil chip + tombol Aktifkan',
      (WidgetTester tester) async {
    final FakeStatusCheckpointRepository repo =
        FakeStatusCheckpointRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          checkpointRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminCheckpointPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TPS Aktif'), findsOneWidget);
    expect(find.text('TPS Mati'), findsOneWidget);
    expect(find.text(AppStrings.adminInactiveLabel), findsOneWidget);
    expect(find.text(AppStrings.adminActivate), findsOneWidget);
  });

  testWidgets('tekan Aktifkan mengaktifkan lalu reload daftar',
      (WidgetTester tester) async {
    final FakeStatusCheckpointRepository repo =
        FakeStatusCheckpointRepository();
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          checkpointRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminCheckpointPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(AppStrings.adminActivate));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.adminActivate));
    await tester.pumpAndSettle();

    // Dialog konfirmasi muncul; setujui.
    await tester.tap(find.text(AppStrings.adminActivate).last);
    await tester.pumpAndSettle();

    expect(repo.activateCalls, 1);
    expect(find.text(AppStrings.adminInactiveLabel), findsNothing);
  });
}
