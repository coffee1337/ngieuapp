import 'package:flutter/material.dart';
import 'package:ngieuapp/app/theme/app_colors.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';
import 'package:ngieuapp/app/theme/app_visual_style.dart';

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
    cardBorder: Color(0xFFE3E6EE),
    subtleDivider: Color(0xFFEBEDF3),
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
    cardBorder: Color(0xFF333B4A),
    subtleDivider: Color(0xFF252B38),
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
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      availability: Color.lerp(availability, other.availability, t)!,
      onAvailability: Color.lerp(onAvailability, other.onAvailability, t)!,
      availabilityContainer: Color.lerp(
        availabilityContainer,
        other.availabilityContainer,
        t,
      )!,
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

  static ThemeData light({AppVisualStyle style = AppVisualStyle.material}) {
    if (style == AppVisualStyle.amoled) return dark(style: style);
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      secondary: AppColors.purple,
      tertiary: AppColors.orange,
    );
    final scheme = base.copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: const Color(0xFF4A5E89),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE8EEF8),
      onSecondaryContainer: const Color(0xFF1D3358),
      tertiary: const Color(0xFF855700),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFFFEDCC),
      onTertiaryContainer: const Color(0xFF513400),
      primaryContainer: const Color(0xFFFBE8EF),
      onPrimaryContainer: const Color(0xFF72002C),
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: const Color(0xFF767E8F),
      outlineVariant: const Color(0xFFE0E4ED),
      surface: AppColors.surfaceLight,
      surfaceContainer: const Color(0xFFFFFFFF),
      surfaceContainerHigh: const Color(0xFFF0F2F7),
      surfaceContainerHighest: const Color(0xFFE8EBF2),
      surfaceContainerLow: const Color(0xFFF7F8FB),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
    );
    return _build(
      _applyLightStyle(scheme, style),
      AppSemanticColors.light,
      style,
    );
  }

  static ThemeData dark({AppVisualStyle style = AppVisualStyle.material}) {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB3C2),
      onPrimary: Color(0xFF680025),
      primaryContainer: Color(0xFF9F003D),
      onPrimaryContainer: Color(0xFFFFD9E0),
      secondary: Color(0xFFACC2EB),
      onSecondary: Color(0xFF162B50),
      secondaryContainer: Color(0xFF283957),
      onSecondaryContainer: Color(0xFFDFE9FF),
      tertiary: Color(0xFFFFB870),
      onTertiary: Color(0xFF4A2800),
      tertiaryContainer: Color(0xFFFFA300),
      onTertiaryContainer: Color(0xFF3D2500),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF11141C),
      onSurface: Color(0xFFE3E1E6),
      surfaceContainer: Color(0xFF1B202B),
      surfaceContainerHigh: Color(0xFF252B38),
      surfaceContainerHighest: Color(0xFF333B4A),
      surfaceContainerLow: Color(0xFF161B25),
      surfaceContainerLowest: Color(0xFF141418),
      onSurfaceVariant: Color(0xFFC7C5CA),
      outline: Color(0xFF919095),
      outlineVariant: Color(0xFF4B4B50),
      inverseSurface: Color(0xFFE3E1E6),
      onInverseSurface: Color(0xFF11141C),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
    );
    return _build(
      _applyDarkStyle(scheme, style),
      AppSemanticColors.dark,
      style,
    );
  }

  static ColorScheme _applyLightStyle(
    ColorScheme scheme,
    AppVisualStyle style,
  ) => switch (style) {
    AppVisualStyle.material || AppVisualStyle.amoled => scheme,
    AppVisualStyle.glass => scheme.copyWith(
      primary: const Color(0xFF6046C6),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE9E2FF),
      onPrimaryContainer: const Color(0xFF24115F),
      secondary: const Color(0xFF006A8E),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFC5EFFF),
      onSecondaryContainer: const Color(0xFF003548),
      tertiary: const Color(0xFF9A3F73),
      surface: const Color(0xFFF9F7FF),
      surfaceContainer: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF3EFFF),
      surfaceContainerHigh: const Color(0xFFEDE8FA),
      surfaceContainerHighest: const Color(0xFFE4DDF4),
      outlineVariant: const Color(0xFFD7CFEB),
    ),
    AppVisualStyle.university => scheme.copyWith(
      primary: const Color(0xFF173B67),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFD6E4F7),
      onPrimaryContainer: const Color(0xFF08213E),
      secondary: const Color(0xFF8C1D40),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFFFD9E2),
      onSecondaryContainer: const Color(0xFF3E0016),
      tertiary: const Color(0xFF735C00),
      surface: const Color(0xFFF7F8FA),
      surfaceContainer: Colors.white,
      surfaceContainerLow: const Color(0xFFF1F3F6),
      surfaceContainerHigh: const Color(0xFFE9EDF2),
      surfaceContainerHighest: const Color(0xFFDDE3EA),
      outlineVariant: const Color(0xFFD3D9E1),
    ),
  };

  static ColorScheme _applyDarkStyle(
    ColorScheme scheme,
    AppVisualStyle style,
  ) => switch (style) {
    AppVisualStyle.material => scheme,
    AppVisualStyle.glass => scheme.copyWith(
      primary: const Color(0xFFC9B8FF),
      onPrimary: const Color(0xFF32157E),
      primaryContainer: const Color(0xFF49309A),
      onPrimaryContainer: const Color(0xFFE9E2FF),
      secondary: const Color(0xFF84D3F4),
      onSecondary: const Color(0xFF003548),
      secondaryContainer: const Color(0xFF064D66),
      onSecondaryContainer: const Color(0xFFC5EFFF),
      tertiary: const Color(0xFFFFAFD2),
      surface: const Color(0xFF11101C),
      surfaceContainer: const Color(0xFF1A1828),
      surfaceContainerLow: const Color(0xFF151321),
      surfaceContainerHigh: const Color(0xFF252235),
      surfaceContainerHighest: const Color(0xFF302C42),
      outlineVariant: const Color(0xFF514A67),
    ),
    AppVisualStyle.university => scheme.copyWith(
      primary: const Color(0xFFA9C7EE),
      onPrimary: const Color(0xFF0A325B),
      primaryContainer: const Color(0xFF234A75),
      onPrimaryContainer: const Color(0xFFD6E4F7),
      secondary: const Color(0xFFFFB1C5),
      onSecondary: const Color(0xFF570025),
      secondaryContainer: const Color(0xFF731437),
      onSecondaryContainer: const Color(0xFFFFD9E2),
      surface: const Color(0xFF0F151D),
      surfaceContainer: const Color(0xFF18212C),
      surfaceContainerLow: const Color(0xFF131B24),
      surfaceContainerHigh: const Color(0xFF222D39),
      surfaceContainerHighest: const Color(0xFF2D3947),
      outlineVariant: const Color(0xFF465464),
    ),
    AppVisualStyle.amoled => scheme.copyWith(
      primary: const Color(0xFFFFB0C8),
      onPrimary: const Color(0xFF65002C),
      primaryContainer: const Color(0xFF8F003F),
      onPrimaryContainer: const Color(0xFFFFD9E3),
      secondary: const Color(0xFFBFC8DA),
      onSecondary: const Color(0xFF293241),
      secondaryContainer: const Color(0xFF222832),
      onSecondaryContainer: const Color(0xFFE0E6F2),
      surface: Colors.black,
      surfaceContainer: const Color(0xFF0B0B0D),
      surfaceContainerLow: const Color(0xFF050506),
      surfaceContainerHigh: const Color(0xFF151518),
      surfaceContainerHighest: const Color(0xFF202024),
      outlineVariant: const Color(0xFF39393E),
    ),
  };

  static ThemeData _build(
    ColorScheme scheme,
    AppSemanticColors semanticColors,
    AppVisualStyle style,
  ) {
    final textTheme = TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
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
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: scheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: scheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: scheme.onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
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
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 68,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xxlBr,
          side: BorderSide(color: semanticColors.cardBorder),
        ),
        color: scheme.surfaceContainer,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgBr),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.xlBr,
          borderSide: BorderSide(color: semanticColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.xlBr,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        border: const OutlineInputBorder(
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
        backgroundColor: scheme.surfaceContainer,
        elevation: 0,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 24);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant);
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: scheme.primary,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minVerticalPadding: 12,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlBr),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainer,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlBr),
      ),
      dividerTheme: DividerThemeData(
        color: semanticColors.subtleDivider,
        thickness: 1,
        space: 1,
      ),
      extensions: [_brandColors(style, scheme), semanticColors],
    );
  }

  static BrandColors _brandColors(AppVisualStyle style, ColorScheme scheme) {
    final accent = switch (style) {
      AppVisualStyle.material => AppColors.orange,
      AppVisualStyle.glass => const Color(0xFFFF72B6),
      AppVisualStyle.university => const Color(0xFFD5A62E),
      AppVisualStyle.amoled => const Color(0xFFFFC857),
    };
    final deepBlue = switch (style) {
      AppVisualStyle.material => AppColors.deepBlue,
      AppVisualStyle.glass => const Color(0xFF2255C7),
      AppVisualStyle.university => const Color(0xFF173B67),
      AppVisualStyle.amoled => const Color(0xFF9CACCA),
    };
    final purple = switch (style) {
      AppVisualStyle.material => AppColors.purple,
      AppVisualStyle.glass => const Color(0xFF8157E8),
      AppVisualStyle.university => const Color(0xFF8C1D40),
      AppVisualStyle.amoled => const Color(0xFFFF6F9E),
    };

    LinearGradient gradient(Color first, Color second) => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [first, second],
    );

    return BrandColors(
      primaryBrand: scheme.primary,
      deepBlue: deepBlue,
      purple: purple,
      orange: accent,
      brandGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [deepBlue, scheme.primary, purple],
      ),
      buttonPrimaryGradient: gradient(scheme.primary, purple),
      buttonSecondaryGradient: gradient(deepBlue, purple),
      buttonAccentGradient: gradient(accent, scheme.tertiary),
      tabIndicatorGradient: gradient(scheme.primary, purple),
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
