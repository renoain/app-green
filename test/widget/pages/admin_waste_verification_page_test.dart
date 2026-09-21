// Widget test halaman verifikasi waste admin (daftar + filter).

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/presentation/pages/admin_waste_verification_page.dart';
import 'package:go_green/features/waste/domain/entities/waste_log.dart';
import 'package:go_green/features/waste/domain/repositories/waste_repository.dart';
import 'package:go_green/features/waste/presentation/providers/waste_provider.dart';

WasteLog _log(String id, DateTime createdAt) {
  return WasteLog(
    id: id,
    userId: 'user-1',
    checkpointId: 'cp-1',
    category: WasteCategory.organik,
    serverTimestamp: createdAt,
    status: WasteLogStatus.pending,
    createdAt: createdAt,
    submitterName: 'warga_hijau',
  );
}

/// Repository waste palsu untuk test widget (tanpa Supabase).
class FakeAdminWasteRepository implements WasteRepository {
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
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<WasteLog>> getWasteLogs(String userId) async =>
      <WasteLog>[];

  @override
  Future<List<WasteLog>> getPendingWasteLogs() async => <WasteLog>[
        _log('log-today', DateTime.now()),
        _log('log-old', DateTime(2026, 9, 1)),
      ];

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
  Future<bool> checkDuplicateHash(String hash) async => false;

  @override
  Future<int> countTodayWasteLogs(String userId) async => 0;
}

Widget _testApp() {
  return ProviderScope(
    overrides: <Override>[
      wasteRepositoryProvider.overrideWithValue(
        FakeAdminWasteRepository(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const AdminWasteVerificationPage(),
    ),
  );
}

void main() {
  testWidgets('menampilkan antrean pending', (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('warga_hijau'), findsNWidgets(2));
  });

  testWidgets('filter hari ini menyembunyikan log lama',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hari Ini'));
    await tester.pumpAndSettle();

    expect(find.text('warga_hijau'), findsOneWidget);
  });
}
