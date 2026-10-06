// Unit test WasteDummyDatasource (mock dio, tanpa json-server jalan).

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/waste/data/datasources/waste_dummy_datasource.dart';
import 'package:go_green/features/waste/data/models/waste_log_model.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

Map<String, dynamic> _logRow({
  String id = 'log-1',
  String status = 'pending',
}) {
  return <String, dynamic>{
    'id': id,
    'user_id': 'user-1',
    'checkpoint_id': 'cp-1',
    'category': 'organik',
    'photo_url': 'user-1/dummy.jpg',
    'hash': 'hash-1',
    'latitude': -6.2,
    'longitude': 106.8,
    'server_timestamp': '2026-10-01T08:00:00Z',
    'status': status,
    'source': 'manual',
    'created_at': '2026-10-01T08:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late WasteDummyDatasource datasource;

  setUp(() {
    dio = MockDio();
    datasource = WasteDummyDatasource(dio: dio);
  });

  group('WasteDummyDatasource.getWasteLogs', () {
    test('parse daftar log milik user', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_logRow(), _logRow(id: 'log-2')]));

      final List<WasteLogModel> logs = await datasource.getWasteLogs('user-1');

      expect(logs, hasLength(2));
      expect(logs.first.userId, 'user-1');
      expect(logs.first.category, WasteCategory.organik);
      verify(
        () => dio.get(
          '/waste_logs',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);
    });

    test('error jaringan dilempar ulang setelah dicatat', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => datasource.getWasteLogs('user-1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('WasteDummyDatasource.insertWasteLog', () {
    test('kirim POST dan parse hasil', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_logRow(id: 'log-baru')));

      final WasteLogModel log = await datasource.insertWasteLog(
        userId: 'user-1',
        category: WasteCategory.anorganik,
      );

      expect(log.id, 'log-baru');
      expect(log.status, WasteLogStatus.pending);
      verify(() => dio.post('/waste_logs', data: any(named: 'data')))
          .called(1);
    });
  });

  group('WasteDummyDatasource.checkDuplicateHash', () {
    test('true bila hash sudah ada', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response([_logRow()]));

      expect(await datasource.checkDuplicateHash('hash-1'), isTrue);
    });

    test('false bila hash belum ada', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async => _response(<Object?>[]));

      expect(await datasource.checkDuplicateHash('hash-baru'), isFalse);
    });
  });

  group('WasteDummyDatasource.uploadPhoto', () {
    test('kembalikan fileName tanpa upload', () async {
      final String path = await datasource.uploadPhoto(
        fileName: 'user-1/dummy.jpg',
        bytes: Uint8List.fromList(<int>[1, 2, 3]),
      );
      expect(path, 'user-1/dummy.jpg');
      verifyNever(() => dio.post(any(), data: any(named: 'data')));
    });
  });
}
