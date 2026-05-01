extension DateExt on DateTime {
  /// Начало дня (00:00:00.000)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Понедельник текущей недели (00:00)
  DateTime get startOfWeek {
    final monday = subtract(Duration(days: weekday - DateTime.monday));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Воскресенье текущей недели (23:59:59.999)
  DateTime get endOfWeek {
    final sunday = startOfWeek.add(const Duration(days: 6));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999);
  }

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Чётная/нечётная неделя учебного года. Ориентир: 1 сентября — нечётная.
  bool get isEvenWeek {
    final academicStart = DateTime(
      month >= 9 ? year : year - 1,
      9,
      1,
    ).startOfWeek;
    final diffDays = startOfWeek.difference(academicStart).inDays;
    final weekNum = (diffDays ~/ 7) + 1;
    return weekNum % 2 == 0;
  }
}
