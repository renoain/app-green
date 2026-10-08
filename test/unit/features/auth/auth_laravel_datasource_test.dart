// Unit test AuthLaravelDatasource (mock dio, tanpa Laravel jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:go_green/features/auth/data/datasources/auth_laravel_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

Map<String, dynamic> _authBody({String token = 'token-abc'}) {
  return <String, dynamic>{
    'success': true,
    'data': <String, dynamic>{
      'user': <String, dynamic>{
        'id': 1,
        'name': 'User',
        'email': 'user@green.com',
      },
      'profile': <String, dynamic>{
        'id': '00000000-0000-0000-0000-000000000001',
        'email': 'user@green.com',
        'username': 'user',
        'role': 'user',
      },
      'token': token,
    },
  };
}

void main() {
  late MockDio dio;
  late AuthLaravelDatasource datasource;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dio = MockDio();
    datasource = AuthLaravelDatasource(dio: dio);
  });

  group('AuthLaravelDatasource.register', () {
    test('sukses kembalikan data dan simpan token', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_authBody(), statusCode: 201));

      final Map<String, dynamic> data = await datasource.register(
        name: 'User',
        email: 'user@green.com',
        password: 'password123',
      );

      expect(data['token'], 'token-abc');
      expect(await datasource.getToken(), 'token-abc');
      verify(() => dio.post('/register', data: any(named: 'data'))).called(1);
    });

    test('error diteruskan ke pemanggil', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/register')),
      );

      expect(
        () => datasource.register(
          name: 'User',
          email: 'user@green.com',
          password: 'password123',
        ),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('AuthLaravelDatasource.login', () {
    test('sukses kembalikan data dan simpan token', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_authBody()));

      final Map<String, dynamic> data = await datasource.login(
        email: 'user@green.com',
        password: 'password123',
      );

      expect((data['user'] as Map)['email'], 'user@green.com');
      expect(await datasource.getToken(), 'token-abc');
    });

    test('login 401 diteruskan sebagai DioException', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: _response(
            <String, dynamic>{'success': false},
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => datasource.login(
          email: 'user@green.com',
          password: 'salah',
        ),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('AuthLaravelDatasource.logout', () {
    test('hapus token lokal walau server gagal', () async {
      await datasource.saveToken('lama');
      when(
        () => dio.post(any(), options: any(named: 'options')),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/logout')),
      );

      await datasource.logout();

      expect(await datasource.getToken(), isNull);
    });
  });

  group('AuthLaravelDatasource.me', () {
    test('null bila belum login', () async {
      expect(await datasource.me(), isNull);
      verifyNever(() => dio.get(any(), options: any(named: 'options')));
    });

    test('kembalikan data bila token ada', () async {
      await datasource.saveToken('token-abc');
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': <String, dynamic>{
            'user': <String, dynamic>{'email': 'user@green.com'},
            'profile': <String, dynamic>{'username': 'user'},
          },
        }),
      );

      final Map<String, dynamic>? data = await datasource.me();

      expect(data?['profile']['username'], 'user');
    });
  });
}
