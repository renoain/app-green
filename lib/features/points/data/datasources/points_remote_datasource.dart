// Data source poin dan redemption berbasis Supabase.
//
// Membungkus pembacaan saldo/riwayat poin dan pengajuan penukaran reward.
// Dipanggil oleh repository/use case, bukan dari widget. Model poin khusus
// belum dibuat (mengembalikan Map sampai model poin disediakan).

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';

/// Data source poin dan redemption Go Green.
class PointsRemoteDatasource {
  /// Membuat data source poin. [client] bisa di-inject untuk test.
  ///
  /// Client Supabase diambil malas (lazy) agar konstruksi provider tidak
  /// crash di mode demo/test saat Supabase belum terinisialisasi.
  PointsRemoteDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Total poin user (earn dikurangi redeem).
  Future<int> getTotalPoints(String userId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.points)
        .select('amount,type')
        .eq('user_id', userId);
    int total = 0;
    for (final Map<String, dynamic> row in rows) {
      final int amount = row['amount'] as int? ?? 0;
      final PointType type = PointType.fromDb(row['type'] as String?);
      total += type == PointType.earn ? amount : -amount;
    }
    return total;
  }

  /// Riwayat poin user, terbaru di atas. Mengembalikan Map mentah karena
  /// model poin belum tersedia.
  Future<List<Map<String, dynamic>>> getPointsHistory(String userId) async {
    return _client
        .from(AppTables.points)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  /// Mencatat poin ke tabel points.
  ///
  /// Catatan: untuk mencegah kecurangan, insert ke tabel points dibatasi
  /// sisi server (tanpa policy insert untuk klien). Method ini dipakai
  /// oleh edge function/RPC pada fase lanjut.
  Future<void> addPoints({
    required String userId,
    required int amount,
    required PointType type,
    String? referenceId,
    String? description,
  }) async {
    await _client.from(AppTables.points).insert(<String, dynamic>{
      'user_id': userId,
      'amount': amount,
      'type': type.value,
      'reference_id': referenceId,
      'description': description,
    });
  }

  /// Mengajukan penukaran hadiah. Mengembalikan voucher code.
  Future<String> redeemPoints({
    required String userId,
    required String rewardId,
  }) async {
    final String voucherCode = _generateVoucherCode();
    await _client.from(AppTables.redemptions).insert(<String, dynamic>{
      'user_id': userId,
      'reward_id': rewardId,
      'status': 'pending',
      'qr_code': _generateQrCode(),
      'voucher_code': voucherCode,
    });
    await _client.from(AppTables.points).insert(<String, dynamic>{
      'user_id': userId,
      'amount': 0,
      'type': 'redeem',
      'reference_id': voucherCode,
      'description': 'Redeem reward: $rewardId',
    });
    return voucherCode;
  }

  /// Menghasilkan kode QR unik untuk klaim redemption.
  String _generateQrCode() {
    return const Uuid().v4();
  }

  /// Menghasilkan kode voucher unik.
  String _generateVoucherCode() {
    return const Uuid().v4().toUpperCase().substring(0, 8);
  }
}