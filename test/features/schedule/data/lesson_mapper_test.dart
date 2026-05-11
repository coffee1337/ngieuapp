import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/schedule/data/lesson_mapper.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

void main() {
  group('LessonMapper.fromApi', () {
    test('parses valid API response into lessons', () {
      final json = {
        'dayName': 'Понедельник',
        'classTime': '8:30 / 10:00',
        'classNumberName': '1 пара',
        'subjects': ['Математика'],
        'notes': ['Лекция'],
        'offices': ['121'],
        'groups': ['ИТ-21'],
        'instructors': ['Иванов И.И.'],
        'isChange': false,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result, isNotEmpty);
      expect(result.first.subject, 'Математика');
      expect(result.first.classroom, '121');
      expect(result.first.type, LessonType.lecture);
      expect(result.first.pairNumber, 1);
      expect(result.first.parity, WeekParity.any);
      expect(result.first.startTime.hour, 8);
      expect(result.first.startTime.minute, 30);
      expect(result.first.endTime.hour, 10);
      expect(result.first.endTime.minute, 0);
    });

    test('returns empty list for unknown day name', () {
      final json = {
        'dayName': 'InvalidDay',
        'classTime': '8:30 / 10:00',
        'classNumberName': '1 пара',
        'subjects': ['Математика'],
      };

      expect(LessonMapper.fromApi(json), isEmpty);
    });

    test('returns empty list for invalid classTime format', () {
      final json = {
        'dayName': 'Понедельник',
        'classTime': 'invalid',
        'classNumberName': '1 пара',
        'subjects': ['Математика'],
      };

      expect(LessonMapper.fromApi(json), isEmpty);
    });

    test('parses practice type from note', () {
      final json = {
        'dayName': 'Вторник',
        'classTime': '10:15 / 11:45',
        'classNumberName': '2 пара',
        'subjects': ['Физика'],
        'notes': ['Практика'],
        'offices': ['205'],
        'groups': ['ИТ-21'],
        'instructors': ['Петров П.П.'],
        'isChange': false,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result.first.type, LessonType.practice);
    });

    test('parses lab type from note', () {
      final json = {
        'dayName': 'Среда',
        'classTime': '12:00 / 13:30',
        'classNumberName': '3 пара',
        'subjects': ['Информатика'],
        'notes': ['Лабораторная'],
        'offices': ['303'],
        'groups': ['ИТ-21'],
        'instructors': [],
        'isChange': false,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result.first.type, LessonType.lab);
    });

    test('detects event type from subject containing "мероприятие"', () {
      final json = {
        'dayName': 'Четверг',
        'classTime': '14:00 / 15:30',
        'classNumberName': '4 пара',
        'subjects': ['Мероприятие'],
        'notes': [],
        'offices': [],
        'groups': ['ИТ-21'],
        'instructors': [],
        'isChange': true,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result.first.type, LessonType.event);
      expect(result.first.isEvent, isTrue);
    });

    test('handles isChange with explicit date', () {
      final json = {
        'dayName': 'Понедельник',
        'classTime': '8:30 / 10:00',
        'classNumberName': '1 пара',
        'subjects': ['Физика'],
        'notes': ['Лекция'],
        'offices': ['121'],
        'groups': ['ИТ-21'],
        'instructors': ['Иванов И.И.'],
        'isChange': true,
        'date': '2025-03-10',
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result, hasLength(1));
      expect(result.first.date, DateTime(2025, 3, 10));
      expect(result.first.isChange, isTrue);
    });

    test('maps isUpperWeek=true to even parity', () {
      final json = {
        'dayName': 'Пятница',
        'classTime': '8:30 / 10:00',
        'classNumberName': '1 пара',
        'subjects': ['Химия'],
        'notes': ['Лекция'],
        'offices': ['101'],
        'groups': ['ИТ-21'],
        'instructors': [],
        'isChange': false,
        'isUpperWeek': true,
      };

      final result = LessonMapper.fromApi(json);

      expect(result.first.parity, WeekParity.even);
    });

    test('maps isUpperWeek=false to odd parity', () {
      final json = {
        'dayName': 'Пятница',
        'classTime': '8:30 / 10:00',
        'classNumberName': '1 пара',
        'subjects': ['Химия'],
        'notes': ['Лекция'],
        'offices': ['101'],
        'groups': ['ИТ-21'],
        'instructors': [],
        'isChange': false,
        'isUpperWeek': false,
      };

      final result = LessonMapper.fromApi(json);

      expect(result.first.parity, WeekParity.odd);
    });

    test('handles null/empty fields gracefully', () {
      final json = {
        'dayName': 'Суббота',
        'classTime': '8:30 / 10:00',
        'classNumberName': null,
        'subjects': null,
        'notes': null,
        'offices': null,
        'groups': null,
        'instructors': null,
        'isChange': false,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result, isNotEmpty);
      expect(result.first.subject, '');
      expect(result.first.classroom, '');
      expect(result.first.pairNumber, 0);
      expect(result.first.groupNames, isEmpty);
      expect(result.first.teacherNames, isEmpty);
    });

    test('deduplicates instructor names', () {
      final json = {
        'dayName': 'Понедельник',
        'classTime': '8:30 / 10:00',
        'classNumberName': '1 пара',
        'subjects': ['Математика'],
        'notes': ['Лекция'],
        'offices': ['121'],
        'groups': ['ИТ-21'],
        'instructors': ['Иванов И.И.', 'Иванов И.И.', 'Петров П.П.'],
        'isChange': false,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result.first.teacherNames, hasLength(2));
    });

    test('handles time with dash separator (8-30)', () {
      final json = {
        'dayName': 'Понедельник',
        'classTime': '8-30 / 10-00',
        'classNumberName': '1 пара',
        'subjects': ['Математика'],
        'notes': [],
        'offices': [],
        'groups': [],
        'instructors': [],
        'isChange': false,
        'isUpperWeek': null,
      };

      final result = LessonMapper.fromApi(json);

      expect(result, isNotEmpty);
      expect(result.first.startTime.hour, 8);
      expect(result.first.startTime.minute, 30);
    });
  });
}