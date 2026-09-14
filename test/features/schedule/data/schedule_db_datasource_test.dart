import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/core/storage/app_database.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_db_datasource.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  late AppDatabase database;
  late ScheduleDbDataSource source;
  final monday = DateTime(2025, 3, 10);

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    source = ScheduleDbDataSource(database);
  });

  tearDown(() => database.close());

  test('day and week queries exclude the upper boundary', () async {
    await source.replaceForActor('42', [
      makeLesson(id: 'monday', date: monday),
      makeLesson(id: 'tuesday', date: DateTime(2025, 3, 11)),
      makeLesson(id: 'next-week', date: DateTime(2025, 3, 17)),
    ]);
    expect(
      (await source.getAllLessonsForDate(monday)).map((lesson) => lesson.id),
      ['monday'],
    );
    expect(
      (await source.getLessonsInRange(
        '42',
        monday,
        DateTime(2025, 3, 17),
      )).map((lesson) => lesson.id),
      unorderedEquals(['monday', 'tuesday']),
    );
  });

  test('round trips preserve domain IDs and isolate actor caches', () async {
    final lesson = makeLesson();
    await source.replaceForActor('42', [lesson]);
    await source.replaceForActor('43', [lesson]);
    final cached = await source.getAllLessonsForDate(monday);
    expect(cached, [lesson, lesson]);
    await source.replaceForActor('42', [cached.first]);
    expect(await source.getAllLessonsForDate(monday), [lesson, lesson]);
  });
}
