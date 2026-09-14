import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/features/settings/domain/app_navigation_settings.dart';

class NavigationSettingsRepository {
  static const _box = 'settings';
  static const _key = 'navigation_settings';

  Future<AppNavigationSettings> load() async {
    final box = await Hive.openBox<String>(_box);
    final raw = box.get(_key);
    if (raw == null) return const AppNavigationSettings();
    try {
      return AppNavigationSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const AppNavigationSettings();
    }
  }

  Future<void> save(AppNavigationSettings settings) async {
    final box = await Hive.openBox<String>(_box);
    await box.put(_key, jsonEncode(settings.normalized().toJson()));
  }
}
