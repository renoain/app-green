// Home V3 minimalist: header + kartu poin + aksi cepat + misi + aktivitas.

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

/// Tanggal terbit artikel demo.
final DateTime _demoArticle1Date = DateTime(2026, 9, 10);
final DateTime _demoArticle2Date = DateTime(2026, 9, 5);



class HomePage extends ConsumerStatefulWidget {
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

  /// Ikon tile berdasarkan kategori sampah.
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
    // 3 stat selalu sama, hanya nilai beda (0 tamu vs real login).
    final List<({IconData icon, String value, String label})> stats =
        <({IconData icon, String value, String label})>[
      (
        icon: LucideIcons.trash,
        value: summary == null ? '0' : '${summary.totalDisposals}',
        label: AppStrings.homeStatTimesLabel,
      ),
      (
        icon: LucideIcons.globe,
        value: summary == null ? '0' : '${summary.weeklyDisposals}',
        label: AppStrings.homeStatWeekLabel,
      ),
      (
        icon: LucideIcons.leaf,
        value: summary == null ? '0' : '${summary.verifiedCount}',
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
            // Gradasi di belakang konten.
            const Positioned.fill(
              child: _HomeGradientBackground(),
            ),
            // Konten utama.
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
                        isLoggedIn
                            ? AppStrings.homeActivityEmpty
                            : AppStrings.homeActivityEmptyGuest,
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

/// Background gradasi Home atas ke bawah (tanpa dekorasi tambahan).
class _HomeGradientBackground extends StatelessWidget {
  const _HomeGradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.secondaryContainer,
            AppColors.secondaryContainer.withValues(alpha: 0.7),
            AppColors.background,
            AppColors.background,
            AppColors.secondaryContainer.withValues(alpha: 0.3),
          ],
          stops: const <double>[0.0, 0.15, 0.45, 0.75, 1.0],
        ),
      ),
    );
  }
}

/// Header Home: avatar + sapaan + bell notifikasi.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.displayName});

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

/// Judul kiri + aksi kanan.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
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

/// Grid 4 menu cepat: Buang Sampah, Scan, Artikel, Reward.
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.onWaste,
    required this.onScan,
    required this.onArticle,
    required this.onReward,
  });

  final VoidCallback onWaste;
  final VoidCallback onScan;
  final VoidCallback onArticle;
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

/// Tombol aksi cepat: ikon lingkaran + label.
class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBackground;
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

/// Kartu poin: solid primary + siluet daun + total + 3 stat.
class _PointsSummaryCard extends StatelessWidget {
  const _PointsSummaryCard({
    required this.totalPoints,
    required this.stats,
  });

  final int totalPoints;
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
          // Siluet daun di sudut kartu.
          Positioned(
            right: -28,
            bottom: -28,
            child: Icon(
              LucideIcons.leaf,
              size: 160,
              color: AppColors.textOnPrimary.withValues(alpha: 0.12),
            ),
          ),
          // Isi kartu.
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
                      for (int i = 0; i < stats.length; i++) ...<Widget>[
                        if (i > 0) const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _MiniStat(
                            icon: stats[i].icon,
                            value: stats[i].value,
                            label: stats[i].label,
                            onTap: i == 0
                                ? () =>
                                    context.goNamed(AppRouteName.activity)
                                : null,
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

/// Stat kecil di kartu poin; onTap null = tidak bisa ditekan.
class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(AppRadius.lg);
    final Widget content = Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
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
    final VoidCallback? tap = onTap;
    if (tap == null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: radius,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: content,
      );
    }
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderLight),
        borderRadius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: tap,
        borderRadius: radius,
        child: content,
      ),
    );
  }
}

/// Kartu misi mingguan + progress bar.
class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.progress,
    required this.collected,
    required this.target,
  });

  /// Progres 0..1.
  final double progress;
  final String collected;
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

/// Tile aktivitas terkini.
class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.time,
    required this.points,
    required this.onTap,
    this.statusLabel,
  });

  final IconData icon;
  final String title;
  final String time;
  final int points;
  final VoidCallback onTap;

  /// Chip status, default label Terverifikasi.
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

/// Fade-in sekali jalan (hemat baterai, tanpa loop).
class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.child, this.delayMs = 0});

  final Widget child;

  /// Jeda animasi (ms).
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

/// Skeleton Home saat memuat (tanpa shimmer, anti layout lompat).
class _HomeSkeleton extends StatelessWidget {
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

/// Placeholder skeleton.
class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height, required this.radius});

  final double height;
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
