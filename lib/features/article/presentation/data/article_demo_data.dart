// Data artikel demo untuk tahap placeholder.
//
// Akan diganti oleh layer data (repository + Supabase) saat terpasang.

import '../../../../core/constants/app_strings.dart';

/// Artikel demo untuk daftar Artikel dan detail.
class ArticleDemo {
  const ArticleDemo({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.content,
  });

  /// Identitas artikel.
  final String id;

  /// Judul artikel.
  final String title;

  /// Ringkasan artikel.
  final String excerpt;

  /// Tanggal terbit.
  final DateTime date;

  /// Konten paragraf.
  final List<String> content;
}

/// Daftar artikel demo aplikasi.
final List<ArticleDemo> demoArticles = <ArticleDemo>[
  ArticleDemo(
    id: '1',
    title: AppStrings.homeArticle1Title,
    excerpt: AppStrings.homeArticle1Excerpt,
    date: DateTime(2026, 9, 10),
    content: <String>[
      AppStrings.articleContentP1,
      AppStrings.articleContentP2,
      AppStrings.articleContentP3,
    ],
  ),
  ArticleDemo(
    id: '2',
    title: AppStrings.homeArticle2Title,
    excerpt: AppStrings.homeArticle2Excerpt,
    date: DateTime(2026, 9, 5),
    content: <String>[
      AppStrings.articleContentP2,
      AppStrings.articleContentP1,
      AppStrings.articleContentP3,
    ],
  ),
  ArticleDemo(
    id: '3',
    title: AppStrings.homeArticle3Title,
    excerpt: AppStrings.homeArticle3Excerpt,
    date: DateTime(2026, 8, 28),
    content: <String>[
      AppStrings.articleContentP3,
      AppStrings.articleContentP1,
      AppStrings.articleContentP2,
    ],
  ),
  ArticleDemo(
    id: '4',
    title: AppStrings.homeArticle4Title,
    excerpt: AppStrings.homeArticle4Excerpt,
    date: DateTime(2026, 8, 20),
    content: <String>[
      AppStrings.articleContentP1,
      AppStrings.articleContentP3,
      AppStrings.articleContentP2,
    ],
  ),
];