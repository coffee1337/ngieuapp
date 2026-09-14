import 'dart:collection';

import 'package:device_calendar/device_calendar.dart' as dc;
import 'package:flutter/material.dart';
import 'package:ngieuapp/app/features/schedule/data/calendar_sync_local_datasource.dart';
import 'package:ngieuapp/app/features/schedule/domain/calendar_sync_result.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleCalendarService {
  ScheduleCalendarService(
    this._localDataSource, {
    dc.DeviceCalendarPlugin? plugin,
  }) : _plugin = plugin ?? dc.DeviceCalendarPlugin();

  final CalendarSyncLocalDataSource _localDataSource;
  final dc.DeviceCalendarPlugin _plugin;

  static const calendarName = 'НГИЭУ';
  static const _markerPrefix = 'ngieuapp:lesson:';
  static const _campusTimeZone = 'Europe/Moscow';

  Future<CalendarSyncResult> syncWeek({
    required List<Lesson> lessons,
    required DateTime weekStart,
    required String actorName,
    int reminderMinutes = 15,
  }) async {
    await _ensurePermission();
    final calendarsResult = await _plugin.retrieveCalendars();
    if (!calendarsResult.isSuccess || calendarsResult.data == null) {
      throw CalendarSyncException(_errors(calendarsResult.errors));
    }

    final calendarId = await _resolveCalendarId(calendarsResult.data!);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final existingResult = await _plugin.retrieveEvents(
      calendarId,
      dc.RetrieveEventsParams(startDate: weekStart, endDate: weekEnd),
    );
    if (!existingResult.isSuccess || existingResult.data == null) {
      throw CalendarSyncException(_errors(existingResult.errors));
    }

    final existingByLessonId = <String, dc.Event>{};
    for (final event in existingResult.data!) {
      final lessonId = lessonIdFromDescription(event.description);
      if (lessonId != null) existingByLessonId[lessonId] = event;
    }

    var created = 0;
    var updated = 0;
    final activeIds = <String>{};
    final location = tz.getLocation(_campusTimeZone);
    for (final lesson in lessons) {
      activeIds.add(lesson.id);
      final existing = existingByLessonId[lesson.id];
      final event = dc.Event(
        calendarId,
        eventId: existing?.eventId,
        title: lesson.subject,
        description: buildDescription(lesson, actorName: actorName),
        start: tz.TZDateTime.from(lesson.startTime, location),
        end: tz.TZDateTime.from(lesson.endTime, location),
        location: buildLocation(lesson),
        reminders: [dc.Reminder(minutes: reminderMinutes)],
      );
      final result = await _plugin.createOrUpdateEvent(event);
      if (result == null || !result.isSuccess) {
        throw CalendarSyncException(
          result == null
              ? 'Системный календарь не принял событие.'
              : _errors(result.errors),
        );
      }
      if (existing == null) {
        created++;
      } else {
        updated++;
      }
    }

    var removed = 0;
    for (final entry in existingByLessonId.entries) {
      if (activeIds.contains(entry.key)) continue;
      final eventId = entry.value.eventId;
      if (eventId == null) continue;
      final result = await _plugin.deleteEvent(calendarId, eventId);
      if (result.isSuccess && result.data == true) removed++;
    }

    return CalendarSyncResult(
      created: created,
      updated: updated,
      removed: removed,
    );
  }

  Future<void> _ensurePermission() async {
    final current = await _plugin.hasPermissions();
    if (current.isSuccess && current.data == true) return;
    final requested = await _plugin.requestPermissions();
    if (!requested.isSuccess || requested.data != true) {
      throw const CalendarSyncException(
        'Разрешите НГИЭУ доступ к календарю в настройках устройства.',
      );
    }
  }

  Future<String> _resolveCalendarId(
    UnmodifiableListView<dc.Calendar> calendars,
  ) async {
    final savedId = await _localDataSource.getCalendarId();
    for (final calendar in calendars) {
      if (calendar.id == savedId && calendar.isReadOnly != true) {
        return calendar.id!;
      }
    }
    if (savedId != null) await _localDataSource.clearCalendarId();

    for (final calendar in calendars) {
      if (calendar.name == calendarName &&
          calendar.isReadOnly != true &&
          calendar.id != null) {
        await _localDataSource.saveCalendarId(calendar.id!);
        return calendar.id!;
      }
    }

    final created = await _plugin.createCalendar(
      calendarName,
      calendarColor: const Color(0xFF9F003D),
      localAccountName: calendarName,
    );
    if (created.isSuccess && created.data != null) {
      await _localDataSource.saveCalendarId(created.data!);
      return created.data!;
    }

    for (final calendar in calendars) {
      if (calendar.isDefault == true &&
          calendar.isReadOnly != true &&
          calendar.id != null) {
        await _localDataSource.saveCalendarId(calendar.id!);
        return calendar.id!;
      }
    }
    throw CalendarSyncException(_errors(created.errors));
  }

  static String buildDescription(Lesson lesson, {required String actorName}) {
    final lines = <String>[
      'Расписание НГИЭУ · $actorName',
      if (lesson.teacherNames.isNotEmpty)
        'Преподаватель: ${lesson.teacherNames.join(', ')}',
      if (lesson.groupNames.isNotEmpty)
        'Группа: ${lesson.groupNames.join(', ')}',
      if (lesson.note?.trim().isNotEmpty ?? false) lesson.note!.trim(),
      '$_markerPrefix${lesson.id}',
    ];
    return lines.join('\n');
  }

  static String buildLocation(Lesson lesson) => [
    lesson.building.trim(),
    lesson.classroom.trim().isEmpty ? '' : 'ауд. ${lesson.classroom.trim()}',
  ].where((part) => part.isNotEmpty).join(', ');

  static String? lessonIdFromDescription(String? description) {
    if (description == null) return null;
    for (final line in description.split('\n')) {
      if (line.startsWith(_markerPrefix)) {
        final id = line.substring(_markerPrefix.length).trim();
        return id.isEmpty ? null : id;
      }
    }
    return null;
  }

  static String _errors(List<dc.ResultError> errors) {
    if (errors.isEmpty) return 'Не удалось синхронизировать календарь.';
    return errors.map((error) => error.errorMessage).join('\n');
  }
}
