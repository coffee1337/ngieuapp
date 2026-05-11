import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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

    final response = await _dio.get<List<dynamic>>(
      'WeekType/Get',
      queryParameters: {'date': dateStr},
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

  /// Получает тип недели для текущей даты
  Future<WeekType> getCurrentWeekType({CancelToken? cancelToken}) {
    return getWeekType(DateTime.now(), cancelToken: cancelToken);
  }
}
