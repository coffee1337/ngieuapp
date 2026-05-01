import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Коллекция градиентов, используемых в приложении.
class AppGradients {
  AppGradients._();

  // Фирменные градиенты
  static const brand = AppColors.brandGradient;
  static const brandVertical = AppColors.brandGradientVertical;
  static const primary = AppColors.primaryGradient;
  static const accent = AppColors.accentGradient;

  // Градиенты для различных типов элементов
  static const cardElevation = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), Color(0x00000000)],
    stops: [0.0, 0.3],
  );

  static const tabIndicator = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.purple],
  );

  static const buttonPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, Color(0xFFC2185B)],
  );

  static const buttonSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.deepBlue, AppColors.purple],
  );

  static const buttonAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.orange, Color(0xFFFFB74D)],
  );

  // Декоративные градиенты
  static const primarySoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.purple],
  );

  static const surfaceHighlight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
    stops: [0.0, 0.8],
  );
}
