import 'package:flutter_test/flutter_test.dart';
import 'package:ngieuapp/app/features/settings/domain/app_layout_density.dart';
import 'package:ngieuapp/app/features/settings/domain/app_motion_style.dart';

void main() {
  test('motion presets have clear labels and increasing durations', () {
    expect(AppMotionStyle.reduced.label, 'Минимум');
    expect(AppMotionStyle.smooth.label, 'Плавно');
    expect(AppMotionStyle.expressive.label, 'Выразительно');
    expect(AppMotionStyle.reduced.pageDuration, Duration.zero);
    expect(
      AppMotionStyle.smooth.pageDuration,
      lessThan(AppMotionStyle.expressive.pageDuration),
    );
  });

  test('layout density presets preserve ordered spacing', () {
    expect(
      AppLayoutDensity.compact.visualDensity.vertical,
      lessThan(AppLayoutDensity.comfortable.visualDensity.vertical),
    );
    expect(
      AppLayoutDensity.spacious.visualDensity.vertical,
      greaterThan(AppLayoutDensity.comfortable.visualDensity.vertical),
    );
  });
}
