import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.cause});
  final String message;
  final int? statusCode;
  final Object? cause;

  factory ApiException.fromDio(DioException e) {
    final code = e.response?.statusCode;
    final msg = switch (e.type) {
      DioExceptionType.connectionTimeout => 'Превышено время соединения',
      DioExceptionType.receiveTimeout => 'Превышено время ответа',
      DioExceptionType.sendTimeout => 'Превышено время отправки',
      DioExceptionType.badCertificate => 'Ошибка сертификата',
      DioExceptionType.badResponse => 'Сервер вернул $code',
      DioExceptionType.cancel => 'Запрос отменён',
      DioExceptionType.connectionError => 'Нет соединения с сервером',
      DioExceptionType.unknown => 'Неизвестная ошибка сети',
    };
    return ApiException(msg, statusCode: code, cause: e);
  }

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' ($statusCode)' : ''}';
}
