// Widget test halaman kelola TPS admin (daftar + cari).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/presentation/pages/admin_checkpoint_page.dart';
import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/checkpoints/domain/repositories/checkpoint_repository.dart';
import 'package:go_green/features/checkpoints/presentation/providers/checkpoint_provider.dart';

/// Repository checkpoint palsu untuk test widget (tanpa Supabase).
class FakeAdminCheckpointRepository implements CheckpointRepository {
  final List<Checkpoint> items = <Checkpoint>[
    Checkpoint(
      id: 'cp-1',
      name: 'TPS Kelurahan',
      latitude: -6.2,
      longitude: 106.816667,
      radius: 100,
      qrCode: 'CP-001',
      createdAt: DateTime(2026, 9, 20),
    ),
    Checkpoint(
      id: 'cp-2',
      name: 'Bank Sampah Berseri',
      latitude: -6.2005,
      longitude: 106.8169,
      radius: 100,
      qrCode: 'CP-002',
      createdAt: DateTime(2026, 9, 20),
    ),
  ];

  @override
  Future<List<Checkpoint>> getAllCheckpoints() async => items;

  @override
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  }) async =>
      items;

  @override
  Future<Checkpoint?> getCheckpointById(String id) async {
    for (final Checkpoint item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

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
  }) async =>
      items.first;

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
      items.first;

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
      items.first;

  @override
  Future<void> deactivateCheckpoint(String id) async {}
}

Widget _testApp() {
  return ProviderScope(
    overrides: <Override>[
      checkpointRepositoryProvider.overrideWithValue(
        FakeAdminCheckpointRepository(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const AdminCheckpointPage(),
    ),
  );
}

void main() {
  testWidgets('menampilkan daftar TPS dari repository',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('TPS Kelurahan'), findsOneWidget);
    expect(find.text('Bank Sampah Berseri'), findsOneWidget);
  });

  testWidgets('pencarian menyaring daftar TPS', (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'bank');
    await tester.pumpAndSettle();

    expect(find.text('TPS Kelurahan'), findsNothing);
    expect(find.text('Bank Sampah Berseri'), findsOneWidget);
  });
}
