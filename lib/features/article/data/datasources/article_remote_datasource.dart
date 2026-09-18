// Data source artikel berbasis Supabase.
//
// Membungkus pembacaan artikel edukasi (publik, tanpa login). Dipanggil
// oleh repository, bukan dari widget.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/article_model.dart';

/// Data source artikel Go Green.
class ArticleRemoteDatasource {
  /// Membuat data source artikel. [client] bisa di-inject untuk test.
  ///
  /// Client Supabase diambil malas (lazy) agar konstruksi provider tidak
  /// crash di mode demo/test saat Supabase belum terinisialisasi.
  ArticleRemoteDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Ambil semua artikel, terbaru di atas.
  Future<List<ArticleModel>> getAllArticles() async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.articles)
        .select()
        .order('published_at', ascending: false);
    return rows.map(ArticleModel.fromJson).toList();
  }

  /// Ambil satu artikel berdasarkan id, atau null bila tidak ada.
  Future<ArticleModel?> getArticleById(String id) async {
    final Map<String, dynamic>? row = await _client
        .from(AppTables.articles)
        .select()
        .eq('id', id)
        .maybeSingle();
    return row == null ? null : ArticleModel.fromJson(row);
  }
}
