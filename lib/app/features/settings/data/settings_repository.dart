import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../domain/app_settings.dart';

class SettingsRepository {
  static const _box = 'settings';
  static const _key = 'app_settings';

  Future<AppSettings> load() async {
    final box = await Hive.openBox<String>(_box);
    final raw = box.get(_key);
    if (raw == null) return const AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    final box = await Hive.openBox<String>(_box);
    await box.put(_key, jsonEncode(settings.toJson()));
  }
}
