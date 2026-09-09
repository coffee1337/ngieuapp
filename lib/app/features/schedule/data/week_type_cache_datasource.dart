import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/core/cache/hive_boxes.dart';
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
  }

  /// Загружает тип недели из кэша
  Future<WeekType?> loadWeekType({bool allowExpired = false}) async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    final raw = box.get(_cacheKey);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        await box.delete(_cacheKey);
        return null;
      }
      final cachedAt = DateTime.parse(decoded['cachedAt'] as String);

      if (!allowExpired && DateTime.now().difference(cachedAt) > _cacheTtl) {
        return null;
      }

      return WeekType(
        date: DateTime.parse(decoded['date'] as String),
        isUpperWeek: decoded['isUpperWeek'] as bool,
      );
    } catch (_) {
      // Повреждённый кэш не должен мешать запуску приложения.
      await box.delete(_cacheKey);
      return null;
    }
  }

  /// Очищает кэш типа недели
  Future<void> clearCache() async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    await box.delete(_cacheKey);
  }
}
