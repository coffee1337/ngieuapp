import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../schedule/domain/lesson.dart';

/// Сервис для обновления виджета на домашнем экране.
class HomeWidgetService {
  HomeWidgetService._();
  static final instance = HomeWidgetService._();

  static const _androidProvider = 'NextLessonWidgetProvider';

  /// Обновляет виджет "Следующая пара" данными из списка занятий.
  Future<void> updateNextLesson(List<Lesson> lessons) async {
    if (!Platform.isAndroid) return;

    final next = _findNext(lessons);
    if (next == null) {
      await HomeWidget.saveWidgetData('widget_header', 'РАСПИСАНИЕ');
      await HomeWidget.saveWidgetData('widget_subject', 'Пар больше нет');
      await HomeWidget.saveWidgetData('widget_time', '');
      await HomeWidget.saveWidgetData('widget_room', '');
    } else {
      final now = DateTime.now();
      final isNow =
          now.isAfter(next.startTime) && now.isBefore(next.endTime);

      final timeFmt = DateFormat('HH:mm');
      final dayFmt = DateFormat('d MMM, HH:mm', 'ru_RU');
      final isToday = _isSameDay(now, next.date);

      final header = isNow
          ? 'СЕЙЧАС'
          : isToday
              ? 'СЛЕДУЮЩАЯ ПАРА'
              : 'БЛИЖАЙШАЯ ПАРА';

      final timeStr = isToday
          ? '${timeFmt.format(next.startTime)} — ${timeFmt.format(next.endTime)}'
          : dayFmt.format(next.startTime);

      final roomStr = next.classroom.isEmpty
          ? (next.teacherNames.isEmpty ? '' : next.teacherNames.first)
          : 'Ауд. ${next.classroom}';

      await HomeWidget.saveWidgetData('widget_header', header);
      await HomeWidget.saveWidgetData('widget_subject', next.subject);
      await HomeWidget.saveWidgetData('widget_time', timeStr);
      await HomeWidget.saveWidgetData('widget_room', roomStr);
    }

    // Пнуть виджет, чтоб перерисовался
    await HomeWidget.updateWidget(
      androidName: _androidProvider,
    );
  }

  Lesson? _findNext(List<Lesson> lessons) {
    final now = DateTime.now();
    final future = lessons
        .where((l) => l.endTime.isAfter(now) && !l.isEvent)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return future.isEmpty ? null : future.first;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}