import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';

class WeekTypeCacheDataSource {
  static const _cacheKey = 'week_type_cache';
  static const _cacheTtl = Duration(days: 1); // Кэшируем на 1 день

  /// Сохраняет тип недели в кэш
  Future<void> saveWeekType(WeekType weekType) async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    final cacheData = {
      'date': weekType.date.toIso8601String(),
      'isUpperWeek': weekType.isUpperWeek,
      'cachedAt': DateTime.now().toIso8601String(),
    };
    await box.put(_cacheKey, jsonEncode(cacheData));
    await box.put(_keyFor(weekType.date), jsonEncode(cacheData));
  }

  /// Загружает тип недели из кэша
  Future<WeekType?> loadWeekType({
    DateTime? date,
    bool allowExpired = false,
  }) async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    // Fall back to the old single entry when upgrading an existing install.
    final key = date != null && box.containsKey(_keyFor(date))
        ? _keyFor(date)
        : _cacheKey;
    final raw = box.get(key);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        await box.delete(key);
        return null;
      }
      final cachedAt = DateTime.parse(decoded['cachedAt'] as String);

      if (!allowExpired && DateTime.now().difference(cachedAt) > _cacheTtl) {
        return null;
      }

      final result = WeekType(
        date: DateTime.parse(decoded['date'] as String),
        isUpperWeek: decoded['isUpperWeek'] as bool,
      );
      if (date != null && result.date.startOfWeek != date.startOfWeek) {
        return null;
      }
      return result;
    } catch (_) {
      // Повреждённый кэш не должен мешать запуску приложения.
      await box.delete(key);
      return null;
    }
  }

  /// Очищает кэш типа недели
  Future<void> clearCache() async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    await box.deleteAll(
      box.keys.where((key) => key.toString().startsWith(_cacheKey)).toList(),
    );
  }

  String _keyFor(DateTime date) =>
      '${_cacheKey}_${date.startOfWeek.toIso8601String()}';
}
