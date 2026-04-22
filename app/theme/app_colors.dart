import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF9F003D);   // основной
  static const dark = Color(0xFF333333);
  static const deepBlue = Color(0xFF002060);
  static const purple = Color(0xFF621472);
  static const orange = Color(0xFFFFA300);

  static const brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [deepBlue, purple, primary, orange],
    stops: [0.0, 0.33, 0.66, 1.0],
  );
}