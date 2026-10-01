// Halaman utama (home) Go Green, referensi Stitch V3 Minimalist.
//
// Section: header environmental + bell, notice login, kartu poin solid
// primary dengan siluet daun, aksi cepat 4 menu, misi hijau mingguan,
// aktivitas terkini, artikel & edukasi hijau.
//
// Background atas: gradasi secondaryContainer ke background.
// Kartu poin: siluet daun putih opacity 12% di pojok kanan bawah.
//
// Tamu dan user login tanpa data menampilkan 0 dan empty state;
// user login memakai data asli (poin + waste log) agar selaras
// dengan halaman Poin & Aktivitas.
// Bottom nav tetap via MainShell (CustomBottomNavBar), tidak diubah.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../../core/widgets/login_notice_widget.dart';
import '../../../activity/presentation/data/activity_detail_extra.dart';
import '../../../activity/presentation/data/activity_texts.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../../points/presentation/providers/point_provider.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../../../waste/domain/usecases/calculate_points_usecase.dart';
import '../../../waste/domain/usecases/submit_waste_usecase.dart';
import '../../../waste/presentation/providers/waste_provider.dart';
import '../../domain/usecases/build_home_summary_usecase.dart';

/// Tanggal terbit artikel demo pertama.
final DateTime _demoArticle1Date = DateTime(2026, 9, 10);

/// Tanggal terbit artikel demo kedua.
final DateTime _demoArticle2Date = DateTime(2026, 9, 5);



/// Halaman beranda Go Green.
class HomePage extends ConsumerStatefulWidget {
  /// Membuat halaman beranda.
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showLoginNotice = true;
  List<WasteLog>? _logs;
  Map<String, String> _checkpointNames = const <String, String>{};
  bool _loadingData = false;
  bool _failedData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  String? get _userId => SupabaseService.instance.currentUser?.id;

  Future<void> _reload() async {
    final String? userId = _userId;
    if (userId == null || !mounted) return;
    setState(() {
      _loadingData = true;
      _failedData = false;
    });
    await ref.read(pointsNotifierProvider.notifier).load(userId: userId);
    try {
      final List<WasteLog> logs = await ref
          .read(wasteRepositoryProvider)
          .getWasteLogs(userId)
          .timeout(const Duration(seconds: 5));
      Map<String, String> names = const <String, String>{};
      try {
        final checkpoints = await ref
            .read(checkpointRepositoryProvider)
            .getAllCheckpoints()
            .timeout(const Duration(seconds: 5));
        names = <String, String>{
          for (final checkpoint in checkpoints) checkpoint.id: checkpoint.name,
        };
      } catch (_) {
        names = const <String, String>{};
      }
      if (!mounted) return;
      setState(() {
        _logs = logs;
        _checkpointNames = names;
        _loadingData = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingData = false;
        _failedData = true;
      });
    }
  }

