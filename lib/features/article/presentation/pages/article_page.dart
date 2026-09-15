// Halaman daftar artikel edukasi Go Green.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../data/article_demo_data.dart';

/// Halaman daftar artikel Go Green.
class ArticlePage extends StatefulWidget {
  /// Membuat halaman daftar artikel.
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ArticleDemo> get _filteredArticles {
    final String keyword = _query.trim().toLowerCase();
    if (keyword.isEmpty) {
      return demoArticles;
    }
    return demoArticles
        .where(
          (ArticleDemo article) =>
              article.title.toLowerCase().contains(keyword) ||
              article.excerpt.toLowerCase().contains(keyword),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<ArticleDemo> articles = _filteredArticles;

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.articleTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            SearchField(
              hint: AppStrings.articleSearchHint,
              controller: _searchController,
              onChanged: (String value) => setState(() => _query = value),
            ),
            const SizedBox(height: AppSpacing.md),
            if (articles.isEmpty)
              const EmptyState(
                icon: LucideIcons.search,
                title: AppStrings.articleNoResultsTitle,
                message: AppStrings.articleNoResultsMessage,
              )
            else
              for (final ArticleDemo article in articles) ...<Widget>[
                ArticleCard(
                  title: article.title,
                  excerpt: article.excerpt,
                  date: article.date,
                  onTap: () => context.goNamed(
                    AppRouteName.articleDetail,
                    pathParameters: <String, String>{'id': article.id},
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }
}