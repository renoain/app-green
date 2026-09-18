// Model Article (data layer).
//
// extends Article untuk dipakai domain; fromJson menyesuaikan format kolom
// tabel articles (snake_case). Kolom content satu teks dengan paragraf
// dipisah baris kosong ganda.

import '../../domain/entities/article.dart';

/// Model data [Article] untuk komunikasi dengan Supabase.
class ArticleModel extends Article {
  /// Membuat model dari field entity.
  const ArticleModel({
    required super.id,
    required super.title,
    super.excerpt,
    required super.paragraphs,
    super.coverUrl,
    required super.publishedAt,
    required super.createdAt,
  });

  /// Membangun model dari respons JSON Supabase.
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final String content = json['content'] as String? ?? '';
    final List<String> paragraphs = content
        .split('\n\n')
        .map((String part) => part.trim())
        .where((String part) => part.isNotEmpty)
        .toList(growable: false);
    return ArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      paragraphs: paragraphs,
      coverUrl: json['cover_url'] as String?,
      publishedAt: _parseDateTime(json['published_at']),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
