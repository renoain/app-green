// Implementasi repository artikel (data layer).
//
// Menerjemahkan kontrak ArticleRepository menjadi panggilan
// ArticleRemoteDatasource. Tidak boleh dipakai di presentation.

import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_remote_datasource.dart';

/// Implementasi [ArticleRepository] berbasis Supabase.
class ArticleRepositoryImpl implements ArticleRepository {
  /// Membuat repository. [remote] bisa di-inject untuk test.
  ArticleRepositoryImpl({ArticleRemoteDatasource? remote})
      : _remote = remote ?? ArticleRemoteDatasource();

  final ArticleRemoteDatasource _remote;

  @override
  Future<List<Article>> getAllArticles() {
    return _remote.getAllArticles();
  }

  @override
  Future<Article?> getArticleById(String id) {
    return _remote.getArticleById(id);
  }
}
