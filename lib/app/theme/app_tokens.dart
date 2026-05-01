import 'package:flutter/material.dart';

/// Design-system spacing tokens.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double xxxl = 24;
}

/// Design-system border-radius tokens.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double pill = 28;

  static const BorderRadius xsBr = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smBr = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdBr = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgBr = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlBr = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlBr = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pillBr = BorderRadius.all(Radius.circular(pill));
}

/// Fixed sizes for common UI elements.
abstract final class AppSizes {
  static const double navBarHeight = 64;
  static const double gradientBarHeight = 3;
  static const double fieldHeight = 40;
  static const double buttonHeight = 44;
  static const double buttonHeightSm = 36;
  static const double iconSm = 14;
  static const double iconMd = 18;
  static const double iconLg = 22;
  static const double lessonTimeColumnWidth = 52;
  static const double roomNumberColumnWidth = 60;
  static const double roomNumberColumnWidthWide = 74;
  static const double dayChipMinHeight = 38;
  static const double weekNavButtonSize = 36;
}

/// Animation duration tokens.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
}
