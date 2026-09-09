import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/features/settings/domain/smart_notification_settings.dart';

class SmartNotificationSettingsNotifier
    extends StateNotifier<SmartNotificationSettings> {
  SmartNotificationSettingsNotifier()
    : super(const SmartNotificationSettings()) {
    _load();
  }

  static const _box = 'settings';
  static const _key = 'smart_notification_settings';

  Future<void> _load() async {
    final box = await Hive.openBox<String>(_box);
    final raw = box.get(_key);
    if (raw == null) return;
    try {
      state = SmartNotificationSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {}
  }

  Future<void> update(SmartNotificationSettings value) async {
    state = value;
    final box = await Hive.openBox<String>(_box);
    await box.put(_key, jsonEncode(value.toJson()));
  }
}

final smartNotificationSettingsProvider =
    StateNotifierProvider<
      SmartNotificationSettingsNotifier,
      SmartNotificationSettings
    >((ref) => SmartNotificationSettingsNotifier());
