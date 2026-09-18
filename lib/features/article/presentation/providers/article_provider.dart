// Provider data artikel.
//
// Menyediakan repository dan notifier daftar artikel (AsyncValue) agar
// halaman bisa memuat data tanpa akses langsung ke data layer.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../../data/repositories/article_repository_impl.dart';

/// Provider repository artikel.
final Provider<ArticleRepository> articleRepositoryProvider =
    Provider<ArticleRepository>(
  (Ref ref) => ArticleRepositoryImpl(),
);

/// Notifier daftar artikel edukasi.
class ArticleNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  /// Membuat notifier dengan repository yang di-inject.
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
