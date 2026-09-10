enum AppVisualStyle { material, glass, university, amoled }

AppVisualStyle appVisualStyleFromStorage(String? value) {
  for (final style in AppVisualStyle.values) {
    if (style.name == value) return style;
  }
  return AppVisualStyle.material;
}

extension AppVisualStyleX on AppVisualStyle {
  String get label => switch (this) {
    AppVisualStyle.material => 'Фирменный',
    AppVisualStyle.glass => 'Градиент',
    AppVisualStyle.university => 'Университет',
    AppVisualStyle.amoled => 'AMOLED',
  };

  String get description => switch (this) {
    AppVisualStyle.material => 'Чистый Material 3 и фирменный бордовый цвет',
    AppVisualStyle.glass =>
      'Яркие фиолетово-синие акценты и мягкие поверхности',
    AppVisualStyle.university => 'Строгая тёмно-синяя академическая палитра',
    AppVisualStyle.amoled => 'Чёрный фон и высокий контраст для OLED-экранов',
  };
}
