import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/widget/home_widget_keys.dart';
import 'package:ngieuapp/app/features/widget/home_widget_payload.dart';

void main() {
  group('HomeWidgetPayload', () {
    final updatedAt = DateTime.utc(2026, 5, 12, 9, 30);

    test('nextLesson writes legacy Android keys', () {
      final payload = HomeWidgetPayload.nextLesson(
        header: 'СЛЕДУЮЩАЯ ПАРА',
        subject: 'Математика',
        time: '09:30 — 11:00',
        room: 'Ауд. 101',
        updatedAt: updatedAt,
      );

      final data = payload.toWidgetData();

      expect(data[HomeWidgetKeys.header], 'СЛЕДУЮЩАЯ ПАРА');
      expect(data[HomeWidgetKeys.subject], 'Математика');
      expect(data[HomeWidgetKeys.time], '09:30 — 11:00');
      expect(data[HomeWidgetKeys.room], 'Ауд. 101');
    });

    test('empty writes readable state to legacy Android keys', () {
      final payload = HomeWidgetPayload.empty(
        header: 'РАСПИСАНИЕ',
        title: 'Пар больше нет',
        message: 'Можно отдохнуть',
        updatedAt: updatedAt,
      );

      final data = payload.toWidgetData();

      expect(data[HomeWidgetKeys.header], 'РАСПИСАНИЕ');
      expect(data[HomeWidgetKeys.subject], 'Пар больше нет');
      expect(data[HomeWidgetKeys.time], '');
      expect(data[HomeWidgetKeys.room], '');
    });

    test('writes additive metadata keys', () {
      final payload = HomeWidgetPayload.empty(
        header: 'СЕГОДНЯ',
        title: 'Пар нет',
        message: 'Расписание на сегодня пустое',
        type: HomeWidgetType.todaySchedule,
        size: HomeWidgetSize.large,
        updatedAt: updatedAt,
      );

      final data = payload.toWidgetData();

      expect(data[HomeWidgetKeys.type], 'todaySchedule');
      expect(data[HomeWidgetKeys.size], 'large');
      expect(data[HomeWidgetKeys.updatedAt], updatedAt.toIso8601String());
      expect(data[HomeWidgetKeys.emptyTitle], 'Пар нет');
      expect(data[HomeWidgetKeys.emptyMessage], 'Расписание на сегодня пустое');
      expect(data[HomeWidgetKeys.itemsCount], 0);
    });

    test('keeps room empty when room is not provided', () {
      final payload = HomeWidgetPayload.nextLesson(
        header: 'СЛЕДУЮЩАЯ ПАРА',
        subject: 'Физика',
        time: '11:10 — 12:40',
        updatedAt: updatedAt,
      );

      final data = payload.toWidgetData();

      expect(data[HomeWidgetKeys.room], '');
    });

    test('serializes type, size and updatedAt with stable enum names', () {
      final cases = [
        (
          type: HomeWidgetType.nextLesson,
          size: HomeWidgetSize.small,
          expectedType: 'nextLesson',
          expectedSize: 'small',
        ),
        (
          type: HomeWidgetType.todaySchedule,
          size: HomeWidgetSize.medium,
          expectedType: 'todaySchedule',
          expectedSize: 'medium',
        ),
        (
          type: HomeWidgetType.tomorrowSchedule,
          size: HomeWidgetSize.large,
          expectedType: 'tomorrowSchedule',
          expectedSize: 'large',
        ),
        (
          type: HomeWidgetType.groupSummary,
          size: HomeWidgetSize.medium,
          expectedType: 'groupSummary',
          expectedSize: 'medium',
        ),
        (
          type: HomeWidgetType.changes,
          size: HomeWidgetSize.small,
          expectedType: 'changes',
          expectedSize: 'small',
        ),
      ];

      for (final testCase in cases) {
        final payload = HomeWidgetPayload.empty(
          header: 'HEADER',
          title: 'TITLE',
          type: testCase.type,
          size: testCase.size,
          updatedAt: updatedAt,
        );

        final data = payload.toWidgetData();

        expect(data[HomeWidgetKeys.type], testCase.expectedType);
        expect(data[HomeWidgetKeys.size], testCase.expectedSize);
        expect(data[HomeWidgetKeys.updatedAt], updatedAt.toIso8601String());
      }
    });
  });
}
