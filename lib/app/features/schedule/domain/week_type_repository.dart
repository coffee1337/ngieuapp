import 'week_type.dart';

abstract class WeekTypeRepository {
  /// Получает тип недели для указанной даты
  Future<WeekType> getWeekType(DateTime date);

  /// Получает тип недели для текущей даты
  Future<WeekType> getCurrentWeekType();
}
