// Halaman detail artikel edukasi Go Green.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../data/article_demo_data.dart';

/// Halaman detail artikel Go Green.
class ArticleDetailPage extends StatelessWidget {
  /// Membuat halaman detail artikel.
  const ArticleDetailPage({super.key, this.articleId = '1'});

  /// Identitas artikel yang dibuka.
  final String articleId;

  @override
  Widget build(BuildContext context) {
    ArticleDemo? found;
    for (final ArticleDemo article in demoArticles) {
      if (article.id == articleId) {
        found = article;
        break;
      }
    }
    final ArticleDemo article = found ?? demoArticles.first;

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.articleTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  LucideIcons.calendar,
                  size: 14,
                  color: AppColors.textDisabled,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  formatIndonesianDate(article.date),
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(article.title, style: AppTypography.headlineLg),
            const SizedBox(height: AppSpacing.lg),
            for (final String paragraph in article.content) ...<Widget>[
              Text(
                paragraph,
                style: AppTypography.bodyLg,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}