// Konstanta nama tabel dan bucket Supabase.

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
  static const String appSettings = 'app_settings';
  static const String adminAuditLogs = 'admin_audit_logs';

  static const String wastePhotosBucket = 'waste-photos';
  static const String avatarsBucket = 'avatars';
}
