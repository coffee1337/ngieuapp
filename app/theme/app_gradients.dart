import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Коллекция градиентов, используемых в приложении.
class AppGradients {
  AppGradients._();

  static const brand = AppColors.brandGradient;

  static const brandVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.deepBlue, AppColors.purple, AppColors.primary, AppColors.orange],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  static const primarySoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.purple],
  );
}