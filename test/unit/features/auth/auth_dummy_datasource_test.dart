// Unit test AuthDummyDatasource (mock dio, tanpa json-server jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:go_green/features/auth/data/datasources/auth_dummy_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

Map<String, dynamic> _row({
  String id = 'user-1',
  String email = 'user@green.com',
  String username = 'user',
  String password = 'password123',
}) {
  return <String, dynamic>{
    'id': id,
    'email': email,
    'username': username,
    'password': password,
    'role': 'user',
    'fcm_token': null,
    'created_at': '2026-09-01T00:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late AuthDummyDatasource datasource;

  setUp(() {
    dio = MockDio();
    datasource = AuthDummyDatasource(dio: dio);
  });

  group('AuthDummyDatasource.signUp', () {
    test('register sukses menyimpan baris baru', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response(<Object?>[]));
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_row(email: 'baru@green.com')));

      final Map<String, dynamic> row = await datasource.signUp(
        email: 'baru@green.com',
        password: 'password123',
        username: 'baru',
      );

      expect(row['email'], 'baru@green.com');
      verify(() => dio.post('/profiles', data: any(named: 'data'))).called(1);
    });

    test('register gagal bila username sudah dipakai', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_row()]));

      expect(
        () => datasource.signUp(
          email: 'lain@green.com',
          password: 'password123',
          username: 'user',
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException e) => e.code,
            'code',
            'username_taken',
          ),
        ),
      );
    });

    test('register gagal bila email sudah dipakai', () async {
      var calls = 0;
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((Invocation invocation) async {
        calls += 1;
        if (calls == 1) {
          return _response(<Object?>[]);
        }
        return _response([_row()]);
      });

      expect(
        () => datasource.signUp(
          email: 'user@green.com',
          password: 'password123',
          username: 'baru',
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException e) => e.code,
            'code',
            'user_already_exists',
          ),
        ),
      );
    });
  });

  group('AuthDummyDatasource.signIn', () {
    test('login sukses bila password cocok', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_row()]));

      final Map<String, dynamic> row = await datasource.signIn(
        email: 'user@green.com',
        password: 'password123',
      );

      expect(row['username'], 'user');
    });

    test('login gagal bila password salah', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_row()]));

      expect(
        () => datasource.signIn(
          email: 'user@green.com',
          password: 'salah',
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException e) => e.code,
            'code',
            'invalid_credentials',
          ),
        ),
      );
    });

    test('login gagal bila email tidak ada', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response(<Object?>[]));

      expect(
        () => datasource.signIn(
          email: 'hilang@green.com',
          password: 'password123',
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('AuthDummyDatasource.isUsernameTaken', () {
    test('true bila username ada', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_row()]));

      expect(await datasource.isUsernameTaken('user'), isTrue);
    });

    test('false bila username bebas', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response(<Object?>[]));

      expect(await datasource.isUsernameTaken('bebas'), isFalse);
    });
  });

  group('AuthDummyDatasource.findEmailByUsername', () {
    test('kembalikan email bila username ada', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_row()]));

      expect(await datasource.findEmailByUsername('user'), 'user@green.com');
    });

    test('kembalikan null bila username tidak ada', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response(<Object?>[]));

      expect(await datasource.findEmailByUsername('hilang'), isNull);
    });
  });
}
