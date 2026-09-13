import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LockScreenCardState {
  const LockScreenCardState({this.enabled = false, this.loaded = false});

  final bool enabled;
  final bool loaded;

  LockScreenCardState copyWith({bool? enabled, bool? loaded}) =>
      LockScreenCardState(
        enabled: enabled ?? this.enabled,
        loaded: loaded ?? this.loaded,
      );
}

class LockScreenCardNotifier extends StateNotifier<LockScreenCardState> {
  LockScreenCardNotifier() : super(const LockScreenCardState()) {
    _load();
  }

  static const _boxName = 'settings';
  static const _key = 'android_lock_screen_schedule_card';

  Future<void> _load() async {
    final box = await Hive.openBox<String>(_boxName);
    state = LockScreenCardState(enabled: box.get(_key) == 'true', loaded: true);
  }

  Future<void> setEnabled(bool value) async {
    state = state.copyWith(enabled: value, loaded: true);
    final box = await Hive.openBox<String>(_boxName);
    await box.put(_key, value.toString());
  }
}

final lockScreenCardSettingsProvider =
    StateNotifierProvider<LockScreenCardNotifier, LockScreenCardState>(
      (_) => LockScreenCardNotifier(),
    );
