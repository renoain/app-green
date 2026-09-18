// Halaman daftar artikel edukasi Go Green.
//
// Daftar dimuat dari Supabase via articleNotifierProvider (publik, tanpa
// login); saat backend gagal memakai daftar demo.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../domain/entities/article.dart';
import '../data/article_demo_data.dart';
import '../providers/article_provider.dart';

/// Halaman daftar artikel Go Green.
class ArticlePage extends ConsumerStatefulWidget {
  /// Membuat halaman daftar artikel.
  const ArticlePage({super.key});

  @override
  ConsumerState<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends ConsumerState<ArticlePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    if (!mounted) return;
    await ref.read(articleNotifierProvider.notifier).load().timeout(
          const Duration(seconds: 5),
          onTimeout: () {},
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Article> _effectiveArticles(AsyncValue<List<Article>> state) {
    final List<Article>? data = state.valueOrNull;
    if (data != null && data.isNotEmpty) return data;
    return demoArticles
        .map(
          (ArticleDemo demo) => Article(
            id: demo.id,
            title: demo.title,
            excerpt: demo.excerpt,
            paragraphs: demo.content,
            publishedAt: demo.date,
            createdAt: demo.date,
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Article>> articleState =
        ref.watch(articleNotifierProvider);
    final List<Article> articles = _effectiveArticles(articleState);
    final String keyword = _query.trim().toLowerCase();
    final List<Article> filtered = keyword.isEmpty
        ? articles
        : articles
            .where(
              (Article article) =>
                  article.title.toLowerCase().contains(keyword) ||
                  (article.excerpt ?? '').toLowerCase().contains(keyword),
            )
            .toList();
    final bool isReal = articleState.valueOrNull?.isNotEmpty ?? false;

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
            if (filtered.isEmpty)
              const EmptyState(
                icon: LucideIcons.search,
                title: AppStrings.articleNoResultsTitle,
                message: AppStrings.articleNoResultsMessage,
              )
            else
              for (final Article article in filtered) ...<Widget>[
                ArticleCard(
                  title: article.title,
                  excerpt: article.excerpt ?? '',
                  date: article.publishedAt,
                  onTap: () => context.pushNamed(
                    AppRouteName.articleDetail,
                    pathParameters: <String, String>{'id': article.id},
                    extra: isReal ? article : null,
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
