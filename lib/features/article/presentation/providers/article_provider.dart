// Provider data artikel.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../../data/datasources/article_dummy_datasource.dart';
import '../../data/datasources/article_remote_datasource.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../../../core/constants/app_env.dart';

/// Provider data source artikel (dummy saat [AppEnv.useDummyApi] true).
final Provider<ArticleRemoteDatasource> articleRemoteDatasourceProvider =
    Provider<ArticleRemoteDatasource>(
  (Ref ref) => AppEnv.useDummyApi
      ? ArticleDummyDatasource()
      : ArticleRemoteDatasource(),
);

/// Provider repository artikel.
final Provider<ArticleRepository> articleRepositoryProvider =
    Provider<ArticleRepository>(
  (Ref ref) => ArticleRepositoryImpl(
    remote: ref.watch(articleRemoteDatasourceProvider),
  ),
);

/// Notifier daftar artikel edukasi.
class ArticleNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  ArticleNotifier(this._repository)
      : super(const AsyncLoading<List<Article>>());

  final ArticleRepository _repository;

  /// Memuat semua artikel, terbaru di atas.
  Future<void> load() async {
    state = const AsyncLoading<List<Article>>();
    state = await AsyncValue.guard<List<Article>>(
      _repository.getAllArticles,
    );
  }
}

/// Provider state daftar artikel.
final StateNotifierProvider<ArticleNotifier, AsyncValue<List<Article>>>
    articleNotifierProvider =
    StateNotifierProvider<ArticleNotifier, AsyncValue<List<Article>>>(
  (Ref ref) => ArticleNotifier(ref.watch(articleRepositoryProvider)),
);
