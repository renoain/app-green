// Widget test halaman buang sampah (waste).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/display_widgets.dart';
import 'package:go_green/features/scan/presentation/pages/scan_page.dart';
import 'package:go_green/features/waste/presentation/pages/capture_photo_page.dart';
import 'package:go_green/features/waste/presentation/pages/waste_page.dart';

const MethodChannel _permissionChannel =
    MethodChannel('flutter.baseflow.com/permissions/methods');

void main() {
  testWidgets('menampilkan checkpoint, status GPS, dan tombol ambil foto',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const WastePage(),
      ),
    );

    expect(find.text(AppStrings.wasteTitle), findsOneWidget);
    expect(find.text(AppStrings.wasteCheckpointTps), findsOneWidget);
    expect(find.text(AppStrings.wasteCheckpointBank), findsOneWidget);
    expect(find.text(AppStrings.wasteGpsTitle), findsOneWidget);
    expect(find.text(AppStrings.wasteGpsInRadius), findsOneWidget);
    expect(find.text(AppStrings.takePhotoButton), findsOneWidget);
  });

  testWidgets('memilih checkpoint kedua menandai kartu tersebut',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const WastePage(),
      ),
    );

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
      MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: GoRouter(
          initialLocation: '/waste',
          routes: appRoutes,
        ),
      ),
    );

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
      MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: GoRouter(
          initialLocation: '/waste',
          routes: appRoutes,
        ),
      ),
    );

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