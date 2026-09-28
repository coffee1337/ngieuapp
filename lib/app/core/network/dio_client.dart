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
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 10),
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
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 10),
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
      dio.interceptors.add(PrettyDioLogger(responseBody: false));
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          final retries = (e.requestOptions.extra['retries'] as int?) ?? 0;
          if (_shouldRetry(e) &&
              const {'GET', 'HEAD', 'OPTIONS'}.contains(
                e.requestOptions.method,
              ) &&
              retries < 2) {
            e.requestOptions.extra['retries'] = retries + 1;
            // Экспоненциальный бэкофф: 400мс, затем 1200мс.
            await Future<void>.delayed(
              Duration(milliseconds: 400 * (retries + 1) * (retries + 1)),
            );
            try {
              final r = await dio.fetch<dynamic>(e.requestOptions);
              return handler.resolve(r);
            } on DioException catch (retryError) {
              return handler.next(
                retries == 1 ? retryError : e,
              );
            }
          }
          handler.next(e);
        },
      ),
    );
  }

  static bool _shouldRetry(DioException e) {
    // Таймауты/сеть — всегда. 5xx — только для идемпотентных GET.
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.sendTimeout) {
      return true;
    }
    if (e.type == DioExceptionType.badResponse) {
      final code = e.response?.statusCode ?? 0;
      return code >= 500 && code < 600;
    }
    return false;
  }
}
