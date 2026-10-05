// Layanan push notification FCM + tampil lokal (core service).

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_strings.dart';
import 'supabase_service.dart';

/// Menyimpan token push ke backend (di-inject agar teruji).
typedef SavePushToken = Future<void> Function({
  required String userId,
  required String token,
});

/// Kunci preferensi master notifikasi.
const String _notificationsEnabledKey = 'notifications_enabled';

/// Channel notifikasi Android.
const String _channelId = 'go_green_default';

/// Handler pesan background (isolate terpisah, wajib top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Tanpa konfigurasi Firebase: abaikan pesan background.
  }
}

/// Pemeta payload push ke nama route aplikasi (murni, teruji).
abstract final class PushRouteMapper {
  PushRouteMapper._();

  /// Nama route dari [data] push, null bila tak dikenal.
  static String? routeNameFor(Map<String, dynamic> data) {
    return switch (data['route']) {
      'home' => 'home',
      'activity' => 'activity',
      'points' => 'points',
      'vouchers' => 'vouchers',
      'adminDashboard' => 'adminDashboard',
      'adminWasteVerification' => 'adminWasteVerification',
      _ => null,
    };
  }
}

/// Layanan push notification Go Green.
class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? local,
    SavePushToken? saveToken,
  })  : _messagingOverride = messaging,
        _localOverride = local,
        _saveToken = saveToken;

  final FirebaseMessaging? _messagingOverride;
  final FlutterLocalNotificationsPlugin? _localOverride;
  final SavePushToken? _saveToken;

  bool _ready = false;
  void Function(String routeName)? _onRoute;

  /// Apakah push aktif (Firebase terkonfigurasi + init sukses).
  bool get isReady => _ready;

  /// Inisialisasi best effort; kembalikan true bila push aktif.
  Future<bool> init({void Function(String routeName)? onRoute}) async {
    _onRoute = onRoute;
    try {
      await Firebase.initializeApp();
      final FirebaseMessaging messaging =
          _messagingOverride ?? FirebaseMessaging.instance;
      await messaging.requestPermission();
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final FlutterLocalNotificationsPlugin local =
          _localOverride ?? FlutterLocalNotificationsPlugin();
      await local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse:
            (NotificationResponse response) {
          final String? payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            _onRoute?.call(payload);
          }
        },
      );
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );
      FirebaseMessaging.onMessage.listen(_showForeground);
      FirebaseMessaging.onMessageOpenedApp.listen(_openFromMessage);
      final RemoteMessage? initial = await messaging.getInitialMessage();
      final String? initialRoute = initial == null
          ? null
          : PushRouteMapper.routeNameFor(initial.data);
      if (initialRoute != null) _onRoute?.call(initialRoute);
      messaging.onTokenRefresh.listen((String token) {
        _persistToken(token);
      });
      _ready = true;
      return true;
    } catch (_) {
      _ready = false;
      return false;
    }
  }

  /// Tampilkan pesan foreground sebagai notifikasi lokal.
  Future<void> _showForeground(RemoteMessage message) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!(prefs.getBool(_notificationsEnabledKey) ?? true)) return;
      final String? title = message.notification?.title;
      final String? body = message.notification?.body;
      if (title == null && body == null) return;
      final FlutterLocalNotificationsPlugin local =
          _localOverride ?? FlutterLocalNotificationsPlugin();
await local.show(
        id: message.hashCode,
        title: title ?? AppStrings.appName,
        body: body ?? '',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            AppStrings.notifChannelName,
            channelDescription: AppStrings.notifChannelDesc,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } catch (_) {
      // Notifikasi lokal opsional: abaikan kegagalan.
    }
  }

  /// Buka route dari ketukan push.
  void _openFromMessage(RemoteMessage message) {
    final String? route = PushRouteMapper.routeNameFor(message.data);
    if (route != null) _onRoute?.call(route);
  }

  /// Simpan token perangkat untuk user yang sedang login.
  Future<void> saveTokenForCurrentUser() async {
    if (!_ready) return;
    try {
      final String? userId = SupabaseService.instance.currentUser?.id;
      if (userId == null) return;
      final FirebaseMessaging messaging =
          _messagingOverride ?? FirebaseMessaging.instance;
      final String? token = await messaging.getToken();
      if (token == null || token.isEmpty) return;
      await _saveToken?.call(userId: userId, token: token);
    } catch (_) {
      // Token opsional: abaikan kegagalan.
    }
  }

  /// Baca preferensi master notifikasi.
  static Future<bool> isEnabled() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationsEnabledKey) ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Ubah preferensi master notifikasi (minta izin saat dinyalakan).
  Future<void> setEnabled(bool enabled) async {
    try {
      if (enabled && _ready) {
        final FirebaseMessaging messaging =
            _messagingOverride ?? FirebaseMessaging.instance;
        await messaging.requestPermission();
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsEnabledKey, enabled);
    } catch (_) {
      // Abaikan: preferensi tidak kritis.
    }
  }

  /// Persist token baru dari refresh listener.
  Future<void> _persistToken(String token) async {
    try {
      final String? userId = SupabaseService.instance.currentUser?.id;
      if (userId == null) return;
      await _saveToken?.call(userId: userId, token: token);
    } catch (_) {
      // Abaikan.
    }
  }
}
