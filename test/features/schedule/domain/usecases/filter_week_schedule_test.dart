import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/filter_week_schedule.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late FilterWeekSchedule sut;

  setUp(() {
    sut = FilterWeekSchedule();
  });

  final monday = DateTime(2025, 3, 10);

  group('FilterWeekSchedule — date filtering', () {
    test('includes only lessons within the week range', () {
      final lessons = [
        makeLesson(id: 'in-week', date: DateTime(2025, 3, 12)),
        makeLesson(id: 'before', date: DateTime(2025, 3, 9)),
        makeLesson(id: 'after', date: DateTime(2025, 3, 17)),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: false,
      );

      expect(result.map((l) => l.id), contains('in-week'));
      expect(result.map((l) => l.id), isNot(contains('before')));
      expect(result.map((l) => l.id), isNot(contains('after')));
    });

    test('includes lesson on weekStart, excludes on weekEnd', () {
      final lessons = [
        makeLesson(id: 'on-start', date: monday),
        makeLesson(id: 'on-end', date: monday.add(const Duration(days: 7))),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: false,
      );

      expect(result.map((l) => l.id), contains('on-start'));
      expect(result.map((l) => l.id), isNot(contains('on-end')));
    });
  });

  group('FilterWeekSchedule — parity', () {
    test('shows even-parity lesson on even week', () {
      final lessons = [
        makeLesson(id: 'even', date: monday, parity: WeekParity.even),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: false,
      );

      expect(result, hasLength(1));
    });

    test('hides even-parity lesson on odd week', () {
      final lessons = [
        makeLesson(id: 'even', date: monday, parity: WeekParity.even),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: false,
        showChanges: false,
      );

      expect(result, isEmpty);
    });

    test('shows any-parity lesson regardless of week type', () {
      final lessons = [
        makeLesson(id: 'any', date: monday, parity: WeekParity.any),
      ];

      final resultEven = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: false,
      );
      final resultOdd = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: false,
        showChanges: false,
      );

      expect(resultEven, hasLength(1));
      expect(resultOdd, hasLength(1));
    });
  });

  group('FilterWeekSchedule — changes', () {
    test('change replaces regular lesson in same cell when showChanges=true',
        () {
      final lessons = [
        makeLesson(
          id: 'regular',
          date: monday,
          pairNumber: 1,
          isChange: false,
        ),
        makeLesson(
          id: 'change',
          date: monday,
          pairNumber: 1,
          isChange: true,
          classroom: '205',
        ),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: true,
      );

      expect(result.map((l) => l.id), contains('change'));
      expect(result.map((l) => l.id), isNot(contains('regular')));
    });

    test('shows regular lesson when showChanges=false', () {
      final lessons = [
        makeLesson(
          id: 'regular',
          date: monday,
          pairNumber: 1,
          isChange: false,
        ),
        makeLesson(
          id: 'change',
          date: monday,
          pairNumber: 1,
          isChange: true,
        ),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: false,
      );

      expect(result.map((l) => l.id), contains('regular'));
      expect(result.map((l) => l.id), isNot(contains('change')));
    });

    test('cancellation: empty-classroom event shows "Занятие отменено"', () {
      final lessons = [
        makeLesson(
          id: 'cancel',
          date: monday,
          pairNumber: 1,
          isChange: true,
          isEvent: true,
          subject: 'Мероприятие',
          classroom: '',
        ),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: true,
      );

      expect(result, hasLength(1));
      expect(result.first.subject, 'Занятие отменено');
      expect(result.first.isEvent, isTrue);
    });

    test('non-empty classroom change is shown as-is', () {
      final lessons = [
        makeLesson(
          id: 'moved',
          date: monday,
          pairNumber: 1,
          isChange: true,
          isEvent: true,
          subject: 'Мероприятие',
          classroom: '305',
        ),
      ];

      final result = sut(
        lessons: lessons,
        weekStart: monday,
        isEvenWeek: true,
        showChanges: true,
      );

      expect(result, hasLength(1));
      expect(result.first.id, 'moved');
    });
  });

  group('FilterWeekSchedule — empty input', () {
    test('returns empty list for empty lessons', () {
      final result = sut(
        lessons: [],
        weekStart: monday,
        isEvenWeek: true,
        showChanges: true,
      );

      expect(result, isEmpty);
    });
  });
}
