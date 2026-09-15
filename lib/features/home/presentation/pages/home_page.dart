// Halaman utama (home) Go Green.
//
// Berisi notice login (bisa dilewati, otomatis hilang saat sudah login),
// header sapaan + avatar, field pencarian, banner hero, menu utama
// berisi aksi cepat, saldo poin, dan artikel terbaru. Data masih
// placeholder sampai layer data terpasang. Gambar hero dan thumbnail
// artikel memakai aset dari assets/images/ref/ (referensi UI).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../../core/widgets/login_notice_widget.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        ref.watch(authNotifierProvider.select((AuthSession s) => s.isLoggedIn));
    final bool showNotice = _showLoginNotice && !isLoggedIn;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: <Widget>[
            const SizedBox(height: AppSpacing.sm),
            if (showNotice) ...<Widget>[
              LoginNoticeCard(
                message: AppStrings.homeLoginNotice,
                onLogin: () => context.pushNamed(AppRouteName.login),
                onDismiss: () => setState(() => _showLoginNotice = false),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _HomeHeader(onTapProfile: () => context.goNamed(AppRouteName.editProfile)),
            const SizedBox(height: AppSpacing.md),
            _HomeHeroBanner(onStart: () => context.goNamed(AppRouteName.waste)),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.homeMenuTitle,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: _HomeMenuCard(
                    icon: LucideIcons.recycle,
                    label: AppStrings.navWaste,
                    onTap: () => context.goNamed(AppRouteName.waste),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _HomeMenuCard(
                    icon: LucideIcons.coins,
                    label: AppStrings.pointsTitle,
                    onTap: () => context.goNamed(AppRouteName.points),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _HomeMenuCard(
                    icon: LucideIcons.book_open,
                    label: AppStrings.articleTitle,
                    onTap: () => context.goNamed(AppRouteName.article),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _HomeMenuCard(
                    icon: LucideIcons.qr_code,
                    label: AppStrings.scanTitle,
                    onTap: () => context.goNamed(AppRouteName.scan),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const PointCard(
              point: 250,
              label: AppStrings.pointsBalance,
              icon: LucideIcons.coins,
            ),
            const SizedBox(height: AppSpacing.lg),
            const SearchField(hint: AppStrings.articleSearchHint),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    AppStrings.homeRecentArticles,
                    style: AppTypography.headlineSm,
                  ),
                ),
                AppTextButton(
                  text: AppStrings.seeAll,
                  onPressed: () => context.goNamed(AppRouteName.article),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ArticleCard(
              title: AppStrings.homeArticle1Title,
              excerpt: AppStrings.homeArticle1Excerpt,
              date: _demoArticle1Date,
              thumbnailImage: AppAssets.articleThumb1,
              onTap: () => context.goNamed(
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
              onTap: () => context.goNamed(
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onTapProfile});

  final VoidCallback onTapProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.greeting,
                style: AppTypography.bodySm,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.guestName,
                style: AppTypography.headlineMd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(LucideIcons.bell, size: 22),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text(AppStrings.menuNotAvailable)),
              );
          },
        ),
        const SizedBox(width: AppSpacing.xs),
        GestureDetector(
          onTap: onTapProfile,
          child: const Avatar(name: AppStrings.guestName, size: 44),
        ),
      ],
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  const _HomeMenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundAlt,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.labelSm,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeroBanner extends StatelessWidget {
  const _HomeHeroBanner({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              AppAssets.homeBannerHero,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    AppColors.primaryDark,
                    AppColors.primaryLight,
                  ],
                  stops: <double>[0.0, 0.7],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.homeHeroTitle,
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      AppStrings.homeHeroSubtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onStart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.full,
                            ),
                          ),
                        ),
                        child: Text(
                          AppStrings.homeHeroCta,
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
