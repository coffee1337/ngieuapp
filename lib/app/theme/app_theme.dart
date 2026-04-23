import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

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
    // Custom dark scheme with proper contrast for brand colors
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB3C2),       // Lighter rose for dark bg
      onPrimary: Color(0xFF680025),      // Dark on primary
      primaryContainer: Color(0xFF9F003D), // Brand primary as container
      onPrimaryContainer: Color(0xFFFFD9E0),
      secondary: Color(0xFFCF9FDB),      // Lighter purple
      onSecondary: Color(0xFF3B004F),
      secondaryContainer: Color(0xFF621472), // Brand purple as container
      onSecondaryContainer: Color(0xFFF0DBF6),
      tertiary: Color(0xFFFFB870),       // Lighter orange
      onTertiary: Color(0xFF4A2800),
      tertiaryContainer: Color(0xFFFFA300), // Brand orange as container
      onTertiaryContainer: Color(0xFF3D2500),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF1A1A1F),
      onSurface: Color(0xFFE3E1E6),
      surfaceContainer: Color(0xFF252429),
      surfaceContainerHigh: Color(0xFF2F2E34),
      surfaceContainerHighest: Color(0xFF3A393F),
      surfaceContainerLow: Color(0xFF1E1D23),
      surfaceContainerLowest: Color(0xFF141418),
      onSurfaceVariant: Color(0xFFC7C5CA),
      outline: Color(0xFF919095),
      outlineVariant: Color(0xFF4B4B50),
      inverseSurface: Color(0xFFE3E1E6),
      onInverseSurface: Color(0xFF1A1A1F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
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
      navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
      ),
      extensions: const [
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

class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.primaryBrand,
    required this.deepBlue,
    required this.purple,
    required this.orange,
    required this.brandGradient,
  });

  final Color primaryBrand;
  final Color deepBlue;
  final Color purple;
  final Color orange;
  final Gradient brandGradient;

  @override
  BrandColors copyWith({
    Color? primaryBrand,
    Color? deepBlue,
    Color? purple,
    Color? orange,
    Gradient? brandGradient,
  }) {
    return BrandColors(
      primaryBrand: primaryBrand ?? this.primaryBrand,
      deepBlue: deepBlue ?? this.deepBlue,
      purple: purple ?? this.purple,
      orange: orange ?? this.orange,
      brandGradient: brandGradient ?? this.brandGradient,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) => this;
}
