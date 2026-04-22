import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio createScheduleApi() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://230352-2.vm.clodo.ru/api/v2/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));
    _attachCommon(dio);
    return dio;
  }

  static Dio createNewsClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://ngieu.ru/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.plain, // HTML, не JSON
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 13) NGIEU-Mobile/1.0',
      },
    ));
    _attachCommon(dio);
    return dio;
  }

  static void _attachCommon(Dio dio) {
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        responseBody: false, // HTML огромный — не спамим
        error: true,
      ));
    }
    dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        // Один ретрай на сетевые ошибки
        if (_shouldRetry(e) && e.requestOptions.extra['retried'] != true) {
          e.requestOptions.extra['retried'] = true;
          dio.fetch(e.requestOptions).then(
                (r) => handler.resolve(r),
                onError: (err) => handler.next(err as DioException),
              );
          return;
        }
        handler.next(e);
      },
    ));
  }

  static bool _shouldRetry(DioException e) =>
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError;
}