import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

abstract interface class ScheduleRepository {
  /// Отдаёт расписание на неделю. Сначала из кэша, затем свежее из сети.
  Stream<List<Lesson>> watchWeek(String actorId, DateTime weekStart);

  /// Все занятия всех акторов в указанный день (для поиска свободных кабинетов).
  Future<List<Lesson>> getAllLessonsForDate(DateTime date);
}
