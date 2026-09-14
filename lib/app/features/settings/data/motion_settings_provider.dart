import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/features/settings/domain/app_motion_style.dart';

class AppMotionSettings {
  AppMotionSettings._();

  static AppMotionStyle currentStyle = AppMotionStyle.smooth;
}

class MotionSettingsNotifier extends StateNotifier<AppMotionStyle> {
  MotionSettingsNotifier() : super(AppMotionStyle.smooth) {
    _load();
  }

  static const _boxName = 'settings';
  static const _key = 'motion_style';

  Future<void> _load() async {
    final box = await Hive.openBox<String>(_boxName);
    final name = box.get(_key);
    final value = AppMotionStyle.values.firstWhere(
      (style) => style.name == name,
      orElse: () => AppMotionStyle.smooth,
    );
    AppMotionSettings.currentStyle = value;
    state = value;
  }

  Future<void> setStyle(AppMotionStyle value) async {
    AppMotionSettings.currentStyle = value;
    state = value;
    final box = await Hive.openBox<String>(_boxName);
    await box.put(_key, value.name);
  }
}

final motionSettingsProvider =
    StateNotifierProvider<MotionSettingsNotifier, AppMotionStyle>(
      (_) => MotionSettingsNotifier(),
    );
