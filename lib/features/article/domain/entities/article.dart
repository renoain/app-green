// Entity Article (domain).

/// Artikel edukasi lingkungan Go Green.
class Article {
  const Article({
    required this.id,
    required this.title,
    this.excerpt,
    required this.paragraphs,
    this.coverUrl,
    required this.publishedAt,
    required this.createdAt,
  });

  /// ID unik artikel.
  final String id;

  /// Judul artikel.
  final String title;

  /// Ringkasan artikel.
  final String? excerpt;

  /// Konten paragraf artikel.
  final List<String> paragraphs;

  /// URL gambar sampul (null bila tidak ada).
  final String? coverUrl;

  /// Tanggal terbit.
  final DateTime publishedAt;

  /// Waktu artikel dibuat.
  final DateTime createdAt;
}
