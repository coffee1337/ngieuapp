import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Основные фирменные цвета
  static const primary = Color(0xFF9F003D); // Красно-пурпурный
  static const dark = Color(0xFF202532); // Темно-серый
  static const white = Color(0xFFFFFFFF); // Белый

  // Дополнительные цвета фирменной палитры
  static const deepBlue = Color(0xFF002060); // Темно-синий
  static const purple = Color(0xFF621472); // Фиолетовый
  static const orange = Color(0xFFFFA300); // Оранжевый

  // Фон и поверхности
  static const surfaceLight = Color(0xFFF5F6FA);
  static const surfaceContainerLight = Color(0xFFEEF0F5);
  static const surfaceContainerHighLight = Color(0xFFE5E8F0);
  static const surfaceVariantLight = Color(0xFFC2C2C2);

  // Текст
  static const textPrimary = Color(0xFF202532);
  static const textSecondary = Color(0xFF626A7B);
  static const textTertiary = Color(0xFF727B8C);

  // Градиенты
  static const brandGradient = LinearGradient(
    colors: [Color(0xFF620D35), primary, Color(0xFFB82E59)],
    stops: [0.0, 0.65, 1.0],
  );

  static const brandGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF620D35), primary, Color(0xFFB82E59)],
    stops: [0.0, 0.65, 1.0],
  );

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFC2185B)],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange, Color(0xFFFFB74D)],
  );

  // Состояния
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);
}
