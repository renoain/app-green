// Data source artikel Laravel via REST (tanpa Supabase).

import 'package:dio/dio.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/utils/logger.dart';
import '../models/article_model.dart';
import 'article_remote_datasource.dart';

/// Data source artikel untuk mode Laravel. Method sama persis dengan
/// [ArticleRemoteDatasource] sehingga repository tidak perlu berubah.
class ArticleLaravelDatasource extends ArticleRemoteDatasource {
  ArticleLaravelDatasource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.laravelApiUrl));

  final Dio _dio;

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final Object? body = response.data;
    final Object? payload = body is Map ? body['data'] : body;
    if (payload is! List) {
      return const <Map<String, dynamic>>[];
    }
    final List<Map<String, dynamic>> rows = <Map<String, dynamic>>[];
    for (final Object? item in payload) {
      rows.add(Map<String, dynamic>.from(item as Map));
    }
    return rows;
  }

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    final Object? body = response.data;
    final Object? payload = body is Map ? body['data'] : body;
    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }
    return Map<String, dynamic>.from(body as Map);
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'ArticleLaravelDatasource.$method gagal',
      error,
      stackTrace,
    );
    throw error;
  }

  /// Ambil semua artikel, terbaru di atas.
  @override
  Future<List<ArticleModel>> getAllArticles() async {
    try {
      final Response<dynamic> response = await _dio.get('/articles');
      return _asList(response).map(ArticleModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllArticles', error, stackTrace);
    }
  }

  /// Ambil satu artikel berdasarkan id, atau null bila tidak ada.
  @override
  Future<ArticleModel?> getArticleById(String id) async {
    try {
      final Response<dynamic> response = await _dio.get('/articles/$id');
      return ArticleModel.fromJson(_asMap(response));
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getArticleById', error, stackTrace);
    }
  }
}
