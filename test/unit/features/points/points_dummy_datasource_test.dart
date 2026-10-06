// Unit test PointsDummyDatasource (mock dio, tanpa json-server jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/points/data/datasources/points_dummy_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

Map<String, dynamic> _row({int amount = 25, String type = 'earn'}) {
  return <String, dynamic>{
    'id': 'point-1',
    'user_id': 'user-1',
    'amount': amount,
    'type': type,
    'created_at': '2026-10-01T08:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late PointsDummyDatasource datasource;

  setUp(() {
    dio = MockDio();
    datasource = PointsDummyDatasource(dio: dio);
  });

  group('PointsDummyDatasource.getTotalPoints', () {
    test('earn dikurangi redeem', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => _response([_row(amount: 25), _row(amount: 100, type: 'redeem')]),
      );

      expect(await datasource.getTotalPoints('user-1'), -75);
    });

    test('error jaringan dilempar ulang setelah dicatat', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => datasource.getTotalPoints('user-1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('PointsDummyDatasource.addPoints', () {
    test('kirim POST poin earn', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_row()));

      await datasource.addPoints(
        userId: 'user-1',
        amount: 25,
        type: PointType.earn,
      );

      verify(() => dio.post('/points', data: any(named: 'data'))).called(1);
    });
  });

  group('PointsDummyDatasource.redeemPoints', () {
    test('kembalikan voucher 8 karakter dan catat redeem', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(<String, dynamic>{}));

      final String voucher = await datasource.redeemPoints(
        userId: 'user-1',
        rewardId: 'reward-1',
      );

      expect(voucher, hasLength(8));
      verify(() => dio.post('/redemptions', data: any(named: 'data')))
          .called(1);
      verify(() => dio.post('/points', data: any(named: 'data'))).called(1);
    });
  });
}
