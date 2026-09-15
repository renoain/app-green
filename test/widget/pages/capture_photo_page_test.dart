// Widget test halaman ambil foto (kamera in-app).
// Di widget test method channel kamera/izin digantikan mock agar halaman
// menampilkan fallback alih-alih menunggu plugin perangkat.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';

const MethodChannel _permissionChannel =
    MethodChannel('flutter.baseflow.com/permissions/methods');
const MethodChannel _cameraChannel =
    MethodChannel('plugins.flutter.io/camera');

/// Mock izin kamera. [grant] true berarti izin diberikan.
Future<Object?> Function(MethodCall) _permissionHandler({
  required bool grant,
}) {
  return (MethodCall call) async {
    if (call.method != 'requestPermissions') return null;
    final List<dynamic> requested = call.arguments as List<dynamic>;
    final int status = grant ? 1 : 0; // granted / denied
    return <int, int>{
      for (final Object value in requested) value as int: status,
    };
  };
}

/// Membuat router yang dibuka langsung di route /capture.
Future<void> _pumpCapturePage(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: '/capture',
        routes: appRoutes,
      ),
    ),
  );
}

void main() {
  tearDown(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_permissionChannel, null);
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_cameraChannel, null);
  });

  testWidgets('menampilkan fallback izin saat izin kamera ditolak',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      _permissionChannel,
      _permissionHandler(grant: false),
    );

    await _pumpCapturePage(tester);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.captureTitle), findsOneWidget);
    expect(find.text(AppStrings.capturePermissionDenied), findsOneWidget);
    expect(find.text(AppStrings.captureRetryButton), findsOneWidget);
    expect(find.text(AppStrings.backButton), findsOneWidget);
  });

  testWidgets('tombol coba lagi tetap berada di halaman kamera',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      _permissionChannel,
      _permissionHandler(grant: false),
    );

    await _pumpCapturePage(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.captureRetryButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.captureTitle), findsOneWidget);
    expect(find.text(AppStrings.capturePermissionDenied), findsOneWidget);
  });

  testWidgets('menampilkan fallback saat kamera tidak tersedia',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      _permissionChannel,
      _permissionHandler(grant: true),
    );
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      _cameraChannel,
      (MethodCall call) async {
        throw PlatformException(code: 'camera_unavailable');
      },
    );

    await _pumpCapturePage(tester);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.captureUnavailable), findsOneWidget);
  });
}
