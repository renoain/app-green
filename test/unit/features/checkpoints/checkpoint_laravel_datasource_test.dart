// Unit test CheckpointLaravelDatasource (mock dio, tanpa Laravel jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:go_green/features/checkpoints/data/datasources/checkpoint_laravel_datasource.dart';
import 'package:go_green/features/checkpoints/data/models/checkpoint_model.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

Map<String, dynamic> _row({String id = 'cp-1', bool active = true}) {
  return <String, dynamic>{
    'id': id,
    'name': 'TPS $id',
    'address': 'Jl. Hijau',
    'latitude': -7.0,
    'longitude': 110.4,
    'radius': 100,
    'qr_code': 'QR-$id',
    'code': null,
    'province_code': null,
    'city_code': null,
    'district_code': null,
    'subdistrict': null,
    'is_active': active,
    'max_uses': null,
    'remaining_uses': null,
    'created_at': '2026-09-01T00:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late CheckpointLaravelDatasource datasource;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dio = MockDio();
    datasource = CheckpointLaravelDatasource(dio: dio);
  });

  group('CheckpointLaravelDatasource.getAllCheckpoints', () {
    test('parse bungkus success/data', () async {
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': [_row(), _row(id: 'cp-2')],
        }),
      );

      final List<CheckpointModel> items = await datasource.getAllCheckpoints();

      expect(items, hasLength(2));
      expect(items.first.id, 'cp-1');
    });

    test('error diteruskan ke pemanggil', () async {
      when(() => dio.get(any(), options: any(named: 'options'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/checkpoints')),
      );

      expect(datasource.getAllCheckpoints, throwsA(isA<DioException>()));
    });
  });

  group('CheckpointLaravelDatasource.getActiveCheckpoints', () {
    test('filter nonaktif di klien', () async {
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': [_row(), _row(id: 'cp-2', active: false)],
        }),
      );

      final List<CheckpointModel> items =
          await datasource.getActiveCheckpoints();

      expect(items, hasLength(1));
      expect(items.first.id, 'cp-1');
    });
  });

  group('CheckpointLaravelDatasource.getCheckpointById', () {
    test('kembalikan model bila ada', () async {
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': _row(),
        }),
      );

      expect(await datasource.getCheckpointById('cp-1'), isNotNull);
    });

    test('null bila 404', () async {
      when(() => dio.get(any(), options: any(named: 'options'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/checkpoints/hilang'),
          response: _response('tidak ada', statusCode: 404),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(await datasource.getCheckpointById('hilang'), isNull);
    });
  });

  group('CheckpointLaravelDatasource.createCheckpoint', () {
    test('kirim POST dan parse hasil', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(
          <String, dynamic>{
            'success': true,
            'data': _row(id: 'cp-baru'),
          },
          statusCode: 201,
        ),
      );

      final CheckpointModel created = await datasource.createCheckpoint(
        name: 'TPS Baru',
        latitude: -7.0,
        longitude: 110.4,
        radius: 100,
      );

      expect(created.id, 'cp-baru');
      verify(
        () => dio.post(
          '/checkpoints',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}
