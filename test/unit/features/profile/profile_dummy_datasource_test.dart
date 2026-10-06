// Unit test ProfileDummyDatasource (mock dio, tanpa json-server jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:go_green/features/profile/data/datasources/profile_dummy_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

DioException _notFound() {
  return DioException(
    requestOptions: RequestOptions(path: ''),
    response: _response('Not Found', statusCode: 404),
  );
}

Map<String, dynamic> _row({String username = 'user', String email = 'user@green.com'}) {
  return <String, dynamic>{
    'id': '00000000-0000-0000-0000-000000000001',
    'email': email,
    'username': username,
    'role': 'user',
    'created_at': '2026-09-01T00:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late ProfileDummyDatasource datasource;

  setUp(() {
    dio = MockDio();
    datasource = ProfileDummyDatasource(dio: dio);
  });

  group('ProfileDummyDatasource.getProfileById', () {
    test('parse satu profil', () async {
      when(() => dio.get(any())).thenAnswer((_) async => _response(_row()));

      final profile = await datasource.getProfileById(
        '00000000-0000-0000-0000-000000000001',
      );

      expect(profile?.username, 'user');
      expect(profile?.email, 'user@green.com');
    });

    test('kembalikan null saat server 404', () async {
      when(() => dio.get(any())).thenThrow(_notFound());

      expect(
        await datasource.getProfileById('id-hilang'),
        isNull,
      );
    });
  });

  group('ProfileDummyDatasource.updateProfile', () {
    test('kirim PATCH username dan email', () async {
      when(
        () => dio.patch(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => _response(_row(username: 'baru', email: 'baru@green.com')),
      );

      final profile = await datasource.updateProfile(
        id: '00000000-0000-0000-0000-000000000001',
        username: 'baru',
        email: 'baru@green.com',
      );

      verify(
        () => dio.patch(
          '/profiles/00000000-0000-0000-0000-000000000001',
          data: {'username': 'baru', 'email': 'baru@green.com'},
        ),
      ).called(1);
      expect(profile.username, 'baru');
    });

    test('error jaringan dilempar ulang setelah dicatat', () async {
      when(
        () => dio.patch(any(), data: any(named: 'data')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => datasource.updateProfile(id: 'x', username: 'y'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
