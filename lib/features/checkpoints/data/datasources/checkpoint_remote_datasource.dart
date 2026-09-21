// Data source checkpoint berbasis Supabase.
//
// Membungkus pembacaan daftar checkpoint. Strategi MVP: ambil semua
// checkpoint lalu hitung jarak di sisi client (docs/ARCHITECTURE.md 10.5);
// PostGIS baru dipakai nanti kalau jumlah checkpoint sudah banyak.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/geo_utils.dart';
import '../models/checkpoint_model.dart';

/// Jarak (meter) dan checkpoint terkait untuk pengurutan.
typedef _CheckpointWithDistance = ({CheckpointModel checkpoint, int distanceMeters});

/// Data source checkpoint Go Green.
class CheckpointRemoteDatasource {
  /// Membuat data source checkpoint. [client] bisa di-inject untuk test.
  ///
  /// Client Supabase diambil malas (lazy) agar konstruksi provider tidak
  /// crash di mode demo/test saat Supabase belum terinisialisasi.
  CheckpointRemoteDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Ambil semua checkpoint, diurutkan berdasarkan nama.
  Future<List<CheckpointModel>> getAllCheckpoints() async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.checkpoints)
        .select()
        .order('name', ascending: true);
    return rows.map(CheckpointModel.fromJson).toList();
  }

  /// Ambil checkpoint terdekat dari posisi user (client-side).
  ///
  /// Jarak dihitung memakai [GeoUtils.distanceMeters]; hasil diurutkan dari
  /// yang terdekat. Bila [onlyWithinRadius] true (default), hanya checkpoint
  /// yang berada di dalam radius masing-masing yang dikembalikan.
  Future<List<CheckpointModel>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
    bool onlyWithinRadius = true,
  }) async {
    final List<_CheckpointWithDistance> withDistance =
        <_CheckpointWithDistance>[];
    final List<CheckpointModel> all = await getAllCheckpoints();
    for (final CheckpointModel checkpoint in all) {
      final int distanceMeters = GeoUtils.distanceMeters(
        latitude,
        longitude,
        checkpoint.latitude,
        checkpoint.longitude,
      );
      if (!onlyWithinRadius || distanceMeters <= checkpoint.radius) {
        withDistance.add(
          (checkpoint: checkpoint, distanceMeters: distanceMeters),
        );
      }
    }
    withDistance.sort(
      (a, b) => a.distanceMeters.compareTo(b.distanceMeters),
    );
    return withDistance
        .map((_CheckpointWithDistance item) => item.checkpoint)
        .toList();
  }

  /// Ambil satu checkpoint berdasarkan id, atau null bila tidak ada.
  Future<CheckpointModel?> getCheckpointById(String id) async {
    final Map<String, dynamic>? row = await _client
        .from(AppTables.checkpoints)
        .select()
        .eq('id', id)
        .maybeSingle();
    return row == null ? null : CheckpointModel.fromJson(row);
  }

  /// Ambil satu checkpoint berdasarkan kode QR, atau null bila tidak ada.
  Future<CheckpointModel?> getCheckpointByQrCode(String qrCode) async {
    final Map<String, dynamic>? row = await _client
        .from(AppTables.checkpoints)
        .select()
        .eq('qr_code', qrCode)
        .maybeSingle();
    return row == null ? null : CheckpointModel.fromJson(row);
  }

  /// Tambah checkpoint baru (RLS: hanya admin, policy
  /// checkpoints_insert_admin).
  Future<CheckpointModel> createCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) async {
    final Map<String, dynamic> row = await _client
        .from(AppTables.checkpoints)
        .insert(<String, dynamic>{
          'name': name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          if (qrCode != null && qrCode.isNotEmpty) 'qr_code': qrCode,
          if (code != null && code.isNotEmpty) 'code': code,
          if (provinceCode != null && provinceCode.isNotEmpty)
            'province_code': provinceCode,
          if (cityCode != null && cityCode.isNotEmpty) 'city_code': cityCode,
          if (districtCode != null && districtCode.isNotEmpty)
            'district_code': districtCode,
          if (subdistrict != null && subdistrict.isNotEmpty)
            'subdistrict': subdistrict,
        })
        .select()
        .single();
    return CheckpointModel.fromJson(row);
  }

  /// Ubah checkpoint (RLS: hanya admin, policy checkpoints_update_admin).
  Future<CheckpointModel> updateCheckpoint({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) async {
    final Map<String, dynamic> row = await _client
        .from(AppTables.checkpoints)
        .update(<String, dynamic>{
          'name': name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          'qr_code': (qrCode == null || qrCode.isEmpty) ? null : qrCode,
          'code': (code == null || code.isEmpty) ? null : code,
          'province_code': (provinceCode == null || provinceCode.isEmpty)
              ? null
              : provinceCode,
          'city_code':
              (cityCode == null || cityCode.isEmpty) ? null : cityCode,
          'district_code': (districtCode == null || districtCode.isEmpty)
              ? null
              : districtCode,
          'subdistrict':
              (subdistrict == null || subdistrict.isEmpty) ? null : subdistrict,
        })
        .eq('id', id)
        .select()
        .single();
    return CheckpointModel.fromJson(row);
  }

  /// Hapus checkpoint (RLS: hanya admin, policy checkpoints_delete_admin).
  Future<void> deleteCheckpoint(String id) async {
    await _client.from(AppTables.checkpoints).delete().eq('id', id);
  }

  /// Tambah checkpoint baru (alias admin untuk [createCheckpoint]).
  Future<CheckpointModel> insertCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) {
    return createCheckpoint(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
  }

  /// Ubah checkpoint (alias admin untuk [updateCheckpoint]).
  Future<CheckpointModel> updateCheckpointRecord({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) {
    return updateCheckpoint(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
  }

  /// Nonaktifkan checkpoint.
  ///
  /// Skema checkpoints tidak punya kolom is_active dan skema dilarang
  /// diubah, jadi nonaktif = hapus permanen (RLS: hanya admin).
  Future<void> deactivateCheckpoint(String id) {
    return deleteCheckpoint(id);
  }
}