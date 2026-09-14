import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_calendar_service.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  test('builds a readable calendar description with a stable marker', () {
    final lesson = makeLesson(id: 'lesson-42', note: 'Лекция');

    final description = ScheduleCalendarService.buildDescription(
      lesson,
      actorName: 'ИТ-21',
    );

    expect(description, contains('Расписание НГИЭУ · ИТ-21'));
    expect(description, contains('Преподаватель: Иванов И.И.'));
    expect(description, contains('ngieuapp:lesson:lesson-42'));
    expect(
      ScheduleCalendarService.lessonIdFromDescription(description),
      'lesson-42',
    );
  });

  test('formats classroom without an empty building prefix', () {
    final lesson = makeLesson(classroom: '220');

    expect(ScheduleCalendarService.buildLocation(lesson), 'ауд. 220');
  });
}
