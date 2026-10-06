// Unit test CheckpointDummyDatasource (mock dio, tanpa json-server jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:go_green/features/checkpoints/data/datasources/checkpoint_dummy_datasource.dart';
import 'package:go_green/features/checkpoints/data/models/checkpoint_model.dart';

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

Map<String, dynamic> _row({
  String id = 'cp-1',
  String name = 'Checkpoint RW 01',
  double latitude = -6.2,
  double longitude = 106.8,
  bool isActive = true,
}) {
  return <String, dynamic>{
    'id': id,
    'name': name,
    'address': 'Jl. Melati No. 10',
    'latitude': latitude,
    'longitude': longitude,
    'radius': 100,
    'qr_code': 'CP-001',
    'is_active': isActive,
    'created_at': '2026-09-01T00:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late CheckpointDummyDatasource datasource;

  setUp(() {
    dio = MockDio();
    datasource = CheckpointDummyDatasource(dio: dio);
  });

  group('CheckpointDummyDatasource.getAllCheckpoints', () {
    test('parse daftar checkpoint', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_row(), _row(id: 'cp-2')]));

      final List<CheckpointModel> items =
          await datasource.getAllCheckpoints();

      expect(items, hasLength(2));
      expect(items.first.name, 'Checkpoint RW 01');
    });

    test('error jaringan dilempar ulang setelah dicatat', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => datasource.getAllCheckpoints(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('CheckpointDummyDatasource.getCheckpointByQrCode', () {
    test('kembalikan null bila tidak ada yang cocok', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response(<Object?>[]));

      expect(await datasource.getCheckpointByQrCode('CP-999'), isNull);
    });
  });

  group('CheckpointDummyDatasource.getCheckpointById', () {
    test('kembalikan null saat server 404', () async {
      when(() => dio.get(any())).thenThrow(_notFound());

      expect(await datasource.getCheckpointById('cp-hilang'), isNull);
    });
  });

  group('CheckpointDummyDatasource.deactivateCheckpoint', () {
    test('kirim PATCH is_active false', () async {
      when(
        () => dio.patch(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_row(isActive: false)));

      await datasource.deactivateCheckpoint('cp-1');

      verify(
        () => dio.patch('/checkpoints/cp-1', data: {'is_active': false}),
      ).called(1);
    });
  });

  group('CheckpointDummyDatasource.getNearbyCheckpoints', () {
    test('saring yang di luar radius dan urutkan terdekat', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => _response([
          _row(id: 'cp-jauh', latitude: -6.5, longitude: 107.0),
          _row(id: 'cp-dekat'),
        ]),
      );

      final List<CheckpointModel> items =
          await datasource.getNearbyCheckpoints(
        latitude: -6.2,
        longitude: 106.8,
      );

      expect(items.map((CheckpointModel e) => e.id), ['cp-dekat']);
    });
  });
}
