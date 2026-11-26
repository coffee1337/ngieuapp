import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/core/network/api_endpoints.dart';
import 'package:ngieuapp/app/core/network/api_exception.dart';

import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';

class WeekTypeApiDataSource {
  WeekTypeApiDataSource(this._dio);
  final Dio _dio;

  /// Получает тип недели для указанной даты
  /// Формат даты в запросе: "dd.MM.yyyy"
  /// API возвращает: [{"Date":"27.04.2026","IsUpperWeek":false}]
  Future<WeekType> getWeekType(
    DateTime date, {
    CancelToken? cancelToken,
  }) async {
    // Форматируем дату в формат dd.MM.yyyy
    final dateStr = DateFormat('dd.MM.yyyy').format(date);

    return _request(dateStr, cancelToken: cancelToken);
  }

  /// Получает текущую дату и тип недели с сервера.
  Future<WeekType> getCurrentWeekType({CancelToken? cancelToken}) async {
    try {
      return await _request(null, cancelToken: cancelToken);
    } on ApiException catch (error) {
      if (error.statusCode != 400) rethrow;
      // Older API deployments require an explicit value. Keep them working,
      // while newer deployments can provide their authoritative current date.
      final fallbackDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
      return _request(fallbackDate, cancelToken: cancelToken);
    }
  }

  Future<WeekType> _request(String? date, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.weekTypeGet,
        queryParameters: date == null ? null : {'date': date},
        cancelToken: cancelToken,
      );

      final data = _extractRawList(response.data);
      if (data.isEmpty) {
        throw const FormatException('API вернул пустой ответ для типа недели');
      }

      final firstRaw = data.first;
      if (firstRaw is! Map) {
        throw const FormatException(
          'API вернул некорректный тип недели: ожидался объект',
        );
      }
      final firstItem = Map<String, dynamic>.from(firstRaw);

      // Используем фабричный метод для создания WeekType из данных API
      return WeekType.fromApiJson(firstItem);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } on FormatException catch (e) {
      throw ApiException('Некорректные данные типа недели: ${e.message}');
    }
  }

  List<dynamic> _extractRawList(Object? data) => switch (data) {
    final List<dynamic> list => list,
    final Map<dynamic, dynamic> map when map['data'] is List<dynamic> =>
      map['data'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['result'] is List<dynamic> =>
      map['result'] as List<dynamic>,
    final Map<dynamic, dynamic> map when map['items'] is List<dynamic> =>
      map['items'] as List<dynamic>,
    _ => const <dynamic>[],
  };
}
