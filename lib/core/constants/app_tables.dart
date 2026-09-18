// Konstanta nama tabel dan bucket Supabase.
//
// Semua nama tabel mengacu ke docs/DATABASE_SCHEMA.md. Dilarang hardcode
// nama tabel/bucket langsung di datasource.

/// Nama tabel dan bucket Supabase untuk Go Green.
class AppTables {
  AppTables._();

  static const String profiles = 'profiles';
  static const String checkpoints = 'checkpoints';
  static const String wasteLogs = 'waste_logs';
  static const String points = 'points';
  static const String rewards = 'rewards';
  static const String redemptions = 'redemptions';
  static const String articles = 'articles';

  static const String wastePhotosBucket = 'waste-photos';
  static const String avatarsBucket = 'avatars';
}