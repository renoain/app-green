// Unit test PointsLaravelDatasource redeem (mock dio, tanpa Laravel jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:go_green/features/points/data/datasources/points_laravel_datasource.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

void main() {
  late MockDio dio;
  late PointsLaravelDatasource datasource;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dio = MockDio();
    datasource = PointsLaravelDatasource(dio: dio);
  });

  group('PointsLaravelDatasource.redeemPoints', () {
    test('pecah amount 100 jadi 2 entri 50 dengan reference_id id redemption',
        () async {
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': <String, dynamic>{'points_cost': 100},
        }),
      );
      when(
        () => dio.post(
          '/redemptions',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(
          <String, dynamic>{
            'success': true,
            'data': <String, dynamic>{
              'id': 'rd-36-char-0000-0000-0000-0000000001',
              'voucher_code': 'AB12CD34',
            },
          },
          statusCode: 201,
        ),
      );
      when(
        () => dio.post(
          '/points',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(
          <String, dynamic>{'success': true, 'data': <String, dynamic>{}},
          statusCode: 201,
        ),
      );

      final String voucher = await datasource.redeemPoints(
        userId: 'user-1',
        rewardId: 'reward-1',
      );

      expect(voucher, 'AB12CD34');
      final captured = verify(
        () => dio.post(
          '/points',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured;
      expect(captured, hasLength(2));
      for (final Object? raw in captured) {
        final Map<String, dynamic> sentBody =
            Map<String, dynamic>.from(raw as Map);
        expect(sentBody['amount'], 50);
        expect(
          sentBody['reference_id'],
          'rd-36-char-0000-0000-0000-0000000001',
        );
        expect(sentBody['type'], 'redeem');
      }
    });

    test('amount 30 cukup 1 entri', () async {
      when(
        () => dio.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _response(<String, dynamic>{
          'success': true,
          'data': <String, dynamic>{'points_cost': 30},
        }),
      );
      when(
        () => dio.post(
          '/redemptions',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(
          <String, dynamic>{
            'success': true,
            'data': <String, dynamic>{
              'id': 'rd-36-char-0000-0000-0000-0000000002',
              'voucher_code': 'EF56GH78',
            },
          },
          statusCode: 201,
        ),
      );
      when(
        () => dio.post(
          '/points',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _response(
          <String, dynamic>{'success': true, 'data': <String, dynamic>{}},
          statusCode: 201,
        ),
      );

      await datasource.redeemPoints(userId: 'user-1', rewardId: 'reward-1');

      final captured = verify(
        () => dio.post(
          '/points',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      ).captured;
      expect(captured, hasLength(1));
      final Map<String, dynamic> sentBody =
          Map<String, dynamic>.from(captured.single as Map);
      expect(sentBody['amount'], 30);
    });
  });
}
