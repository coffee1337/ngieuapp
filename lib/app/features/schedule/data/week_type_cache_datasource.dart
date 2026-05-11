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
  Future<WeekType?> loadWeekType() async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    final raw = box.get(_cacheKey);
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    final cachedAt = DateTime.parse(map['cachedAt'] as String);

    // Проверяем не устарели ли данные
    if (DateTime.now().difference(cachedAt) > _cacheTtl) {
      return null;
    }

    return WeekType(
      date: DateTime.parse(map['date'] as String),
      isUpperWeek: map['isUpperWeek'] as bool,
    );
  }

  /// Очищает кэш типа недели
  Future<void> clearCache() async {
    final box = await Hive.openBox<String>(HiveBoxes.scheduleCache);
    await box.delete(_cacheKey);
  }
}
