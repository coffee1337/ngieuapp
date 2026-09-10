import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/core/network/api_endpoints.dart';

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
    } on DioException catch (error) {
      if (error.response?.statusCode != 400) rethrow;
      // Older API deployments require an explicit value. Keep them working,
      // while newer deployments can provide their authoritative current date.
      final fallbackDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
      return _request(fallbackDate, cancelToken: cancelToken);
    }
  }

  Future<WeekType> _request(String? date, {CancelToken? cancelToken}) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.weekTypeGet,
      queryParameters: date == null ? null : {'date': date},
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data == null || data.isEmpty) {
      throw Exception('API вернул пустой ответ для типа недели');
    }

    final firstItem = data.first as Map<String, dynamic>;

    // Используем фабричный метод для создания WeekType из данных API
    return WeekType.fromApiJson(firstItem);
  }
}
