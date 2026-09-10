import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/settings/domain/app_navigation_settings.dart';

void main() {
  test('keeps at least one visible tab', () {
    const settings = AppNavigationSettings(
      defaultTab: AppTab.schedule,
      visibleTabs: [],
    );

    expect(settings.normalized().visibleTabs, [AppTab.schedule]);
  });

  test('moves default tab when it becomes hidden', () {
    final settings = const AppNavigationSettings(
      defaultTab: AppTab.news,
      visibleTabs: [AppTab.schedule, AppTab.profile],
    ).normalized();

    expect(settings.defaultTab, AppTab.schedule);
  });

  test('round-trips persisted customization', () {
    const settings = AppNavigationSettings(
      defaultTab: AppTab.learning,
      visibleTabs: [AppTab.schedule, AppTab.learning],
    );

    final restored = AppNavigationSettings.fromJson(settings.toJson());

    expect(restored.defaultTab, AppTab.learning);
    expect(restored.visibleTabs, [AppTab.schedule, AppTab.learning]);
  });

  test('keeps the campus map out of bottom navigation', () {
    const settings = AppNavigationSettings();

    expect(settings.visibleTabs, isNot(contains(AppTab.learning)));
    expect(settings.visibleTabs, [
      AppTab.news,
      AppTab.schedule,
      AppTab.profile,
    ]);
  });

  test('ignores the removed campus tab in old persisted settings', () {
    final settings = AppNavigationSettings.fromJson({
      'defaultTab': 'campus',
      'visibleTabs': ['news', 'schedule', 'campus', 'profile'],
    });

    expect(settings.defaultTab, AppTab.news);
    expect(settings.visibleTabs, [
      AppTab.news,
      AppTab.schedule,
      AppTab.profile,
    ]);
  });
}
