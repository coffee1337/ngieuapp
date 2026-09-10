enum AppTab {
  news('/news', 'Новости'),
  schedule('/schedule', 'Расписание'),
  campus('/campus', 'Карта'),
  profile('/profile', 'Профиль'),
  learning('/learning', 'Обучение');

  const AppTab(this.path, this.label);

  final String path;
  final String label;
}

const defaultVisibleAppTabs = <AppTab>[
  AppTab.news,
  AppTab.schedule,
  AppTab.campus,
  AppTab.profile,
];

class AppNavigationSettings {
  const AppNavigationSettings({
    this.defaultTab = AppTab.news,
    this.visibleTabs = defaultVisibleAppTabs,
  });

  final AppTab defaultTab;
  final List<AppTab> visibleTabs;

  AppNavigationSettings copyWith({
    AppTab? defaultTab,
    List<AppTab>? visibleTabs,
  }) {
    return AppNavigationSettings(
      defaultTab: defaultTab ?? this.defaultTab,
      visibleTabs: visibleTabs ?? this.visibleTabs,
    ).normalized();
  }

  AppNavigationSettings normalized() {
    final unique = <AppTab>[
      for (final tab in AppTab.values)
        if (visibleTabs.contains(tab)) tab,
    ];
    final safeVisible = unique.isEmpty ? <AppTab>[defaultTab] : unique;
    return AppNavigationSettings(
      defaultTab: safeVisible.contains(defaultTab)
          ? defaultTab
          : safeVisible.first,
      visibleTabs: List.unmodifiable(safeVisible),
    );
  }

  Map<String, Object> toJson() => {
    'defaultTab': defaultTab.name,
    'visibleTabs': visibleTabs.map((tab) => tab.name).toList(),
  };

  factory AppNavigationSettings.fromJson(Map<String, dynamic> json) {
    final defaultName = json['defaultTab'] as String?;
    final visibleNames = (json['visibleTabs'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toSet();
    final defaultTab = AppTab.values.firstWhere(
      (tab) => tab.name == defaultName,
      orElse: () => AppTab.news,
    );
    final visible = AppTab.values
        .where((tab) => visibleNames.contains(tab.name))
        .toList();
    return AppNavigationSettings(
      defaultTab: defaultTab,
      visibleTabs: visible.isEmpty && !json.containsKey('visibleTabs')
          ? defaultVisibleAppTabs
          : visible,
    ).normalized();
  }
}
