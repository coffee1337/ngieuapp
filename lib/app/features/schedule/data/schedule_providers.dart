import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/utils/date_ext.dart';
import '../domain/actor.dart';
import '../domain/lesson.dart';
import '../domain/schedule_repository.dart';
import '../domain/usecases/find_free_classrooms.dart';
import 'actors_api_datasource.dart';
import 'schedule_api_datasource.dart';
import 'schedule_db_datasource.dart';
import 'schedule_repository_impl.dart';

part 'schedule_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
ScheduleApiDataSource scheduleApiDataSource(ScheduleApiDataSourceRef ref) {
  return ScheduleApiDataSource(ref.watch(scheduleApiProvider));
}

@Riverpod(keepAlive: true)
ScheduleDbDataSource scheduleDbDataSource(ScheduleDbDataSourceRef ref) {
  return ScheduleDbDataSource(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
ActorsApiDataSource actorsApiDataSource(ActorsApiDataSourceRef ref) {
  return ActorsApiDataSource(ref.watch(scheduleApiProvider));
}

@Riverpod(keepAlive: true)
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  return ScheduleRepositoryImpl(
    ref.watch(scheduleApiDataSourceProvider),
    ref.watch(scheduleDbDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
FindFreeClassrooms findFreeClassrooms(FindFreeClassroomsRef ref) {
  return FindFreeClassrooms(ref.watch(scheduleRepositoryProvider));
}

/// Понедельник текущей недели (для открытия недельного расписания).
@riverpod
class CurrentWeekStart extends _$CurrentWeekStart {
  @override
  DateTime build() => DateTime.now().startOfWeek;

  void nextWeek() => state = state.add(const Duration(days: 7));
  void prevWeek() => state = state.subtract(const Duration(days: 7));
  void thisWeek() => state = DateTime.now().startOfWeek;
}

/// Список уроков на неделю (stream из репозитория).
@riverpod
Stream<List<Lesson>> weekSchedule(
  WeekScheduleRef ref,
  String actorId,
  DateTime weekStart,
) {
  return ref.watch(scheduleRepositoryProvider).watchWeek(actorId, weekStart);
}

/// Список групп студентов (из assets).
@riverpod
Future<List<Actor>> studentGroups(StudentGroupsRef ref) {
  return ref.watch(actorsApiDataSourceProvider).loadStudentGroups();
}

/// Список преподавателей (из assets).
@riverpod
Future<List<Actor>> teachers(TeachersRef ref) {
  return ref.watch(actorsApiDataSourceProvider).loadTeachers();
}