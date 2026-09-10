import 'package:ngieuapp/app/features/notifications/schedule_change_notifications_service.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_db_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(
    this._api,
    this._db, {
    ScheduleChangeNotificationsService? changeNotifications,
  }) : _changeNotifications = changeNotifications;

  final ScheduleApiDataSource _api;
  final ScheduleDbDataSource _db;
  final ScheduleChangeNotificationsService? _changeNotifications;

  static const _ttl = Duration(hours: 6);

  @override
  Stream<List<Lesson>> watchWeek(String actorId, DateTime weekStart) async* {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final cached = await _db.getLessonsInRange(actorId, weekStart, weekEnd);
    if (cached.isNotEmpty) yield cached;

    final stale = await _db.isStale(actorId, _ttl);
    if (stale || cached.isEmpty) {
      try {
        final fresh = await _fetchAndStore(actorId, cached, weekStart);
        yield _lessonsForWeek(fresh, weekStart, weekEnd);
      } catch (e) {
        if (cached.isEmpty) rethrow;
      }
    }
  }

  @override
  Future<List<Lesson>> refreshWeek(String actorId, DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final cached = await _db.getLessonsInRange(actorId, weekStart, weekEnd);
    final fresh = await _fetchAndStore(actorId, cached, weekStart);
    return _lessonsForWeek(fresh, weekStart, weekEnd);
  }

  @override
  Future<List<Lesson>> getAllLessonsForDate(DateTime date) =>
      _db.getAllLessonsForDate(date);

  Future<List<Lesson>> _fetchAndStore(
    String actorId,
    List<Lesson> previous,
    DateTime anchorDate,
  ) async {
    final fresh = await _api.fetchSchedule(actorId, anchorDate: anchorDate);
    await _changeNotifications?.notifyAboutNewChanges(
      actorId: actorId,
      oldLessons: previous,
      freshLessons: fresh,
    );
    await _db.replaceForActor(actorId, fresh);
    return fresh;
  }

  List<Lesson> _lessonsForWeek(
    List<Lesson> lessons,
    DateTime weekStart,
    DateTime weekEnd,
  ) => lessons
      .where((l) => !l.date.isBefore(weekStart) && l.date.isBefore(weekEnd))
      .toList();
}
