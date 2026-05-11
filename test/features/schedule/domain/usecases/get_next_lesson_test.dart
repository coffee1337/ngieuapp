import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/get_next_lesson.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late GetNextLesson sut;

  setUp(() {
    sut = GetNextLesson();
  });

  group('GetNextLesson', () {
    final now = DateTime(2025, 3, 10, 10, 30);

    test('returns nearest future lesson', () {
      // Arrange
      final lessons = [
        makeLesson(
          id: 'past',
          startTime: DateTime(2025, 3, 10, 8, 30),
          endTime: DateTime(2025, 3, 10, 10, 0),
        ),
        makeLesson(
          id: 'current',
          startTime: DateTime(2025, 3, 10, 10, 15),
          endTime: DateTime(2025, 3, 10, 11, 45),
        ),
        makeLesson(
          id: 'future',
          startTime: DateTime(2025, 3, 10, 12, 0),
          endTime: DateTime(2025, 3, 10, 13, 30),
        ),
      ];

      // Act
      final result = sut(lessons, now: now);

      // Assert
      expect(result?.id, 'current');
    });

    test('skips events', () {
      final lessons = [
        makeLesson(
          id: 'event',
          startTime: DateTime(2025, 3, 10, 11, 0),
          endTime: DateTime(2025, 3, 10, 12, 0),
          isEvent: true,
        ),
        makeLesson(
          id: 'lecture',
          startTime: DateTime(2025, 3, 10, 12, 0),
          endTime: DateTime(2025, 3, 10, 13, 30),
        ),
      ];

      final result = sut(lessons, now: now);

      expect(result?.id, 'lecture');
    });

    test('returns null when no future lessons', () {
      final lessons = [
        makeLesson(
          id: 'past',
          startTime: DateTime(2025, 3, 10, 8, 0),
          endTime: DateTime(2025, 3, 10, 9, 30),
        ),
      ];

      final result = sut(lessons, now: now);

      expect(result, isNull);
    });

    test('returns null for empty list', () {
      expect(sut([], now: now), isNull);
    });

    test('includes lesson still in progress (endTime after now)', () {
      final lessons = [
        makeLesson(
          id: 'ongoing',
          startTime: DateTime(2025, 3, 10, 9, 0),
          endTime: DateTime(2025, 3, 10, 11, 0),
        ),
      ];

      final result = sut(lessons, now: now);

      expect(result?.id, 'ongoing');
    });

    test('returns earliest when multiple future lessons exist', () {
      final lessons = [
        makeLesson(
          id: 'later',
          startTime: DateTime(2025, 3, 10, 14, 0),
          endTime: DateTime(2025, 3, 10, 15, 30),
        ),
        makeLesson(
          id: 'sooner',
          startTime: DateTime(2025, 3, 10, 12, 0),
          endTime: DateTime(2025, 3, 10, 13, 30),
        ),
      ];

      final result = sut(lessons, now: now);

      expect(result?.id, 'sooner');
    });

    test('excludes lesson whose endTime equals now exactly', () {
      final lessons = [
        makeLesson(
          id: 'just-ended',
          startTime: DateTime(2025, 3, 10, 9, 0),
          endTime: now,
        ),
      ];

      final result = sut(lessons, now: now);

      expect(result, isNull);
    });
  });
}
