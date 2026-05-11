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
  Future<List<SearchScheduleResult>> call(String query) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return const [];

    final from = DateTime.now().subtract(const Duration(days: 14));
    final to = DateTime.now().add(const Duration(days: 14));

    final results = <SearchScheduleResult>[];
    final seen = <String>{};

    // Идём по дням и собираем всё, что совпадает
    for (var d = from; d.isBefore(to); d = d.add(const Duration(days: 1))) {
      final dayLessons = await _repo.getAllLessonsForDate(d);
      for (final l in dayLessons) {
        final match = _matchType(l, q);
        if (match == null) continue;
        // Дедупликация — одно и то же занятие может быть повторено (разные группы)
        final key =
            '${l.date.toIso8601String()}|${l.pairNumber}|${l.subject}|${l.classroom}|${l.teacherNames.join()}';
        if (!seen.add(key)) continue;
        results.add(SearchScheduleResult(lesson: l, matchType: match));
      }
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
