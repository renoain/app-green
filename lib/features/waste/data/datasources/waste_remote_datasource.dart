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
  WasteRemoteDatasource({SupabaseClient? client})
      : _client = client ?? SupabaseService.instance.client;

  final SupabaseClient _client;

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
  /// (server_timestamp default now(), status default pending).
  Future<WasteLogModel> insertWasteLog({
    required String userId,
    String? checkpointId,
    required WasteCategory category,
    String? photoUrl,
    String? hash,
    double? latitude,
    double? longitude,
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
}