enum AppMotionStyle { reduced, smooth, expressive }

extension AppMotionStyleLabel on AppMotionStyle {
  String get label => switch (this) {
    AppMotionStyle.reduced => 'Минимум',
    AppMotionStyle.smooth => 'Плавно',
    AppMotionStyle.expressive => 'Выразительно',
  };

  Duration get pageDuration => switch (this) {
    AppMotionStyle.reduced => Duration.zero,
    AppMotionStyle.smooth => const Duration(milliseconds: 180),
    AppMotionStyle.expressive => const Duration(milliseconds: 260),
  };
}
