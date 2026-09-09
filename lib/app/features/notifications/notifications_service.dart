import 'dart:io';

import 'package:flutter/material.dart' show Color, ValueNotifier;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/settings/domain/smart_notification_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  NotificationsService();
  static final instance = NotificationsService();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  Future<void>? _initializing;
  bool _canScheduleExact = true;
  final selectedRoute = ValueNotifier<String?>(null);

  static const _brandColor = Color(0xFF9F003D);

  Future<void> init() async {
    final inProgress = _initializing;
    if (inProgress != null) return inProgress;
    if (_initialized) return;

    final initialization = _initialize();
    _initializing = initialization;
    try {
      await initialization;
    } finally {
      if (identical(_initializing, initialization)) {
        _initializing = null;
      }
    }
  }

  Future<void> _initialize() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Moscow'));
    const androidInit = AndroidInitializationSettings('ic_stat_ngieu');
    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'lesson_reminder',
          actions: [
            DarwinNotificationAction.plain(
              'open_schedule',
              'Открыть расписание',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
        DarwinNotificationCategory(
          'schedule_change',
          actions: [
            DarwinNotificationAction.plain(
              'open_changes',
              'Посмотреть изменение',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );
    await _plugin.initialize(
      InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        selectedRoute.value = response.payload;
      },
    );
    _initialized = true;

    try {
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        selectedRoute.value = launchDetails?.notificationResponse?.payload;
      }
    } catch (_) {
      // Notification launch details are optional and must not block startup.
    }
    if (Platform.isAndroid) {
      try {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        _canScheduleExact =
            await android?.canScheduleExactNotifications() ?? false;
      } catch (_) {
        // Samsung and other OEM builds may restrict this call until the user
        // opens the app settings. Inexact notifications remain available.
        _canScheduleExact = false;
      }
    }
  }

  Future<bool> requestPermissions() async {
    await init();
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
        _canScheduleExact =
            await android?.canScheduleExactNotifications() ?? false;
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

  Future<bool> openSystemSettings() => openAppSettings();

  Future<void> scheduleLessonReminder(
    Lesson lesson, {
    int minutesBefore = 15,
    SmartNotificationSettings preferences = const SmartNotificationSettings(),
  }) async {
    await init();
    final notifyTime = lesson.startTime.subtract(
      Duration(minutes: minutesBefore),
    );
    if (notifyTime.isBefore(DateTime.now())) return;
    if (preferences.isQuietTime(notifyTime)) return;
    final id = _idFromString(lesson.id);
    final tzTime = tz.TZDateTime.from(notifyTime, tz.local);
    await _plugin.zonedSchedule(
      id,
      'Через $minutesBefore мин: ${lesson.subject}',
      _buildBody(lesson),
      tzTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'lesson_reminders',
          'Напоминания о парах',
          channelDescription: 'Уведомления о начале занятий',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_stat_ngieu',
          color: _brandColor,
          playSound: preferences.soundEnabled,
          enableVibration: preferences.vibrationEnabled,
          groupKey: 'lesson_reminders',
          styleInformation: BigTextStyleInformation(_buildBody(lesson)),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
          presentBadge: true,
          presentSound: preferences.soundEnabled,
          categoryIdentifier: 'lesson_reminder',
          threadIdentifier: 'lesson_reminders',
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: _canScheduleExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '/schedule',
    );
  }

  Future<void> showScheduleChangeNotification({
    required Lesson lesson,
    required String fingerprint,
    SmartNotificationSettings preferences = const SmartNotificationSettings(),
  }) async {
    await init();
    if (!preferences.scheduleChangesEnabled) return;
    final quiet = preferences.isQuietTime(DateTime.now());
    await _plugin.show(
      _idFromString('schedule-change:$fingerprint'),
      _changeTitle(lesson),
      _buildBody(lesson),
      NotificationDetails(
        android: AndroidNotificationDetails(
          quiet ? 'schedule_changes_silent' : 'schedule_changes',
          quiet ? 'Изменения расписания без звука' : 'Изменения расписания',
          channelDescription: 'Уведомления о новых изменениях в расписании',
          importance: quiet ? Importance.low : Importance.high,
          priority: quiet ? Priority.low : Priority.high,
          icon: 'ic_stat_ngieu',
          color: _brandColor,
          playSound: preferences.soundEnabled && !quiet,
          enableVibration: preferences.vibrationEnabled && !quiet,
          groupKey: 'schedule_changes',
          styleInformation: BigTextStyleInformation(_buildBody(lesson)),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
          presentBadge: true,
          presentSound: preferences.soundEnabled && !quiet,
          categoryIdentifier: 'schedule_change',
          threadIdentifier: 'schedule_changes',
          interruptionLevel: quiet
              ? InterruptionLevel.passive
              : InterruptionLevel.active,
        ),
      ),
      payload: '/schedule',
    );
  }

  Future<void> showTestNotification({
    SmartNotificationSettings preferences = const SmartNotificationSettings(),
  }) async {
    await init();
    await _plugin.show(
      _idFromString('notification-test'),
      'Уведомления НГИЭУ работают',
      'Следующая пара появится здесь вместе со временем и аудиторией.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'lesson_reminders',
          'Напоминания о парах',
          channelDescription: 'Уведомления о начале занятий',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_stat_ngieu',
          color: _brandColor,
          playSound: preferences.soundEnabled,
          enableVibration: preferences.vibrationEnabled,
          styleInformation: const BigTextStyleInformation(
            'Следующая пара появится здесь вместе со временем и аудиторией.',
          ),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
          presentBadge: true,
          presentSound: preferences.soundEnabled,
          categoryIdentifier: 'lesson_reminder',
          threadIdentifier: 'lesson_reminders',
        ),
      ),
      payload: '/schedule',
    );
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  String? takeSelectedRoute() {
    final route = selectedRoute.value;
    selectedRoute.value = null;
    return route;
  }

  Future<void> rescheduleFor(
    List<Lesson> lessons, {
    required int minutesBefore,
    required bool enabled,
    SmartNotificationSettings preferences = const SmartNotificationSettings(),
  }) async {
    await init();
    await _cancelLessonReminders();
    if (!enabled) return;
    final now = DateTime.now();
    final upcoming = lessons
        .where((l) => l.startTime.isAfter(now) && !l.isEvent)
        .take(50)
        .toList();
    for (final l in upcoming) {
      try {
        await scheduleLessonReminder(
          l,
          minutesBefore: minutesBefore,
          preferences: preferences,
        );
      } catch (_) {}
    }
  }

  Future<void> _cancelLessonReminders() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final notification in pending) {
      if (notification.payload == '/schedule') {
        await _plugin.cancel(notification.id);
      }
    }
  }

  String _buildBody(Lesson l) {
    final parts = <String>[];
    if (l.classroom.isNotEmpty) parts.add('Ауд. ${l.classroom}');
    if (l.teacherNames.isNotEmpty) parts.add(l.teacherNames.first);
    final t = _formatTime(l.startTime);
    return [t, ...parts].join(' • ');
  }

  String _formatTime(DateTime t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _changeTitle(Lesson l) {
    if (l.isEvent &&
        l.subject.toLowerCase() == 'мероприятие' &&
        l.classroom.isEmpty) {
      return 'Занятие отменено';
    }
    return 'Изменение в расписании: ${l.subject}';
  }

  int _idFromString(String s) {
    var h = 0;
    for (var i = 0; i < s.length; i++) {
      h = (h * 31 + s.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return h;
  }
}
