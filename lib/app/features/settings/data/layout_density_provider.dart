import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ngieuapp/app/features/settings/domain/app_layout_density.dart';

class LayoutDensityNotifier extends StateNotifier<AppLayoutDensity> {
  LayoutDensityNotifier() : super(AppLayoutDensity.comfortable) {
    _load();
  }

  static const _boxName = 'settings';
  static const _key = 'layout_density';

  Future<void> _load() async {
    final box = await Hive.openBox<String>(_boxName);
    final name = box.get(_key);
    state = AppLayoutDensity.values.firstWhere(
      (density) => density.name == name,
      orElse: () => AppLayoutDensity.comfortable,
    );
  }

  Future<void> setDensity(AppLayoutDensity value) async {
    state = value;
    final box = await Hive.openBox<String>(_boxName);
    await box.put(_key, value.name);
  }
}

final layoutDensityProvider =
    StateNotifierProvider<LayoutDensityNotifier, AppLayoutDensity>(
      (_) => LayoutDensityNotifier(),
    );
