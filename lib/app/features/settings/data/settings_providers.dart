import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_settings.dart';
import 'settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier(this._repo) : super(const AppSettings()) {
    _load();
  }

  final SettingsRepository _repo;

  Future<void> _load() async {
    state = await _repo.load();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repo.save(state);
  }

  Future<void> setFontScale(AppFontScale scale) async {
    state = state.copyWith(fontScale: scale);
    await _repo.save(state);
  }

  Future<void> setShowChanges(bool value) async {
    state = state.copyWith(showChanges: value);
    await _repo.save(state);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier(ref.watch(settingsRepositoryProvider));
});