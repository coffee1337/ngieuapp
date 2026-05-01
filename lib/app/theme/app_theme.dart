import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_tokens.dart';

/// Semantic color roles that go beyond Material's ColorScheme.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.availability,
    required this.onAvailability,
    required this.availabilityContainer,
    required this.onAvailabilityContainer,
    required this.cardBorder,
    required this.subtleDivider,
  });

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color availability;
  final Color onAvailability;
  final Color availabilityContainer;
  final Color onAvailabilityContainer;
  final Color cardBorder;
  final Color subtleDivider;

  static const light = AppSemanticColors(
    warning: Color(0xFFE65100),
    onWarning: Colors.white,
    warningContainer: Color(0xFFFFF3E0),
    onWarningContainer: Color(0xFF8D3200),
    info: Color(0xFF0277BD),
    onInfo: Colors.white,
    infoContainer: Color(0xFFE1F5FE),
    onInfoContainer: Color(0xFF01579B),
    availability: Color(0xFF2E7D32),
    onAvailability: Colors.white,
    availabilityContainer: Color(0xFFE8F5E9),
    onAvailabilityContainer: Color(0xFF1B5E20),
    cardBorder: Color(0xFFDCDCDC),
    subtleDivider: Color(0xFFEEEEEE),
  );

  static const dark = AppSemanticColors(
    warning: Color(0xFFFFB74D),
    onWarning: Color(0xFF3E2700),
    warningContainer: Color(0xFF4E3200),
    onWarningContainer: Color(0xFFFFDDB3),
    info: Color(0xFF81D4FA),
    onInfo: Color(0xFF002F4A),
    infoContainer: Color(0xFF003D5C),
    onInfoContainer: Color(0xFFB3E5FC),
    availability: Color(0xFF81C784),
    onAvailability: Color(0xFF003300),
    availabilityContainer: Color(0xFF1B3A1B),
    onAvailabilityContainer: Color(0xFFC8E6C9),
    cardBorder: Color(0xFF3A393F),
    subtleDivider: Color(0xFF2F2E34),
  );

  @override
  AppSemanticColors copyWith({
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? availability,
    Color? onAvailability,
    Color? availabilityContainer,
    Color? onAvailabilityContainer,
    Color? cardBorder,
    Color? subtleDivider,
  }) {
    return AppSemanticColors(
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      availability: availability ?? this.availability,
      onAvailability: onAvailability ?? this.onAvailability,
      availabilityContainer:
          availabilityContainer ?? this.availabilityContainer,
      onAvailabilityContainer:
          onAvailabilityContainer ?? this.onAvailabilityContainer,
      cardBorder: cardBorder ?? this.cardBorder,
      subtleDivider: subtleDivider ?? this.subtleDivider,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer:
          Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      availability: Color.lerp(availability, other.availability, t)!,
      onAvailability: Color.lerp(onAvailability, other.onAvailability, t)!,
      availabilityContainer:
          Color.lerp(availabilityContainer, other.availabilityContainer, t)!,
      onAvailabilityContainer: Color.lerp(
        onAvailabilityContainer,
        other.onAvailabilityContainer,
        t,
      )!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtleDivider: Color.lerp(subtleDivider, other.subtleDivider, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      secondary: AppColors.purple,
      tertiary: AppColors.orange,
    );
    final scheme = base.copyWith(
      surface: const Color(0xFFFAFAFA),
      surfaceContainer: const Color(0xFFFFFFFF),
      surfaceContainerHigh: const Color(0xFFF2F2F2),
      surfaceContainerHighest: const Color(0xFFEAEAEA),
      surfaceContainerLow: const Color(0xFFF6F6F6),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
    );
    return _build(scheme, AppSemanticColors.light);
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB3C2),
      onPrimary: Color(0xFF680025),
      primaryContainer: Color(0xFF9F003D),
      onPrimaryContainer: Color(0xFFFFD9E0),
      secondary: Color(0xFFCF9FDB),
      onSecondary: Color(0xFF3B004F),
      secondaryContainer: Color(0xFF621472),
      onSecondaryContainer: Color(0xFFF0DBF6),
      tertiary: Color(0xFFFFB870),
      onTertiary: Color(0xFF4A2800),
      tertiaryContainer: Color(0xFFFFA300),
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
    return _build(scheme, AppSemanticColors.dark);
  }

  static ThemeData _build(
    ColorScheme scheme,
    AppSemanticColors semanticColors,
  ) {
    final isDark = scheme.brightness == Brightness.dark;

    final textTheme = TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: scheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: scheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: scheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: scheme.onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: scheme.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 1,
        shadowColor: isDark ? Colors.transparent : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgBr,
          side: BorderSide(
            color: semanticColors.cardBorder,
            width: isDark ? 1 : 0.5,
          ),
        ),
        color: scheme.surfaceContainer,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgBr),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppRadius.lgBr,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: scheme.primary, width: 3),
        ),
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer.withValues(alpha: 0.3),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 22);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
          );
        }),
      ),
      listTileTheme: ListTileThemeData(iconColor: scheme.primary),
      dividerTheme: DividerThemeData(
        color: semanticColors.subtleDivider,
        thickness: 1,
        space: 1,
      ),
      extensions: [
        BrandColors(
          primaryBrand: AppColors.primary,
          deepBlue: AppColors.deepBlue,
          purple: AppColors.purple,
          orange: AppColors.orange,
          brandGradient: AppColors.brandGradient,
          buttonPrimaryGradient: AppGradients.buttonPrimary,
          buttonSecondaryGradient: AppGradients.buttonSecondary,
          buttonAccentGradient: AppGradients.buttonAccent,
          tabIndicatorGradient: AppGradients.tabIndicator,
        ),
        semanticColors,
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
    required this.buttonPrimaryGradient,
    required this.buttonSecondaryGradient,
    required this.buttonAccentGradient,
    required this.tabIndicatorGradient,
  });

  final Color primaryBrand;
  final Color deepBlue;
  final Color purple;
  final Color orange;
  final Gradient brandGradient;
  final Gradient buttonPrimaryGradient;
  final Gradient buttonSecondaryGradient;
  final Gradient buttonAccentGradient;
  final Gradient tabIndicatorGradient;

  @override
  BrandColors copyWith({
    Color? primaryBrand,
    Color? deepBlue,
    Color? purple,
    Color? orange,
    Gradient? brandGradient,
    Gradient? buttonPrimaryGradient,
    Gradient? buttonSecondaryGradient,
    Gradient? buttonAccentGradient,
    Gradient? tabIndicatorGradient,
  }) {
    return BrandColors(
      primaryBrand: primaryBrand ?? this.primaryBrand,
      deepBlue: deepBlue ?? this.deepBlue,
      purple: purple ?? this.purple,
      orange: orange ?? this.orange,
      brandGradient: brandGradient ?? this.brandGradient,
      buttonPrimaryGradient:
          buttonPrimaryGradient ?? this.buttonPrimaryGradient,
      buttonSecondaryGradient:
          buttonSecondaryGradient ?? this.buttonSecondaryGradient,
      buttonAccentGradient: buttonAccentGradient ?? this.buttonAccentGradient,
      tabIndicatorGradient: tabIndicatorGradient ?? this.tabIndicatorGradient,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) => this;
}
