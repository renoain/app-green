// Implementasi repository artikel (data layer).

import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_remote_datasource.dart';

/// Implementasi [ArticleRepository] berbasis Supabase.
class ArticleRepositoryImpl implements ArticleRepository {
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
