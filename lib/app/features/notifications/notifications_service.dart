import 'dart:io';

import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../schedule/domain/lesson.dart';

class NotificationsService {
  NotificationsService._();
  static final instance = NotificationsService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _brandColor = Color(0xFF9F003D);

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Moscow'));
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (!status.isGranted) return false;
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canSchedule = await android?.canScheduleExactNotifications();
      if (canSchedule == false) {
        await android?.requestExactAlarmsPermission();
      }
      return true;
    }
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return false;
  }

  Future<void> scheduleLessonReminder(
    Lesson lesson, {
    int minutesBefore = 15,
  }) async {
    final notifyTime = lesson.startTime.subtract(
      Duration(minutes: minutesBefore),
    );
    if (notifyTime.isBefore(DateTime.now())) return;
    final id = _idFromString(lesson.id);
    final tzTime = tz.TZDateTime.from(notifyTime, tz.local);
    await _plugin.zonedSchedule(
      id,
      'Через $minutesBefore мин: ${lesson.subject}',
      _buildBody(lesson),
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'lesson_reminders',
          'Напоминания о парах',
          channelDescription: 'Уведомления о начале занятий',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: _brandColor,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() async => _plugin.cancelAll();

  Future<void> rescheduleFor(
    List<Lesson> lessons, {
    required int minutesBefore,
    required bool enabled,
  }) async {
    await cancelAll();
    if (!enabled) return;
    final now = DateTime.now();
    final upcoming = lessons
        .where((l) => l.startTime.isAfter(now) && !l.isEvent)
        .take(50)
        .toList();
    for (final l in upcoming) {
      try {
        await scheduleLessonReminder(l, minutesBefore: minutesBefore);
      } catch (_) {}
    }
  }

  String _buildBody(Lesson l) {
    final parts = <String>[];
    if (l.classroom.isNotEmpty) parts.add('Ауд. ${l.classroom}');
    if (l.teacherNames.isNotEmpty) parts.add(l.teacherNames.first);
    final t = _formatTime(l.startTime);
    return [t, ...parts].join(' * ');
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  int _idFromString(String s) {
    var h = 0;
    for (var i = 0; i < s.length; i++) {
      h = (h * 31 + s.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return h;
  }
}
