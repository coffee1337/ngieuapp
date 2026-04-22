Future<List<Lesson>> getAllLessonsForDate(DateTime date) async {
  final dayStart = DateTime(date.year, date.month, date.day);
  final dayEnd = dayStart.add(const Duration(days: 1));
  final query = select(lessons)
    ..where((t) => t.date.isBetweenValues(dayStart, dayEnd));
  final rows = await query.get();
  return rows.map(LessonRow.toDomain).toList();
}