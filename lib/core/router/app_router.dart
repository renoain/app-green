// Konfigurasi routing aplikasi menggunakan go_router.
//
// Route bebas (splash, onboarding, login, register, article) dan
// StatefulShellRoute untuk tab utama (home, activity, waste, points,
// profile) agar state tiap tab tetap tersimpan.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/data/activity_detail_extra.dart';
import '../../features/activity/presentation/pages/activity_detail_page.dart';
import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/article/domain/entities/article.dart';
import '../../features/article/presentation/pages/article_detail_page.dart';
import '../../features/article/presentation/pages/article_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/points/presentation/pages/points_page.dart';
import '../../features/points/presentation/pages/reward_detail_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import '../../features/splash/splash_page.dart';
import '../../features/verification/presentation/data/verification_extra.dart';
import '../../features/verification/presentation/pages/verification_page.dart';
import '../../features/waste/presentation/data/capture_extra.dart';
import '../../features/waste/presentation/pages/capture_photo_page.dart';
import '../../features/waste/presentation/pages/waste_page.dart';
import '../widgets/main_shell.dart';

/// Daftar route aplikasi, dipakai untuk membangun [appRouter] dan
/// keperluan test.
final List<RouteBase> appRoutes = <RouteBase>[
  GoRoute(
    path: '/splash',
    name: AppRouteName.splash,
    builder: (BuildContext context, GoRouterState state) =>
        const SplashPage(),
  ),
  GoRoute(
    path: '/onboarding',
    name: AppRouteName.onboarding,
    builder: (BuildContext context, GoRouterState state) =>
        const OnboardingPage(),
  ),
  GoRoute(
    path: '/login',
    name: AppRouteName.login,
    builder: (BuildContext context, GoRouterState state) =>
        const LoginPage(),
  ),
  GoRoute(
    path: '/register',
    name: AppRouteName.register,
    builder: (BuildContext context, GoRouterState state) =>
        const RegisterPage(),
  ),
  GoRoute(
    path: '/article',
    name: AppRouteName.article,
    builder: (BuildContext context, GoRouterState state) =>
        const ArticlePage(),
  ),
  GoRoute(
    path: '/article/:id',
    name: AppRouteName.articleDetail,
    builder: (BuildContext context, GoRouterState state) {
      final Object? extra = state.extra;
      return ArticleDetailPage(
        articleId: state.pathParameters['id'] ?? '1',
        article: extra is Article ? extra : null,
      );
    },
  ),
  GoRoute(
    path: '/reward/:id',
    name: AppRouteName.rewardDetail,
    builder: (BuildContext context, GoRouterState state) => RewardDetailPage(
      rewardId: state.pathParameters['id'] ?? '1',
    ),
  ),
  GoRoute(
    path: '/activity/:id',
    name: AppRouteName.activityDetail,
    builder: (BuildContext context, GoRouterState state) {
      final Object? extra = state.extra;
      return ActivityDetailPage(
        activityId: state.pathParameters['id'] ?? '1',
        extra: extra is ActivityDetailExtra ? extra : null,
      );
    },
  ),
  GoRoute(
    path: '/verification',
    name: AppRouteName.verification,
    builder: (BuildContext context, GoRouterState state) =>
        VerificationPage(extra: state.extra as VerificationExtra?),
  ),
  GoRoute(
    path: '/scan',
    name: AppRouteName.scan,
    builder: (BuildContext context, GoRouterState state) => const ScanPage(),
  ),
  GoRoute(
    path: '/capture',
    name: AppRouteName.capture,
    builder: (BuildContext context, GoRouterState state) =>
        CapturePhotoPage(extra: state.extra as CaptureExtra?),
  ),
  GoRoute(
    path: '/edit-profile',
    name: AppRouteName.editProfile,
    builder: (BuildContext context, GoRouterState state) =>
        const EditProfilePage(),
  ),
  GoRoute(
    path: '/settings',
    name: AppRouteName.settings,
    builder: (BuildContext context, GoRouterState state) =>
        const SettingsPage(),
  ),
  StatefulShellRoute.indexedStack(
    builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell,) =>
        MainShell(navigationShell: navigationShell),
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            name: AppRouteName.home,
            builder: (BuildContext context, GoRouterState state) =>
                const HomePage(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/activity',
            name: AppRouteName.activity,
            builder: (BuildContext context, GoRouterState state) =>
                const ActivityPage(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/waste',
            name: AppRouteName.waste,
            builder: (BuildContext context, GoRouterState state) =>
                const WastePage(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/points',
            name: AppRouteName.points,
            builder: (BuildContext context, GoRouterState state) =>
                const PointsPage(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: '/profile',
            name: AppRouteName.profile,
            builder: (BuildContext context, GoRouterState state) =>
                const ProfilePage(),
          ),
        ],
      ),
    ],
  ),
];

/// Router aplikasi Go Green.
///
/// Didefinisikan sekali dan dipakai oleh MaterialApp.router.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: appRoutes,
);

/// Nama route aplikasi Go Green.
abstract final class AppRouteName {
  AppRouteName._();

  /// Nama route splash.
  static const String splash = 'splash';

  /// Nama route onboarding.
  static const String onboarding = 'onboarding';

  /// Nama route login.
  static const String login = 'login';

  /// Nama route register.
  static const String register = 'register';

  /// Nama route home.
  static const String home = 'home';

  /// Nama route waste.
  static const String waste = 'waste';

  /// Nama route points.
  static const String points = 'points';

  /// Nama route activity.
  static const String activity = 'activity';

  /// Nama route detail activity.
  static const String activityDetail = 'activityDetail';

  /// Nama route article.
  static const String article = 'article';

  /// Nama route detail article.
  static const String articleDetail = 'articleDetail';

  /// Nama route profile.
  static const String profile = 'profile';

  /// Nama route detail reward.
  static const String rewardDetail = 'rewardDetail';

  /// Nama route verifikasi.
  static const String verification = 'verification';

  /// Nama route scan QR.
  static const String scan = 'scan';

  /// Nama route ambil foto (kamera in-app).
  static const String capture = 'capture';

  /// Nama route edit profil.
  static const String editProfile = 'editProfile';

  /// Nama route pengaturan.
  static const String settings = 'settings';
}