import '../domain/lesson.dart';
import '../domain/schedule_repository.dart';
import 'schedule_api_datasource.dart';
import 'schedule_db_datasource.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(this._api, this._db);
  final ScheduleApiDataSource _api;
  final ScheduleDbDataSource _db;

  static const _ttl = Duration(hours: 6);

  @override
  Stream<List<Lesson>> watchWeek(String actorId, DateTime weekStart) async* {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final cached = await _db.getLessonsInRange(actorId, weekStart, weekEnd);
    if (cached.isNotEmpty) yield cached;

    final stale = await _db.isStale(actorId, _ttl);
    if (stale || cached.isEmpty) {
      try {
        final fresh = await _api.fetchSchedule(actorId);
        await _db.replaceForActor(actorId, fresh);
        yield fresh
            .where(
              (l) => !l.date.isBefore(weekStart) && l.date.isBefore(weekEnd),
            )
            .toList();
      } catch (e) {
        if (cached.isEmpty) rethrow;
      }
    }
  }

  @override
  Future<List<Lesson>> getAllLessonsForDate(DateTime date) =>
      _db.getAllLessonsForDate(date);
}
