import 'package:ngieuapp/app/core/utils/app_platform.dart';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/usecases/get_next_lesson.dart';
import 'package:ngieuapp/app/features/widget/home_widget_keys.dart';
import 'package:ngieuapp/app/features/widget/home_widget_payload.dart';

/// Сервис для обновления виджета на домашнем экране.
class HomeWidgetService {
  HomeWidgetService();
  static final instance = HomeWidgetService();

  static const _appGroupId = 'group.ru.ngieu.mobile.ngieuapp';
  static const _androidProviders = [
    'NextLessonSquareWidgetProvider',
    'NextLessonTallWidgetProvider',
    'UpcomingLessonsWidgetProvider',
    'TomorrowScheduleWidgetProvider',
    'TodayScheduleWidgetProvider',
    'NextLessonWidgetProvider',
  ];
  static const _iosWidgets = [
    'NextLessonWidget',
    'WideNextLessonWidget',
    'UpcomingLessonsWidget',
    'TodayScheduleWidget',
    'TomorrowScheduleWidget',
    'LockScreenScheduleWidget',
  ];
  static final _getNextLesson = GetNextLesson();

  /// Обновляет виджет "Следующая пара" данными из списка занятий.
  Future<void> updateSchedule(
    List<Lesson> lessons, {
    bool enabled = true,
    bool showRoom = true,
  }) async {
    if (!enabled) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;

    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(_appGroupId);
    }

    final next = _getNextLesson(lessons);
    final now = DateTime.now();
    final HomeWidgetPayload payload;

    if (next == null) {
      payload = HomeWidgetPayload.empty(
        header: 'РАСПИСАНИЕ',
        title: 'Пар больше нет',
        updatedAt: now,
      );
    } else {
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

      payload = HomeWidgetPayload.nextLesson(
        header: header,
        subject: next.subject,
        time: timeStr,
        room: roomStr,
        updatedAt: now,
      );
    }

    final todayLessons =
        lessons
            .where((lesson) => _isSameDay(lesson.date, now) && !lesson.isEvent)
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final upcomingLessons =
        lessons
            .where((lesson) => lesson.endTime.isAfter(now) && !lesson.isEvent)
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final tomorrowLessons =
        lessons
            .where(
              (lesson) => _isSameDay(lesson.date, tomorrow) && !lesson.isEvent,
            )
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final todayPayload = HomeWidgetPayload(
      type: HomeWidgetType.todaySchedule,
      size: HomeWidgetSize.large,
      header: 'СЕГОДНЯ',
      subject: todayLessons.isEmpty ? 'Сегодня пар нет' : '',
      time: '',
      room: '',
      updatedAt: now,
      items: todayLessons
          .take(7)
          .map((lesson) => _widgetItem(lesson, showRoom: showRoom))
          .toList(),
      emptyTitle: 'Сегодня пар нет',
      emptyMessage: 'Расписание на сегодня пустое',
    );
    final data = payload.toWidgetData();
    final todayData = todayPayload.toWidgetData();
    data[HomeWidgetKeys.itemsCount] = todayLessons.take(7).length;
    for (var index = 0; index < 7; index++) {
      data[HomeWidgetKeys.itemTime(index)] =
          todayData[HomeWidgetKeys.itemTime(index)];
      data[HomeWidgetKeys.itemSubject(index)] =
          todayData[HomeWidgetKeys.itemSubject(index)];
      data[HomeWidgetKeys.itemRoom(index)] =
          todayData[HomeWidgetKeys.itemRoom(index)];
    }
    data[HomeWidgetKeys.upcomingCount] = upcomingLessons.take(3).length;
    for (var index = 0; index < 3; index++) {
      final lesson = upcomingLessons.elementAtOrNull(index);
      data[HomeWidgetKeys.upcomingTime(index)] = lesson == null
          ? ''
          : _timeRange(lesson);
      data[HomeWidgetKeys.upcomingSubject(index)] = lesson?.subject ?? '';
      data[HomeWidgetKeys.upcomingRoom(index)] = lesson == null || !showRoom
          ? ''
          : _roomText(lesson);
      data[HomeWidgetKeys.upcomingStart(index)] =
          lesson?.startTime.millisecondsSinceEpoch ?? 0;
      data[HomeWidgetKeys.upcomingEnd(index)] =
          lesson?.endTime.millisecondsSinceEpoch ?? 0;
    }
    data['widget_tomorrow_date'] = DateFormat('yyyy-MM-dd').format(tomorrow);
    data['widget_tomorrow_count'] = tomorrowLessons.take(4).length;
    for (var index = 0; index < 4; index++) {
      final lesson = tomorrowLessons.elementAtOrNull(index);
      data['widget_tomorrow_${index}_time'] = lesson == null
          ? ''
          : _timeRange(lesson);
      data['widget_tomorrow_${index}_subject'] = lesson?.subject ?? '';
      data['widget_tomorrow_${index}_room'] = lesson == null || !showRoom
          ? ''
          : _roomText(lesson);
    }

    for (final entry in data.entries) {
      await HomeWidget.saveWidgetData(entry.key, entry.value);
    }

    if (Platform.isAndroid) {
      for (final provider in _androidProviders) {
        await HomeWidget.updateWidget(androidName: provider);
      }
    } else {
      for (final widget in _iosWidgets) {
        await HomeWidget.updateWidget(iOSName: widget);
      }
    }
  }

  Future<void> updateNextLesson(
    List<Lesson> lessons, {
    bool enabled = true,
    bool showRoom = true,
  }) => updateSchedule(lessons, enabled: enabled, showRoom: showRoom);

  Future<void> reloadWidgets() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (Platform.isIOS) await HomeWidget.setAppGroupId(_appGroupId);
    if (Platform.isAndroid) {
      for (final provider in _androidProviders) {
        await HomeWidget.updateWidget(androidName: provider);
      }
      return;
    }
    for (final widget in _iosWidgets) {
      await HomeWidget.updateWidget(iOSName: widget);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _roomText(Lesson lesson) {
    if (lesson.classroom.isNotEmpty) return 'Ауд. ${lesson.classroom}';
    return '';
  }

  HomeWidgetItem _widgetItem(Lesson lesson, {required bool showRoom}) =>
      HomeWidgetItem(
        time: _timeRange(lesson),
        subject: lesson.subject,
        room: showRoom ? _roomText(lesson) : '',
      );

  String _timeRange(Lesson lesson) {
    final format = DateFormat('HH:mm');
    return '${format.format(lesson.startTime)}–${format.format(lesson.endTime)}';
  }
}
