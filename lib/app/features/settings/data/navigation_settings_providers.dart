import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ngieuapp/app/features/settings/data/navigation_settings_repository.dart';
import 'package:ngieuapp/app/features/settings/domain/app_navigation_settings.dart';

final navigationSettingsRepositoryProvider =
    Provider<NavigationSettingsRepository>((ref) {
      return NavigationSettingsRepository();
    });

class NavigationSettingsNotifier extends StateNotifier<AppNavigationSettings> {
  NavigationSettingsNotifier(this._repository)
    : super(const AppNavigationSettings()) {
    _load();
  }

  final NavigationSettingsRepository _repository;

  Future<void> _load() async {
    state = await _repository.load();
  }

  Future<void> setDefaultTab(AppTab tab) async {
    final visible = state.visibleTabs.contains(tab)
        ? state.visibleTabs
        : [...state.visibleTabs, tab];
    state = state.copyWith(defaultTab: tab, visibleTabs: visible);
    await _repository.save(state);
  }

  Future<bool> setTabVisible(AppTab tab, {required bool visible}) async {
    final tabs = [...state.visibleTabs];
    if (visible) {
      if (!tabs.contains(tab)) tabs.add(tab);
    } else {
      if (tabs.length == 1 && tabs.contains(tab)) return false;
      tabs.remove(tab);
    }
    state = state.copyWith(visibleTabs: tabs);
    await _repository.save(state);
    return true;
  }
}

final navigationSettingsProvider =
    StateNotifierProvider<NavigationSettingsNotifier, AppNavigationSettings>((
      ref,
    ) {
      return NavigationSettingsNotifier(
        ref.watch(navigationSettingsRepositoryProvider),
      );
    });
