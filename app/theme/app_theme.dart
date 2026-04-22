import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      secondary: AppColors.purple,
      tertiary: AppColors.orange,
    );
    return _build(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      secondary: AppColors.purple,
      tertiary: AppColors.orange,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: scheme.surfaceContainer,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: scheme.primary, width: 3),
        ),
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
      ),
      extensions: [
        BrandColors(
          primaryBrand: AppColors.primary,
          deepBlue: AppColors.deepBlue,
          purple: AppColors.purple,
          orange: AppColors.orange,
          brandGradient: AppColors.brandGradient,
        ),
      ],
    );
  }
}

/// Доступ к фирменным цветам через Theme.of(context).extension<BrandColors>()!
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.primaryBrand,
    required this.deepBlue,
    required this.purple,
    required this.orange,
    required this.brandGradient,
  });
  final Color primaryBrand, deepBlue, purple, orange;
  final Gradient brandGradient;

  @override
  BrandColors copyWith({
    Color? primaryBrand, Color? deepBlue, Color? purple,
    Color? orange, Gradient? brandGradient,
  }) => BrandColors(
        primaryBrand: primaryBrand ?? this.primaryBrand,
        deepBlue: deepBlue ?? this.deepBlue,
        purple: purple ?? this.purple,
        orange: orange ?? this.orange,
        brandGradient: brandGradient ?? this.brandGradient,
      );

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? o, double t) => this;
}