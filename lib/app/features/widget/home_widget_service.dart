import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/get_next_lesson.dart';

/// Сервис для обновления виджета на домашнем экране.
class HomeWidgetService {
  HomeWidgetService();
  static final instance = HomeWidgetService();

  static const _androidProvider = 'NextLessonWidgetProvider';
  static final _getNextLesson = GetNextLesson();

  /// Обновляет виджет "Следующая пара" данными из списка занятий.
  Future<void> updateNextLesson(
    List<Lesson> lessons, {
    bool enabled = true,
    bool showRoom = true,
  }) async {
    if (!enabled) return;
    if (!Platform.isAndroid) return;

    final next = _getNextLesson(lessons);
    if (next == null) {
      await HomeWidget.saveWidgetData('widget_header', 'РАСПИСАНИЕ');
      await HomeWidget.saveWidgetData('widget_subject', 'Пар больше нет');
      await HomeWidget.saveWidgetData('widget_time', '');
      await HomeWidget.saveWidgetData('widget_room', '');
    } else {
      final now = DateTime.now();
      final isNow = now.isAfter(next.startTime) && now.isBefore(next.endTime);

      final timeFmt = DateFormat('HH:mm');
      final dayFmt = DateFormat('d MMM, HH:mm', 'ru_RU');
      final isToday = _isSameDay(now, next.date);

      final header = isNow
          ? 'СЕЙЧАС'
          : isToday
          ? 'СЛЕДУЮЩАЯ ПАРА'
          : 'БЛИЖАЙШАЯ ПАРА';

      final timeStr = isToday
          ? '${timeFmt.format(next.startTime)} — '
                '${timeFmt.format(next.endTime)}'
          : dayFmt.format(next.startTime);

      final roomStr = showRoom ? _roomText(next) : '';

      await HomeWidget.saveWidgetData('widget_header', header);
      await HomeWidget.saveWidgetData('widget_subject', next.subject);
      await HomeWidget.saveWidgetData('widget_time', timeStr);
      await HomeWidget.saveWidgetData('widget_room', roomStr);
    }

    await HomeWidget.updateWidget(androidName: _androidProvider);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _roomText(Lesson lesson) {
    if (lesson.classroom.isNotEmpty) return 'Ауд. ${lesson.classroom}';
    if (lesson.teacherNames.isNotEmpty) return lesson.teacherNames.first;
    return '';
  }
}
