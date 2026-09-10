import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_visual_style.dart';

void main() {
  test('restores known styles and safely falls back for unknown values', () {
    expect(appVisualStyleFromStorage('glass'), AppVisualStyle.glass);
    expect(appVisualStyleFromStorage('university'), AppVisualStyle.university);
    expect(appVisualStyleFromStorage('removed-style'), AppVisualStyle.material);
    expect(appVisualStyleFromStorage(null), AppVisualStyle.material);
  });

  test('every visual style produces a complete light and dark theme', () {
    for (final style in AppVisualStyle.values) {
      final light = AppTheme.light(style: style);
      final dark = AppTheme.dark(style: style);

      expect(light.extension<BrandColors>(), isNotNull);
      expect(light.extension<AppSemanticColors>(), isNotNull);
      expect(dark.extension<BrandColors>(), isNotNull);
      expect(dark.extension<AppSemanticColors>(), isNotNull);
    }
  });

  test('AMOLED style uses a black dark surface', () {
    final theme = AppTheme.dark(style: AppVisualStyle.amoled);

    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.surface, Colors.black);
  });

  test('style palettes have different primary colors', () {
    final colors = AppVisualStyle.values
        .map((style) => AppTheme.dark(style: style).colorScheme.primary)
        .toSet();

    expect(colors, hasLength(AppVisualStyle.values.length));
  });
}
