// Unit test WasteLaravelDatasource (mock dio, tanpa Laravel jalan).

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/waste/data/datasources/waste_laravel_datasource.dart';
import 'package:go_green/features/waste/data/models/waste_log_model.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

Map<String, dynamic> _row({String id = 'log-1', String hash = 'hash-1'}) {
  return <String, dynamic>{
    'id': id,
    'user_id': 'user-1',
    'checkpoint_id': 'cp-1',
    'category': 'organik',
    'photo_url': 'user-1/foto.jpg',
    'hash': hash,
    'latitude': -7.0,
    'longitude': 110.4,
    'server_timestamp': '2026-09-01T00:00:00Z',
    'status': 'pending',
    'verified_by': null,
    'verified_at': null,
    'notes': null,
    'source': 'manual',
    'created_at': '2026-09-01T00:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late WasteLaravelDatasource datasource;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dio = MockDio();
    datasource = WasteLaravelDatasource(dio: dio);
  });

  group('WasteLaravelDatasource.insertWasteLog', () {
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
            'data': _row(),
          },
          statusCode: 201,
        ),
      );

      final WasteLogModel log = await datasource.insertWasteLog(
        userId: 'user-1',
        checkpointId: 'cp-1',
        category: WasteCategory.organik,
        hash: 'hash-1',
      );

      expect(log.id, 'log-1');
      verify(
        () => dio.post(
          '/waste-logs',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('error diteruskan ke pemanggil', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/waste-logs')),
      );

      expect(
        () => datasource.insertWasteLog(
          userId: 'user-1',
          category: WasteCategory.organik,
        ),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('WasteLaravelDatasource.getWasteLogs', () {
    test('parse daftar success/data', () async {
      when(
        () => dio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': [_row(), _row(id: 'log-2')],
        }),
      );

      expect(await datasource.getWasteLogs('user-1'), hasLength(2));
    });
  });

  group('WasteLaravelDatasource.checkDuplicateHash', () {
    test('true bila hash ada', () async {
      when(
        () => dio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': [_row()],
        }),
      );

      expect(await datasource.checkDuplicateHash('hash-1'), isTrue);
    });

    test('false bila hash bebas', () async {
      when(
        () => dio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': <Object>[],
        }),
      );

      expect(await datasource.checkDuplicateHash('bebas'), isFalse);
    });
  });

  group('WasteLaravelDatasource.approveWasteLog', () {
    test('pakai endpoint approve', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': {..._row(), 'status': 'verified'},
        }),
      );

      final WasteLogModel log = await datasource.approveWasteLog(
        id: 'log-1',
        verifiedBy: 'petugas-1',
      );

      expect(log.status, WasteLogStatus.verified);
      verify(
        () => dio.post(
          '/waste-logs/log-1/approve',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });

  group('WasteLaravelDatasource.rejectWasteLog', () {
    test('kirim rejection_reason sesuai validasi server', () async {
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': {
            ..._row(),
            'status': 'rejected',
            'rejection_reason': 'foto tidak jelas',
          },
        }),
      );

      final WasteLogModel log = await datasource.rejectWasteLog(
        id: 'log-1',
        verifiedBy: 'petugas-1',
        reason: 'foto tidak jelas',
      );

      expect(log.status, WasteLogStatus.rejected);
      expect(log.rejectionReason, 'foto tidak jelas');
      final captured = verify(
        () => dio.post(
          '/waste-logs/log-1/reject',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured;
      final Map<String, dynamic> sentBody =
          Map<String, dynamic>.from(captured.single as Map);
      expect(sentBody['rejection_reason'], 'foto tidak jelas');
      expect(sentBody.containsKey('notes'), isFalse);
    });
  });

  group('WasteLaravelDatasource.uploadPhoto', () {
    test('kembalikan fileName tanpa request jaringan', () async {
      final String path = await datasource.uploadPhoto(
        fileName: 'user-1/foto.jpg',
        bytes: Uint8List.fromList(<int>[1, 2, 3]),
      );

      expect(path, 'user-1/foto.jpg');
      verifyNever(() => dio.post(any()));
    });
  });
}
