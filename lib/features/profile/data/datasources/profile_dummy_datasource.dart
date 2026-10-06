// Data source profil dummy berbasis json-server (tanpa Supabase).

import 'package:dio/dio.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';
import '../models/profile_model.dart';

/// Data source profil untuk mode dummy. Baca/tulis ke tabel profiles di json-server sehingga edit nama dan email terlihat berubah di db.json.
class ProfileDummyDatasource {
  ProfileDummyDatasource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.dummyApiUrl));

  final Dio _dio;

  /// ID profil demo yang dipakai saat tidak ada sesi login (baris pertama db.json).
  static const String demoProfileId = '00000000-0000-0000-0000-000000000001';

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    return Map<String, dynamic>.from(response.data as Map);
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('ProfileDummyDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Ambil satu profil berdasarkan id, atau null bila tidak ada.
  Future<ProfileModel?> getProfileById(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get('/${AppTables.profiles}/$id');
      if (response.data == null) {
        return null;
      }
      return ProfileModel.fromJson(_asMap(response));
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getProfileById', error, stackTrace);
    }
  }

  /// Ubah username dan/atau email profil di json-server. Mengembalikan model hasil PATCH.
  Future<ProfileModel> updateProfile({
    required String id,
    String? username,
    String? email,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch(
        '/${AppTables.profiles}/$id',
        data: <String, dynamic>{
          if (username != null) 'username': username.trim(),
          if (email != null) 'email': email.trim(),
        },
      );
      return ProfileModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('updateProfile', error, stackTrace);
    }
  }
}
