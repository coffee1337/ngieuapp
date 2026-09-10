import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_api_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_db_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_repository_impl.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

import '../../../../helpers/test_helpers.dart';

class MockScheduleApiDataSource extends Mock implements ScheduleApiDataSource {}

class MockScheduleDbDataSource extends Mock implements ScheduleDbDataSource {}

void main() {
  late MockScheduleApiDataSource api;
  late MockScheduleDbDataSource db;
  late ScheduleRepositoryImpl repository;

  final weekStart = DateTime(2025, 3, 10);
  final weekEnd = DateTime(2025, 3, 17);
  const actorId = '42';
  final cachedLesson = makeLesson(date: DateTime(2025, 3, 10));
  final freshLesson = makeLesson(id: 'fresh', date: DateTime(2025, 3, 11));
  late List<Lesson> freshLessons;

  setUp(() {
    api = MockScheduleApiDataSource();
    db = MockScheduleDbDataSource();
    repository = ScheduleRepositoryImpl(api, db);
    freshLessons = [freshLesson];
  });

  test('uses a fresh cache without requesting the API', () async {
    when(
      () => db.getLessonsInRange(actorId, weekStart, weekEnd),
    ).thenAnswer((_) async => [cachedLesson]);
    when(
      () => db.isStale(actorId, const Duration(hours: 6)),
    ).thenAnswer((_) async => false);

    expect(await repository.watchWeek(actorId, weekStart).toList(), [
      [cachedLesson],
    ]);
    verifyNever(() => api.fetchSchedule(actorId, anchorDate: weekStart));
  });

  test('keeps cached lessons when a background refresh fails', () async {
    when(
      () => db.getLessonsInRange(actorId, weekStart, weekEnd),
    ).thenAnswer((_) async => [cachedLesson]);
    when(
      () => db.isStale(actorId, const Duration(hours: 6)),
    ).thenAnswer((_) async => true);
    when(
      () => api.fetchSchedule(actorId, anchorDate: weekStart),
    ).thenThrow(Exception('offline'));

    expect(await repository.watchWeek(actorId, weekStart).toList(), [
      [cachedLesson],
    ]);
  });

  test('manual refresh always requests and stores fresh lessons', () async {
    when(
      () => db.getLessonsInRange(actorId, weekStart, weekEnd),
    ).thenAnswer((_) async => [cachedLesson]);
    when(
      () => api.fetchSchedule(actorId, anchorDate: weekStart),
    ).thenAnswer((_) async => freshLessons);
    when(
      () => db.replaceForActor(actorId, freshLessons),
    ).thenAnswer((_) async {});

    final result = await repository.refreshWeek(actorId, weekStart);

    expect(result, [freshLesson]);
    verify(() => api.fetchSchedule(actorId, anchorDate: weekStart)).called(1);
    verify(() => db.replaceForActor(actorId, freshLessons)).called(1);
  });
}