  /// Ikon tile aktivitas berdasarkan kategori sampah.
  IconData _iconForCategory(WasteCategory category) {
    return switch (category) {
      WasteCategory.organik => LucideIcons.leaf,
      WasteCategory.anorganik => LucideIcons.trash,
      WasteCategory.daurUlang => LucideIcons.recycle,
      WasteCategory.b3 => LucideIcons.triangle_alert,
    };
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<SubmitWasteResult?>>(
      wasteSubmitNotifierProvider,
      (previous, next) {
        if (next.valueOrNull != null && previous is AsyncLoading) {
          _reload();
        }
      },
    );
    final AuthSession session = ref.watch(authNotifierProvider);
    final bool isLoggedIn = session.isLoggedIn;
    final String displayName = isLoggedIn
        ? (session.displayName ??
            session.username ??
            session.userEmail?.split('@').first ??
            AppStrings.guestName)
        : AppStrings.guestName;
    final bool showNotice = _showLoginNotice && !isLoggedIn;

    final String? userId = _userId;
    final int? realPoints =
        ref.watch(pointsNotifierProvider).valueOrNull?.totalPoints;
    final List<WasteLog>? logs = _logs;
    final bool useReal = userId != null &&
        !_failedData &&
        !_loadingData &&
        logs != null &&
        realPoints != null;
    if (userId != null && (_loadingData || (logs == null && !_failedData))) {
      return const Scaffold(
        body: SafeArea(child: _HomeSkeleton()),
      );
    }
    const BuildHomeSummaryUsecase summaryUsecase = BuildHomeSummaryUsecase();
    final List<WasteLog>? realLogs = useReal ? logs : null;
    final HomeSummary? summary =
        realLogs == null ? null : summaryUsecase.build(logs: realLogs);
    const CalculatePointsUsecase calculatePoints = CalculatePointsUsecase();

    final int totalPoints = realPoints ?? 0;
    final List<({IconData icon, String value, String label})> stats =
        summary == null
            ? <({IconData icon, String value, String label})>[
                (
                  icon: LucideIcons.trash,
                  value: '0',
                  label: AppStrings.homeStatWasteLabel,
                ),
                (
                  icon: LucideIcons.globe,
                  value: '0',
                  label: AppStrings.homeStatCarbonLabel,
                ),
                (
                  icon: LucideIcons.leaf,
                  value: '0',
                  label: AppStrings.homeStatTreeLabel,
                ),
              ]
            : <({IconData icon, String value, String label})>[
                (
                  icon: LucideIcons.trash,
                  value: '${summary.totalDisposals}',
                  label: AppStrings.homeStatTimesLabel,
                ),
                (
                  icon: LucideIcons.globe,
                  value: '${summary.weeklyDisposals}',
                  label: AppStrings.homeStatWeekLabel,
                ),
                (
                  icon: LucideIcons.leaf,
                  value: '${summary.verifiedCount}',
                  label: AppStrings.homeVerifiedLabel,
                ),
              ];
    final double missionProgress = summary?.missionProgress ?? 0;
    final String missionCollected = summary == null
        ? '0 ${AppStrings.homeMissionCollectedSuffix}'
        : '${summary.weeklyDisposals} ${AppStrings.homeMissionTimesUnit} '
            '${AppStrings.homeMissionCollectedSuffix}';
    final String missionTarget =
        '${AppStrings.homeMissionTargetPrefix} '
            '${AppConfig.weeklyMissionTargetDisposals} '
            '${AppStrings.homeMissionTimesUnit}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Layer 1: gradasi hijau di background atas.
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 280,
              child: _TopGradientBackground(),
            ),
            // Layer 2: konten utama.
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: <Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  _HomeHeader(displayName: displayName),
                  const SizedBox(height: AppSpacing.md),
                  if (showNotice) ...<Widget>[
                    LoginNoticeCard(
                      message: AppStrings.homeLoginNotice,
                      onLogin: () => context.pushNamed(AppRouteName.login),
                      onDismiss: () => setState(() => _showLoginNotice = false),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _FadeIn(
                    delayMs: 0,
                    child: RepaintBoundary(
                      child: _PointsSummaryCard(
                        totalPoints: totalPoints,
                        stats: stats,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FadeIn(
                    delayMs: 60,
                    child: RepaintBoundary(
                      child: _QuickActionsGrid(
                        onWaste: () => context.goNamed(AppRouteName.waste),
                        onScan: () => context.goNamed(AppRouteName.scan),
                        onArticle: () =>
                            context.pushNamed(AppRouteName.article),
                        onReward: () => context.goNamed(AppRouteName.points),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FadeIn(
                    delayMs: 120,
                    child: _MissionCard(
                      progress: missionProgress,
                      collected: missionCollected,
                      target: missionTarget,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FadeIn(
                    delayMs: 180,
                    child: _SectionHeader(
                      title: AppStrings.homeLatestActivity,
                      actionLabel: AppStrings.seeAllShort,
                      onAction: () => context.goNamed(AppRouteName.activity),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (realLogs == null || realLogs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      child: Text(
                        AppStrings.homeActivityEmpty,
                        style: AppTypography.bodySm,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    for (final WasteLog log in realLogs.take(2)) ...<Widget>[
                      Builder(
                        builder: (BuildContext context) {
                          final String checkpointName =
                              _checkpointNames[log.checkpointId] ??
                                  log.checkpointName ??
                                  (log.checkpointId ?? '-');
                          final int points = calculatePoints.calculate(
                            category: log.category,
                          );
                          final String statusLabel =
                              activityStatusOf(log.status).label;
                          return _ActivityTile(
                            icon: _iconForCategory(log.category),
                            title: activityDescriptionOf(log, checkpointName),
                            time: formatIndonesianTimestamp(log.createdAt),
                            points: points,
                            statusLabel: statusLabel,
                            onTap: () => context.pushNamed(
                              AppRouteName.activityDetail,
                              pathParameters: <String, String>{
                                'id': log.id,
                              },
                              extra: ActivityDetailExtra(
                                description: activityDescriptionOf(
                                  log,
                                  checkpointName,
                                ),
                                date: log.createdAt,
                                status: log.status,
                                checkpointName: checkpointName,
                                points: points,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  const SizedBox(height: AppSpacing.lg),
                  _FadeIn(
                    delayMs: 240,
                    child: _SectionHeader(
                      title: AppStrings.homeArticleSection,
                      actionLabel: AppStrings.seeAll,
                      onAction: () => context.pushNamed(AppRouteName.article),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _FadeIn(
                    delayMs: 300,
                    child: ArticleCard(
                      title: AppStrings.homeArticle1Title,
                      excerpt: AppStrings.homeArticle1Excerpt,
                      date: _demoArticle1Date,
                      thumbnailImage: AppAssets.articleThumb1,
                      onTap: () => context.pushNamed(
                        AppRouteName.articleDetail,
                        pathParameters: const <String, String>{'id': '1'},
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FadeIn(
                    delayMs: 360,
                    child: ArticleCard(
                      title: AppStrings.homeArticle2Title,
                      excerpt: AppStrings.homeArticle2Excerpt,
                      date: _demoArticle2Date,
                      thumbnailImage: AppAssets.articleThumb2,
                      onTap: () => context.pushNamed(
                        AppRouteName.articleDetail,
                        pathParameters: const <String, String>{'id': '2'},
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Background gradasi hijau ke putih di bagian atas Home.
///
/// Gradasi dari secondaryContainer ke background, tinggi 280px,
/// ditempatkan di belakang konten utama agar header dan kartu poin
/// terasa menyatu dengan tema environmental.
class _TopGradientBackground extends StatelessWidget {
  /// Membuat background gradasi atas.
  const _TopGradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.secondaryContainer,
            AppColors.secondaryContainer.withValues(alpha: 0.6),
            AppColors.background,
          ],
          stops: const <double>[0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

/// Sapaan header Home V3 minimalist dengan bell notifikasi.
///
/// Avatar + sapaan kiri, tombol bell kanan dengan titik oranye
/// sebagai penanda environmental header ala Stitch V3.
class _HomeHeader extends StatelessWidget {
  /// Membuat sapaan header Home.
  const _HomeHeader({required this.displayName});

  /// Nama yang ditampilkan (display name / username / tamu).
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Avatar(name: displayName, size: 44),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.greeting,
                style: AppTypography.bodySm,
              ),
              Text(
                displayName,
                style: AppTypography.headlineSm,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight),
                boxShadow: AppElevation.level1,
              ),
              child: const Icon(
                LucideIcons.bell,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Header section dengan judul kiri dan aksi kanan.
class _SectionHeader extends StatelessWidget {
  /// Membuat header section.
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  /// Judul section.
  final String title;

  /// Label aksi kanan.
  final String actionLabel;

  /// Aksi saat tombol kanan ditekan.
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: AppTypography.headlineSm),
        ),
        AppTextButton(text: actionLabel, onPressed: onAction),
      ],
    );
  }
}

/// Aksi cepat Home V3 minimalist: 4 menu grid ala Stitch.
///
/// Buang Sampah, Scan QR, Artikel, Reward. Ikon lingkaran pastel di atas
/// kartu putih agar bersih dan minimalis.
class _QuickActionsGrid extends StatelessWidget {
  /// Membuat grid aksi cepat.
  const _QuickActionsGrid({
    required this.onWaste,
    required this.onScan,
    required this.onArticle,
    required this.onReward,
  });

  /// Aksi ke halaman Buang Sampah.
  final VoidCallback onWaste;

  /// Aksi ke halaman Scan QR.
  final VoidCallback onScan;

  /// Aksi ke halaman Artikel.
  final VoidCallback onArticle;

  /// Aksi ke halaman Poin/Reward.
  final VoidCallback onReward;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.recycle,
            label: AppStrings.navWaste,
            iconColor: AppColors.primary,
            iconBackground: AppColors.surfaceDim,
            onTap: onWaste,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.qr_code,
            label: AppStrings.scanTitle,
            iconColor: AppColors.info,
            iconBackground: AppColors.surfaceDim,
            onTap: onScan,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.book_open,
            label: AppStrings.articleTitle,
            iconColor: AppColors.warning,
            iconBackground: AppColors.surfaceDim,
            onTap: onArticle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: LucideIcons.gift,
            label: AppStrings.rewardsSectionTitle,
            iconColor: AppColors.primaryLight,
            iconBackground: AppColors.surfaceDim,
            onTap: onReward,
          ),
        ),
      ],
    );
  }
}

/// Satu tombol aksi cepat dengan ikon lingkaran + label.
class _QuickActionButton extends StatelessWidget {
  /// Membuat tombol aksi cepat.
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
  });

  /// Ikon menu.
  final IconData icon;

  /// Label menu via AppStrings.
  final String label;

  /// Warna ikon.
  final Color iconColor;

  /// Warna latar lingkaran ikon.
  final Color iconBackground;

  /// Aksi saat ditekan.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: AppTypography.labelMd,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu ringkasan poin V3 minimalist: solid primary, teks putih,
/// siluet daun putih opacity 12% di pojok kanan bawah.
///
/// Berisi judul, angka besar, subtitle, tombol Tukar Reward
/// (kuning), divider putih 20%, dan 3 stat putih.
class _PointsSummaryCard extends StatelessWidget {
  /// Membuat kartu ringkasan poin.
  const _PointsSummaryCard({
    required this.totalPoints,
    required this.stats,
  });

  /// Total poin tampil (asli atau demo).
  final int totalPoints;

  /// Tiga stat dampak (asli atau demo).
  final List<({IconData icon, String value, String label})> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary),
        boxShadow: AppElevation.level1,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          // Siluet daun putih di pojok kanan bawah.
          Positioned(
            right: -28,
            bottom: -28,
            child: Icon(
              LucideIcons.leaf,
              size: 160,
              color: AppColors.textOnPrimary.withValues(alpha: 0.12),
            ),
          ),
          // Konten kartu.
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.star,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.homeTotalPointsTitle,
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: () => context.goNamed(AppRouteName.points),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          formatIndonesianNumber(totalPoints),
                          key: ValueKey<int>(totalPoints),
                          style: AppTypography.headlineXl.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          AppStrings.rewardPointSuffix,
                          style: AppTypography.labelLg.copyWith(
                            color:
                                AppColors.textOnPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.homePointsSubtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => context.goNamed(AppRouteName.points),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.full,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.homeExchangeReward,
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 1,
                  color: AppColors.surface.withValues(alpha: 0.2),
                ),
                const SizedBox(height: AppSpacing.sm),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (stats.isNotEmpty)
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                context.goNamed(AppRouteName.activity),
                            child: _MiniStat(
                              icon: stats.first.icon,
                              value: stats.first.value,
                              label: stats.first.label,
                            ),
                          ),
                        ),
                      if (stats.length > 1) ...<Widget>[
                        const SizedBox(width: AppSpacing.sm),
                        for (int i = 1; i < stats.length; i++)
                          Expanded(
                            child: _MiniStat(
                              icon: stats[i].icon,
                              value: stats[i].value,
                              label: stats[i].label,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat kecil dampak lingkungan di kartu poin.
class _MiniStat extends StatelessWidget {
  /// Membuat stat kecil.
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  /// Ikon stat.
  final IconData icon;

  /// Nilai stat.
  final String value;

  /// Label stat.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu misi hijau mingguan dengan progress bar.
class _MissionCard extends StatelessWidget {
  /// Membuat kartu misi.
  const _MissionCard({
    required this.progress,
    required this.collected,
    required this.target,
  });

  /// Progres 0..1 (asli atau demo).
  final double progress;

  /// Teks terkumpul (asli atau demo).
  final String collected;

  /// Teks target (asli atau demo).
  final String target;

  @override
  Widget build(BuildContext context) {
    final String percentLabel = '${(progress * 100).round()}%';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppElevation.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.activity,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.homeMissionTitle,
                      style: AppTypography.labelLg,
                    ),
                  ],
                ),
              ),
              Text(percentLabel, style: AppTypography.labelMd),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.homeMissionDesc,
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress.clamp(0, 1)),
              duration: const Duration(milliseconds: 600),
              builder: (BuildContext context, double value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: AppColors.tertiaryLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                collected,
                style: AppTypography.bodySm,
              ),
              Text(
                target,
                style: AppTypography.bodySm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tile aktivitas terkini gaya Stitch.
class _ActivityTile extends StatelessWidget {
  /// Membuat tile aktivitas.
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.time,
    required this.points,
    required this.onTap,
    this.statusLabel,
  });

  /// Ikon aktivitas.
  final IconData icon;

  /// Judul setoran.
  final String title;

  /// Waktu setoran.
  final String time;

  /// Poin didapat.
  final int points;

  /// Aksi saat ditekan.
  final VoidCallback onTap;

  /// Label chip status (default label Terverifikasi bahasa aktif).
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceDim,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTypography.labelMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(time, style: AppTypography.bodySm),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '+$points ${AppStrings.rewardPointSuffix}',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      statusLabel ?? AppStrings.homeVerifiedLabel,
                      style: AppTypography.labelSm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fade-in seksi sekali jalan agar Home terasa hidup tanpa loop.
///
/// Animasi opacity + geser 8px ke atas, durasi 350ms dengan jeda per
/// seksi. Tidak berulang sehingga hemat baterai.
class _FadeIn extends StatelessWidget {
  /// Membuat pembungkus fade-in.
  const _FadeIn({required this.child, this.delayMs = 0});

  /// Konten seksi yang dianimasikan.
  final Widget child;

  /// Jeda sebelum animasi mulai (ms).
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + delayMs),
      builder: (BuildContext context, double value, _) {
        final double opacity = delayMs == 0
            ? value
            : ((value * (350 + delayMs) - delayMs) / 350).clamp(0, 1);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - opacity)),
            child: child,
          ),
        );
      },
    );
  }
}

/// Skeleton statis Home saat memuat data login.
///
/// Kotak surfaceDim tanpa shimmer agar ringan dan layout tidak lompat.
class _HomeSkeleton extends StatelessWidget {
  /// Membuat skeleton Home.
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: const <Widget>[
        SizedBox(height: AppSpacing.sm),
        _SkeletonBlock(height: 52, radius: AppRadius.lg),
        SizedBox(height: AppSpacing.md),
        _SkeletonBlock(height: 260, radius: AppRadius.xl),
        SizedBox(height: AppSpacing.md),
        _SkeletonBlock(height: 110, radius: AppRadius.lg),
        SizedBox(height: AppSpacing.md),
        _SkeletonBlock(height: 140, radius: AppRadius.xl),
        SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

/// Satu blok placeholder skeleton.
class _SkeletonBlock extends StatelessWidget {
  /// Membuat blok skeleton.
  const _SkeletonBlock({required this.height, required this.radius});

  /// Tinggi blok.
  final double height;

  /// Radius sudut blok.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight),
      ),
    );
  }
}
