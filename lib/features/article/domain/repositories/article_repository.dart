// Interface repository artikel (domain).
//
// Implementasi data layer (ArticleRepositoryImpl) wajib mengikuti kontrak
// ini. Mengembalikan entity domain, bukan model data.

import '../entities/article.dart';

/// Kontrak repository artikel Go Green.
abstract interface class ArticleRepository {
  /// Ambil semua artikel, terbaru di atas.
  Future<List<Article>> getAllArticles();

  /// Ambil satu artikel berdasarkan id, atau null bila tidak ada.
  Future<Article?> getArticleById(String id);
}
