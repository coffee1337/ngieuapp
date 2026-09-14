import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
import 'package:ngieuapp/app/core/cache/hive_cache.dart';

class CalendarSyncLocalDataSource {
  CalendarSyncLocalDataSource(this._cache);

  final HiveCache _cache;

  static const _calendarIdKey = 'calendar_id';

  Future<String?> getCalendarId() async {
    final box = await _cache.openBox<String>(HiveBoxes.calendarSync);
    return box.get(_calendarIdKey);
  }

  Future<void> saveCalendarId(String calendarId) async {
    final box = await _cache.openBox<String>(HiveBoxes.calendarSync);
    await box.put(_calendarIdKey, calendarId);
  }

  Future<void> clearCalendarId() async {
    final box = await _cache.openBox<String>(HiveBoxes.calendarSync);
    await box.delete(_calendarIdKey);
  }
}
