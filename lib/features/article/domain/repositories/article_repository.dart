// Interface repository artikel (domain).

import '../entities/article.dart';

/// Kontrak repository artikel Go Green.
abstract interface class ArticleRepository {
  /// Ambil semua artikel, terbaru di atas.
  Future<List<Article>> getAllArticles();

  /// Ambil satu artikel berdasarkan id, atau null bila tidak ada.
  Future<Article?> getArticleById(String id);
}
