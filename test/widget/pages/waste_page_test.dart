// Widget test halaman buang sampah (waste).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/display_widgets.dart';
import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/checkpoints/domain/repositories/checkpoint_repository.dart';
import 'package:go_green/features/checkpoints/presentation/providers/checkpoint_provider.dart';
import 'package:go_green/features/scan/presentation/pages/scan_page.dart';
import 'package:go_green/features/waste/presentation/pages/capture_photo_page.dart';
import 'package:go_green/features/waste/presentation/pages/waste_page.dart';

const MethodChannel _permissionChannel =
    MethodChannel('flutter.baseflow.com/permissions/methods');

/// Repository checkpoint palsu untuk test widget (tanpa Supabase).
class FakeCheckpointRepository implements CheckpointRepository {
  FakeCheckpointRepository({List<Checkpoint>? checkpoints})
      : checkpoints = checkpoints ?? _defaultCheckpoints;

  final List<Checkpoint> checkpoints;

  static List<Checkpoint> get _defaultCheckpoints {
    final DateTime now = DateTime(2026, 9, 18);
    return <Checkpoint>[
      Checkpoint(
        id: 'demo-1',
        name: AppStrings.wasteCheckpointTps,
        address: AppStrings.wasteCheckpointTpsAddress,
        latitude: -6.200000,
        longitude: 106.816667,
        radius: 100,
        createdAt: now,
      ),
      Checkpoint(
        id: 'demo-2',
        name: AppStrings.wasteCheckpointBank,
        address: AppStrings.wasteCheckpointBankAddress,
        latitude: -6.200500,
        longitude: 106.816900,
        radius: 100,
        createdAt: now,
      ),
    ];
  }

  @override
  Future<List<Checkpoint>> getAllCheckpoints() async => checkpoints;

  @override
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  }) async =>
      checkpoints;

  @override
  Future<Checkpoint?> getCheckpointById(String id) async {
    for (final Checkpoint item in checkpoints) {
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
      checkpoints.first;

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
      checkpoints.first;

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
      checkpoints.first;

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
      checkpoints.first;

  @override
  Future<void> deactivateCheckpoint(String id) async {}
}

Widget _wasteApp({List<Override> overrides = const <Override>[]}) {
  return ProviderScope(
    overrides: <Override>[
      checkpointRepositoryProvider.overrideWithValue(
        FakeCheckpointRepository(),
      ),
      ...overrides,
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const WastePage(),
    ),
  );
}

void main() {
  testWidgets('menampilkan checkpoint tanpa kategori dan tombol ambil foto',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wasteApp());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.wasteTitle), findsOneWidget);
    expect(find.text(AppStrings.wasteCheckpointTps), findsOneWidget);
    expect(find.text(AppStrings.wasteCheckpointBank), findsOneWidget);
    expect(find.text(AppStrings.wasteCategoryTitle), findsNothing);
    expect(find.text(AppStrings.takePhotoButton), findsOneWidget);
  });

  testWidgets('memilih checkpoint kedua menandai kartu tersebut',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wasteApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.wasteCheckpointBank));
    await tester.pump();

    final Finder bankTile = find.widgetWithText(
      ListTileItem,
      AppStrings.wasteCheckpointBank,
    );
    expect(
      find.descendant(
        of: bankTile,
        matching: find.byIcon(LucideIcons.check),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tombol ambil foto membuka halaman kamera',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      _permissionChannel,
      (MethodCall call) async {
        if (call.method != 'requestPermissions') return null;
        final List<dynamic> requested = call.arguments as List<dynamic>;
        return <int, int>{
          for (final Object value in requested) value as int: 0, // denied
        };
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          checkpointRepositoryProvider.overrideWithValue(
            FakeCheckpointRepository(),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/waste',
            routes: appRoutes,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(AppStrings.takePhotoButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(AppStrings.takePhotoButton));
    await tester.pumpAndSettle();

    expect(find.byType(CapturePhotoPage), findsOneWidget);
    expect(find.text(AppStrings.capturePermissionDenied), findsOneWidget);
  });

  testWidgets('link scan QR membuka halaman scan',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          checkpointRepositoryProvider.overrideWithValue(
            FakeCheckpointRepository(),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/waste',
            routes: appRoutes,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(AppStrings.wasteScanHint),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(AppStrings.wasteScanHint));
    await tester.pumpAndSettle();

    expect(find.byType(ScanPage), findsOneWidget);
    expect(find.text(AppStrings.scanTitle), findsOneWidget);
  });
}
