// Unit test ketahanan RegionRemoteDatasource (retry galat transien).
//
// Dio di-inject dengan interceptor skrip: gagal 522 lalu sukses,
// sehingga retry terbukti tanpa dependency mock baru.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/regions/data/datasources/region_remote_datasource.dart';

/// Dio skrip: tiap request dijawab langkah berikut, hitungan tercatat.
Dio _scriptedDio(List<Object> steps, void Function(int calls) onDone) {
  final Dio dio = Dio();
  int calls = 0;
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) {
        final Object step = steps[calls < steps.length ? calls : steps.length - 1];
        calls++;
        onDone(calls);
        if (step is int) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response<dynamic>(
                requestOptions: options,
                statusCode: step,
              ),
            ),
          );
          return;
        }
        handler.resolve(
          Response<dynamic>(requestOptions: options, data: step),
        );
      },
    ),
  );
  return dio;
}

void main() {
  group('RegionRemoteDatasource retry', () {
    test('522 lalu sukses mengembalikan daftar', () async {
      int calls = 0;
      final RegionRemoteDatasource datasource = RegionRemoteDatasource(
        dio: _scriptedDio(
          <Object>[
            522,
            <Map<String, dynamic>>[
              <String, dynamic>{'id': '35', 'name': 'JAWA TIMUR'},
            ],
          ],
          (int value) => calls = value,
        ),
      );
      final result = await datasource.getProvinces();
      expect(calls, 2);
      expect(result.single.id, '35');
    });

    test('522 terus-menerus mengembalikan kosong', () async {
      int calls = 0;
      final RegionRemoteDatasource datasource = RegionRemoteDatasource(
        dio: _scriptedDio(<Object>[522], (int value) => calls = value),
      );
      expect(await datasource.getProvinces(), isEmpty);
      expect(calls, RegionRemoteDatasource.listMaxAttempts);
    });

    test('404 tidak diulang', () async {
      int calls = 0;
      final RegionRemoteDatasource datasource = RegionRemoteDatasource(
        dio: _scriptedDio(<Object>[404], (int value) => calls = value),
      );
      expect(await datasource.getProvinces(), isEmpty);
      expect(calls, 1);
    });
  });
}
