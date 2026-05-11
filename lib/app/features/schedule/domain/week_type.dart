import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'week_type.freezed.dart';
part 'week_type.g.dart';

@freezed
abstract class WeekType with _$WeekType {
  const factory WeekType({required DateTime date, required bool isUpperWeek}) =
      _WeekType;

  /// Создает WeekType из данных API (дата в формате "dd.MM.yyyy")
  factory WeekType.fromApiJson(Map<String, dynamic> json) {
    // Парсим дату из формата "dd.MM.yyyy"
    final dateStr = json['Date'] as String;
    final dateParsed = DateFormat('dd.MM.yyyy').parse(dateStr);

    return WeekType(date: dateParsed, isUpperWeek: json['IsUpperWeek'] as bool);
  }

  // ВНИМАНИЕ: Не используем fromJson напрямую с API, так как API возвращает дату в формате "dd.MM.yyyy"
  // Для парсинга из API используйте WeekTypeApiDataSource.getWeekType()
  factory WeekType.fromJson(Map<String, dynamic> json) =>
      _$WeekTypeFromJson(json);

  const WeekType._();

  /// Конвертирует isUpperWeek в isEvenWeek (верхняя неделя = четная?)
  bool get isEvenWeek => isUpperWeek;
}
