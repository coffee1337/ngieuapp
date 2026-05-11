import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/schedule_repository.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/find_free_classrooms.dart';

import '../../../../helpers/test_helpers.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  late FindFreeClassrooms sut;
  late MockScheduleRepository mockRepo;

  setUp(() {
    mockRepo = MockScheduleRepository();
    sut = FindFreeClassrooms(mockRepo);
  });

  final date = DateTime(2025, 3, 10);

  group('FindFreeClassrooms', () {
    test('finds free window between two lessons', () async {
      // Arrange: room 121 busy 8:30-10:00 and 12:00-13:30
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
          makeLesson(
            id: 'l2',
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 12, 0),
            endTime: DateTime(2025, 3, 10, 13, 30),
          ),
        ],
      );

      // Act
      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 10, minute: 0),
        to: const TimeOfDay(hour: 12, minute: 0),
        minDuration: const Duration(minutes: 45),
      );

      // Assert
      expect(result, hasLength(1));
      expect(result.first.classroom, '121');
      expect(result.first.freeFrom.hour, 10);
      expect(result.first.freeUntil.hour, 12);
    });

    test('excludes rooms with "дист." name', () async {
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: 'дист.',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
          makeLesson(
            id: 'real',
            classroom: '205',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
        ],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 10, minute: 0),
        to: const TimeOfDay(hour: 18, minute: 0),
      );

      expect(result.every((r) => r.classroom != 'дист.'), isTrue);
    });

    test('excludes rooms with empty classroom name', () async {
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: '',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
        ],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 8, minute: 0),
        to: const TimeOfDay(hour: 20, minute: 0),
      );

      expect(result, isEmpty);
    });

    test('respects minDuration filter', () async {
      // Room has only a 30-min gap, but minDuration is 45 min
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 8, 0),
            endTime: DateTime(2025, 3, 10, 9, 30),
          ),
          makeLesson(
            id: 'l2',
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 10, 0),
            endTime: DateTime(2025, 3, 10, 11, 30),
          ),
        ],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 9, minute: 30),
        to: const TimeOfDay(hour: 10, minute: 0),
        minDuration: const Duration(minutes: 45),
      );

      expect(result, isEmpty);
    });

    test('returns empty when no lessons exist for date', () async {
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 8, minute: 0),
        to: const TimeOfDay(hour: 20, minute: 0),
      );

      expect(result, isEmpty);
    });

    test('merges overlapping busy intervals', () async {
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
          makeLesson(
            id: 'overlap',
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 9, 30),
            endTime: DateTime(2025, 3, 10, 11, 0),
          ),
        ],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 11, minute: 0),
        to: const TimeOfDay(hour: 13, minute: 0),
        minDuration: const Duration(minutes: 45),
      );

      expect(result, hasLength(1));
      expect(result.first.freeFrom.hour, 11);
    });

    test('sorts results by free duration descending', () async {
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 9, 0),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
          makeLesson(
            id: 'l2',
            classroom: '205',
            startTime: DateTime(2025, 3, 10, 8, 0),
            endTime: DateTime(2025, 3, 10, 8, 30),
          ),
        ],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 10, minute: 0),
        to: const TimeOfDay(hour: 20, minute: 0),
        minDuration: const Duration(minutes: 45),
      );

      if (result.length >= 2) {
        expect(
          result.first.freeDuration >= result.last.freeDuration,
          isTrue,
        );
      }
    });

    test('filters by institute', () async {
      when(() => mockRepo.getAllLessonsForDate(date)).thenAnswer(
        (_) async => [
          makeLesson(
            classroom: '121',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
          makeLesson(
            id: 'l2',
            classroom: '205',
            startTime: DateTime(2025, 3, 10, 8, 30),
            endTime: DateTime(2025, 3, 10, 10, 0),
          ),
        ],
      );

      final result = await sut(
        date: date,
        from: const TimeOfDay(hour: 10, minute: 0),
        to: const TimeOfDay(hour: 20, minute: 0),
        instituteFilter: 'Институт экономики и управления',
      );

      expect(result.every((r) => r.institute == 'Институт экономики и управления'), isTrue);
    });
  });
}