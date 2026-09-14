import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/core/cache/hive_cache.dart';
import 'package:ngieuapp/app/features/schedule/data/calendar_sync_local_datasource.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_calendar_service.dart';

final calendarSyncLocalDataSourceProvider = Provider((ref) {
  return CalendarSyncLocalDataSource(ref.watch(hiveCacheProvider));
});

final deviceCalendarPluginProvider = Provider((ref) {
  return DeviceCalendarPlugin();
});

final scheduleCalendarServiceProvider = Provider((ref) {
  return ScheduleCalendarService(
    ref.watch(calendarSyncLocalDataSourceProvider),
    plugin: ref.watch(deviceCalendarPluginProvider),
  );
});
