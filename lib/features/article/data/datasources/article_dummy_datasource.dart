// Data source artikel dummy berbasis json-server (tanpa Supabase).

import 'package:dio/dio.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';
import '../models/article_model.dart';
import 'article_remote_datasource.dart';

/// Data source artikel untuk mode dummy. Method sama persis dengan [ArticleRemoteDatasource] sehingga repository tidak perlu berubah.
class ArticleDummyDatasource extends ArticleRemoteDatasource {
  ArticleDummyDatasource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(baseUrl: AppEnv.dummyApiUrl));

  final Dio _dio;

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final Object? data = response.data;
    if (data is List) {
      return data
          .map((Object? item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    return Map<String, dynamic>.from(response.data as Map);
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('ArticleDummyDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Ambil semua artikel, terbaru di atas.
  @override
  Future<List<ArticleModel>> getAllArticles() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.articles}',
        queryParameters: <String, dynamic>{
          '_sort': 'published_at',
          '_order': 'desc',
        },
      );
      return _asList(response).map(ArticleModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllArticles', error, stackTrace);
    }
  }

  /// Ambil satu artikel berdasarkan id, atau null bila tidak ada.
  @override
  Future<ArticleModel?> getArticleById(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get('/${AppTables.articles}/$id');
      if (response.data == null) {
        return null;
      }
      return ArticleModel.fromJson(_asMap(response));
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getArticleById', error, stackTrace);
    }
  }
}
