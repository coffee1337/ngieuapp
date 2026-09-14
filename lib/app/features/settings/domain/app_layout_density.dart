import 'package:flutter/material.dart';

enum AppLayoutDensity { compact, comfortable, spacious }

extension AppLayoutDensityX on AppLayoutDensity {
  String get label => switch (this) {
    AppLayoutDensity.compact => 'Компактно',
    AppLayoutDensity.comfortable => 'Обычно',
    AppLayoutDensity.spacious => 'Свободно',
  };

  VisualDensity get visualDensity => switch (this) {
    AppLayoutDensity.compact => const VisualDensity(
      horizontal: -1.5,
      vertical: -1.5,
    ),
    AppLayoutDensity.comfortable => VisualDensity.standard,
    AppLayoutDensity.spacious => const VisualDensity(
      horizontal: 0.5,
      vertical: 1,
    ),
  };
}
