import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/week_type_cache_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type_repository.dart';

class WeekTypeRepositoryImpl implements WeekTypeRepository {
  WeekTypeRepositoryImpl(this._api, this._cache);
  final WeekTypeApiDataSource _api;
  final WeekTypeCacheDataSource _cache;

  @override
  Future<WeekType> getWeekType(DateTime date) async {
    // Пробуем загрузить из кэша
    final cached = await _cache.loadWeekType();
    if (cached != null && _isSameWeek(cached.date, date)) {
      return cached;
    }

    try {
      // Загружаем из API
      final weekType = await _api.getWeekType(date);
      await _cache.saveWeekType(weekType);
      return weekType;
    } catch (e) {
      // Если API недоступен, используем локальную логику
      return _fallbackWeekType(date);
    }
  }

  @override
  Future<WeekType> getCurrentWeekType() {
    return getWeekType(DateTime.now());
  }

  /// Проверяет, что даты относятся к одной неделе
  bool _isSameWeek(DateTime date1, DateTime date2) {
    final start1 = _startOfWeek(date1);
    final start2 = _startOfWeek(date2);
    return start1.year == start2.year &&
        start1.month == start2.month &&
        start1.day == start2.day;
  }

  /// Начало недели (понедельник)
  DateTime _startOfWeek(DateTime date) {
    final monday = date.subtract(
      Duration(days: date.weekday - DateTime.monday),
    );
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Fallback логика определения типа недели
  /// Используется если API недоступно
  WeekType _fallbackWeekType(DateTime date) {
    // Используем существующую локальную логику из DateExt
    final isEvenWeek = date.isEvenWeek;
    return WeekType(
      date: date,
      isUpperWeek: isEvenWeek, // isEvenWeek = isUpperWeek
    );
  }
}
