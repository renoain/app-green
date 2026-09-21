// Data source pembuangan sampah berbasis Supabase.
//
// Membungkus upload foto bukti (storage) dan CRUD waste_logs. Dipanggil
// oleh repository/use case, bukan dari widget.

import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/waste_log_model.dart';

/// Data source waste log Go Green.
class WasteRemoteDatasource {
  /// Membuat data source waste log. [client] bisa di-inject untuk test.
  ///
  /// Client Supabase diambil malas (lazy) agar konstruksi provider tidak
  /// crash di mode demo/test saat Supabase belum terinisialisasi.
  WasteRemoteDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Upload foto bukti ke bucket waste-photos.
  ///
  /// [fileName] adalah path lengkap `<userId>/<timestamp>_<hash>.jpg`.
  /// Mengembalikan path yang disimpan di kolom photo_url.
  Future<String> uploadPhoto({
    required String fileName,
    required Uint8List bytes,
  }) async {
    if (bytes.length > AppValues.maxPhotoBytes) {
      throw ArgumentError('Ukuran foto melebihi batas maksimal 5 MB.');
    }
    return _client.storage
        .from(AppTables.wastePhotosBucket)
        .uploadBinary(fileName, bytes);
  }

  /// Menyimpan log pembuangan sampah. Timestamp dan status diisi server
  /// (server_timestamp default now(), status default pending). Kolom source
  /// diisi [WasteSource.qrScan] saat audit dari QR, manual saat pilih manual.
  Future<WasteLogModel> insertWasteLog({
    required String userId,
    String? checkpointId,
    required WasteCategory category,
    String? photoUrl,
    String? hash,
    double? latitude,
    double? longitude,
    WasteSource source = WasteSource.manual,
  }) async {
    final Map<String, dynamic> row = await _client
        .from(AppTables.wasteLogs)
        .insert(<String, dynamic>{
          'user_id': userId,
          'checkpoint_id': checkpointId,
          'category': category.value,
          'photo_url': photoUrl,
          'hash': hash,
          'latitude': latitude,
          'longitude': longitude,
          'source': source.value,
        })
        .select()
        .single();
    return WasteLogModel.fromJson(row);
  }

  /// Mengambil daftar waste log milik user, terbaru di atas.
  Future<List<WasteLogModel>> getWasteLogs(String userId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.wasteLogs)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows.map(WasteLogModel.fromJson).toList();
  }

  /// Mengambil waste log berstatus pending untuk verifikasi admin/petugas,
  /// lengkap dengan username pengirim dan nama checkpoint.
  Future<List<WasteLogModel>> getPendingWasteLogs() async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.wasteLogs)
        .select('*, profiles(username), checkpoints(name)')
        .eq('status', WasteLogStatus.pending.value)
        .order('created_at', ascending: true);
    return rows.map(WasteLogModel.fromJson).toList();
  }

  /// Memverifikasi waste log (update status oleh admin/petugas).
  Future<WasteLogModel> verifyWasteLog({
    required String id,
    required WasteLogStatus status,
    required String verifiedBy,
    String? notes,
  }) async {
    final Map<String, dynamic> row = await _client
        .from(AppTables.wasteLogs)
        .update(<String, dynamic>{
          'status': status.value,
          'verified_by': verifiedBy,
          'verified_at': DateTime.now().toUtc().toIso8601String(),
          'notes': notes,
        })
        .eq('id', id)
        .select()
        .single();
    return WasteLogModel.fromJson(row);
  }

  /// Menyetujui waste log (status verified oleh admin/petugas).
  ///
  /// Poin earn sudah dicatat saat submit (SubmitWasteUsecase), jadi approve
  /// hanya mengubah status tanpa insert poin ulang.
  Future<WasteLogModel> approveWasteLog({
    required String id,
    required String verifiedBy,
  }) {
    return verifyWasteLog(
      id: id,
      status: WasteLogStatus.verified,
      verifiedBy: verifiedBy,
    );
  }

  /// Menolak waste log (status rejected + alasan di notes).
  Future<WasteLogModel> rejectWasteLog({
    required String id,
    required String verifiedBy,
    required String reason,
  }) {
    return verifyWasteLog(
      id: id,
      status: WasteLogStatus.rejected,
      verifiedBy: verifiedBy,
      notes: reason,
    );
  }

  /// URL bertanda tangan untuk foto bukti (bucket waste-photos privat).
  Future<String> getPhotoSignedUrl(String path, {int expiresIn = 3600}) {
    return _client.storage
        .from(AppTables.wastePhotosBucket)
        .createSignedUrl(path, expiresIn);
  }
  ///
  /// Mengembalikan true bila ada waste log dengan hash yang sama.
  Future<bool> checkDuplicateHash(String hash) async {
    final Map<String, dynamic>? row = await _client
        .from(AppTables.wasteLogs)
        .select('id')
        .eq('hash', hash)
        .maybeSingle();
    return row != null;
  }

  /// Menghitung jumlah waste log user sejak awal hari ini (UTC).
  ///
  /// Dipakai untuk rate limit (docs/DATABASE_SCHEMA.md bagian 8.6).
  Future<int> countTodayWasteLogs(String userId) async {
    final DateTime start = DateTime.now().toUtc();
    final DateTime startOfDayUtc = DateTime.utc(
      start.year,
      start.month,
      start.day,
    );
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.wasteLogs)
        .select('id')
        .eq('user_id', userId)
        .gte('created_at', startOfDayUtc.toIso8601String());
    return rows.length;
  }
}