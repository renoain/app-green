// Halaman utama (home) Go Green, redesign sesuai referensi Stitch.
//
// Section: notice login, hero carousel "Ayo Mulai", ringkasan poin +
// 3 stat dampak, misi hijau mingguan, aktivitas terkini, artikel &
// edukasi hijau. Bottom nav tetap via MainShell (CustomBottomNavBar),
// tidak diubah di halaman ini.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
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
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Tanggal terbit artikel demo pertama.
final DateTime _demoArticle1Date = DateTime(2026, 9, 10);

/// Tanggal terbit artikel demo kedua.
final DateTime _demoArticle2Date = DateTime(2026, 9, 5);

/// Total poin demo di Home (Stitch menampilkan 4.324).
const int _demoTotalPoints = 4324;

/// Progres misi mingguan demo (63%).
const double _demoMissionProgress = 0.63;

/// Halaman beranda Go Green.
class HomePage extends ConsumerStatefulWidget {
  /// Membuat halaman beranda.
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showLoginNotice = true;

  @override
  Widget build(BuildContext context) {
    final AuthSession session = ref.watch(authNotifierProvider);
    final bool isLoggedIn = session.isLoggedIn;
    final String displayName = isLoggedIn
        ? (session.displayName ??
            session.username ??
            session.userEmail?.split('@').first ??
            AppStrings.guestName)
        : AppStrings.guestName;
    final bool showNotice = _showLoginNotice && !isLoggedIn;

    return Scaffold(
      body: SafeArea(
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
            _HeroCarouselCard(
              onStart: () => context.goNamed(AppRouteName.waste),
            ),
            const SizedBox(height: AppSpacing.md),
            _PointsSummaryCard(
              onExchange: () => context.goNamed(AppRouteName.points),
              onHistory: () => context.goNamed(AppRouteName.activity),
            ),
            const SizedBox(height: AppSpacing.md),
            const _MissionCard(),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: AppStrings.homeLatestActivity,
              actionLabel: AppStrings.seeAllShort,
              onAction: () => context.goNamed(AppRouteName.activity),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ActivityTile(
              icon: LucideIcons.recycle,
              title: AppStrings.homeActivity1Title,
              time: AppStrings.homeActivity1Time,
              points: 150,
              onTap: () => context.pushNamed(
                AppRouteName.activityDetail,
                pathParameters: const <String, String>{'id': '1'},
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ActivityTile(
              icon: LucideIcons.trash,
              title: AppStrings.homeActivity2Title,
              time: AppStrings.homeActivity2Time,
              points: 80,
              onTap: () => context.pushNamed(
                AppRouteName.activityDetail,
                pathParameters: const <String, String>{'id': '2'},
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: AppStrings.homeArticleSection,
              actionLabel: AppStrings.seeAll,
              onAction: () => context.pushNamed(AppRouteName.article),
            ),
            const SizedBox(height: AppSpacing.sm),
            ArticleCard(
              title: AppStrings.homeArticle1Title,
              excerpt: AppStrings.homeArticle1Excerpt,
              date: _demoArticle1Date,
              thumbnailImage: AppAssets.articleThumb1,
              onTap: () => context.pushNamed(
                AppRouteName.articleDetail,
                pathParameters: const <String, String>{'id': '1'},
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ArticleCard(
              title: AppStrings.homeArticle2Title,
              excerpt: AppStrings.homeArticle2Excerpt,
              date: _demoArticle2Date,
              thumbnailImage: AppAssets.articleThumb2,
              onTap: () => context.pushNamed(
                AppRouteName.articleDetail,
                pathParameters: const <String, String>{'id': '2'},
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

/// Sapaan header Home dengan nama tampilan user.
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
              const Text(
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

/// Banner hero gaya Stitch: kartu hijau muda + CTA + ilustrasi pohon.
class _HeroCarouselCard extends StatelessWidget {
  /// Membuat banner hero.
  const _HeroCarouselCard({required this.onStart});

  /// Aksi tombol mulai.
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(
                          LucideIcons.leaf,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          AppStrings.homeHeroEyebrow,
                          style: AppTypography.labelMd,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      AppStrings.homeHeroTitle,
                      style: AppTypography.headlineMd,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      AppStrings.homeHeroSubtitle,
                      style: AppTypography.bodySm,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onStart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
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
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(AppStrings.homeHeroCta),
                            SizedBox(width: AppSpacing.xs),
                            Icon(LucideIcons.arrow_right, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                LucideIcons.leaf,
                size: 72,
                color: AppColors.tertiary,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _CarouselDot(active: true),
            SizedBox(width: AppSpacing.xs),
            _CarouselDot(active: false),
            SizedBox(width: AppSpacing.xs),
            _CarouselDot(active: false),
          ],
        ),
      ],
    );
  }
}

/// Titik indikator carousel hero.
class _CarouselDot extends StatelessWidget {
  /// Membuat titik indikator.
  const _CarouselDot({required this.active});

  /// Apakah titik sedang aktif.
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}

/// Kartu ringkasan poin gaya Stitch + 3 stat dampak.
class _PointsSummaryCard extends StatelessWidget {
  /// Membuat kartu ringkasan poin.
  const _PointsSummaryCard({
    required this.onExchange,
    required this.onHistory,
  });

  /// Aksi tukar reward.
  final VoidCallback onExchange;

  /// Aksi lihat riwayat.
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppElevation.level1,
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(
                          LucideIcons.coins,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          AppStrings.homeTotalPointsTitle,
                          style: AppTypography.bodySm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${formatIndonesianNumber(_demoTotalPoints)} ${AppStrings.rewardPointSuffix}',
                      style: AppTypography.headlineMd,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onExchange,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.full,
                          ),
                        ),
                      ),
                      child: const Text(
                        AppStrings.homeExchangeReward,
                        style: AppTypography.labelMd,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: onHistory,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.full,
                          ),
                        ),
                      ),
                      child: const Text(
                        AppStrings.homeViewHistory,
                        style: AppTypography.labelMd,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: <Widget>[
              Expanded(
                child: _MiniStat(
                  icon: LucideIcons.trash,
                  value: AppStrings.homeStatWasteValue,
                  label: AppStrings.homeStatWasteLabel,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
                  icon: LucideIcons.globe,
                  value: AppStrings.homeStatCarbonValue,
                  label: AppStrings.homeStatCarbonLabel,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
                  icon: LucideIcons.leaf,
                  value: AppStrings.homeStatTreeValue,
                  label: AppStrings.homeStatTreeLabel,
                ),
              ),
            ],
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.labelMd,
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTypography.bodySm,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Kartu misi hijau mingguan dengan progress bar.
class _MissionCard extends StatelessWidget {
  /// Membuat kartu misi.
  const _MissionCard();

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Icon(
                      LucideIcons.activity,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.homeMissionTitle,
                      style: AppTypography.labelLg,
                    ),
                  ],
                ),
              ),
              Text('63%', style: AppTypography.labelMd),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            AppStrings.homeMissionDesc,
            style: AppTypography.bodySm,
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: const LinearProgressIndicator(
              value: _demoMissionProgress,
              minHeight: 8,
              backgroundColor: AppColors.tertiaryLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.homeMissionCollected,
                style: AppTypography.bodySm,
              ),
              Text(
                AppStrings.homeMissionTarget,
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
                    child: const Text(
                      AppStrings.homeVerifiedLabel,
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
