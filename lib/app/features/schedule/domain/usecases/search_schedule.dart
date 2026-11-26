import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/schedule_repository.dart';

class SearchScheduleResult {
  const SearchScheduleResult({required this.lesson, required this.matchType});
  final Lesson lesson;
  final SearchMatchType matchType;
}

enum SearchMatchType { subject, teacher, classroom, group }

class SearchSchedule {
  SearchSchedule(this._repo);
  final ScheduleRepository _repo;

  /// Ищет занятия в БД за последние 2 недели и на 2 недели вперёд.
  /// Пустой запрос → пустой список.
  Future<List<SearchScheduleResult>> call(
    String query, {
    required Future<bool> Function(DateTime date) resolveIsUpperWeek,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return const [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final from = today.subtract(const Duration(days: 14));
    final to = today.add(const Duration(days: 14));
    final allLessons = await _repo.getAllLessonsInRange(from, to);

    final results = <SearchScheduleResult>[];
    final seen = <String>{};

    // Загружаем весь диапазон одним запросом, затем фильтруем в памяти.
    for (final l in allLessons) {
      if (l.date.isBefore(from) || !l.date.isBefore(to)) continue;
      final isUpperWeek = await resolveIsUpperWeek(l.date);
      if (!l.parity.matchesUpperWeek(isUpperWeek)) continue;
      final match = _matchType(l, q);
      if (match == null) continue;
      // Дедупликация — одно и то же занятие может быть повторено (разные группы)
      final key =
          '${l.date.toIso8601String()}|${l.pairNumber}|'
          '${l.subject}|${l.classroom}|${l.building}|'
          '${l.teacherNames.join(",")}|${l.groupNames.join(",")}';
      if (!seen.add(key)) continue;
      results.add(SearchScheduleResult(lesson: l, matchType: match));
    }

    // Сортировка: сначала по дате, потом по паре
    results.sort((a, b) {
      final dateCmp = a.lesson.date.compareTo(b.lesson.date);
      if (dateCmp != 0) return dateCmp;
      return a.lesson.pairNumber.compareTo(b.lesson.pairNumber);
    });

    return results;
  }

  SearchMatchType? _matchType(Lesson l, String q) {
    if (l.subject.toLowerCase().contains(q)) return SearchMatchType.subject;
    for (final t in l.teacherNames) {
      if (t.toLowerCase().contains(q)) return SearchMatchType.teacher;
    }
    if (l.classroom.toLowerCase().contains(q)) {
      return SearchMatchType.classroom;
    }
    for (final g in l.groupNames) {
      if (g.toLowerCase().contains(q)) return SearchMatchType.group;
    }
    return null;
  }
}
