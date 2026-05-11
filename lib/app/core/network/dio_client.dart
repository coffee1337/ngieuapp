import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ngieuapp/app/core/network/api_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  DioClient._();

  static Dio createScheduleApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.scheduleBase,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );
    _attachCommon(dio);
    return dio;
  }

  static Dio createNewsClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.newsBase,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.plain,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 13) NGIEU-Mobile/1.0',
        },
      ),
    );
    _attachCommon(dio);
    return dio;
  }

  static void _attachCommon(Dio dio) {
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(responseBody: false),
      );
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          if (_shouldRetry(e) && e.requestOptions.extra['retried'] != true) {
            e.requestOptions.extra['retried'] = true;
            dio
                .fetch(e.requestOptions)
                .then(
                  (r) => handler.resolve(r),
                  onError: (err) => handler.next(err as DioException),
                );
            return;
          }
          handler.next(e);
        },
      ),
    );
  }

  static bool _shouldRetry(DioException e) =>
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError;
}
