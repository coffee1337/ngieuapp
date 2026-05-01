import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_tokens.dart';
import 'app_gradient_bar.dart';

/// Brand button with gradient background.
class BrandButton extends StatelessWidget {
  const BrandButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.variant = BrandButtonVariant.primary,
    this.width = double.infinity,
    this.height = AppSizes.buttonHeight,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final BrandButtonVariant variant;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<BrandColors>()!;

    Gradient getGradient() {
      return switch (variant) {
        BrandButtonVariant.primary => brand.buttonPrimaryGradient,
        BrandButtonVariant.secondary => brand.buttonSecondaryGradient,
        BrandButtonVariant.accent => brand.buttonAccentGradient,
      };
    }

    Color getShadowColor() {
      return switch (variant) {
        BrandButtonVariant.primary => const Color(0xFF9F003D),
        BrandButtonVariant.secondary => const Color(0xFF002060),
        BrandButtonVariant.accent => const Color(0xFFFFA300),
      };
    }

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: getGradient(),
          borderRadius: AppRadius.lgBr,
          boxShadow: [
            BoxShadow(
              color: getShadowColor().withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.lgBr,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.lgBr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null && !isLoading) ...[
                    Icon(icon, color: Colors.white, size: AppSizes.iconLg),
                    const SizedBox(width: AppSpacing.lg),
                  ],
                  if (isLoading)
                    const SizedBox(
                      width: AppSizes.iconLg,
                      height: AppSizes.iconLg,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  if (!isLoading)
                    Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum BrandButtonVariant { primary, secondary, accent }

/// Brand card with optional gradient border.
class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xxl),
    this.margin = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    ),
    this.elevation = 4,
    this.withGradientBorder = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double elevation;
  final bool withGradientBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: margin,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.xxlBr,
        side: withGradientBorder
            ? const BorderSide(width: 2, color: Colors.transparent)
            : BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
                width: 1,
              ),
      ),
      color: theme.colorScheme.surfaceContainer,
      child: ClipRRect(
        borderRadius: AppRadius.xxlBr,
        child: Container(
          decoration: withGradientBorder
              ? const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF002060),
                      Color(0xFF621472),
                      Color(0xFF9F003D),
                      Color(0xFFFFA300),
                    ],
                    stops: [0.0, 0.33, 0.66, 1.0],
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.xxl - 2),
              ),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Brand status badge.
class BrandBadge extends StatelessWidget {
  const BrandBadge({
    super.key,
    required this.label,
    this.variant = BrandBadgeVariant.primary,
    this.icon,
  });

  final String label;
  final BrandBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getBackgroundColor() {
      return switch (variant) {
        BrandBadgeVariant.primary => const Color(0xFF9F003D),
        BrandBadgeVariant.secondary => const Color(0xFF002060),
        BrandBadgeVariant.accent => const Color(0xFFFFA300),
        BrandBadgeVariant.success => const Color(0xFF4CAF50),
        BrandBadgeVariant.warning => const Color(0xFFFF9800),
        BrandBadgeVariant.error => const Color(0xFFF44336),
        BrandBadgeVariant.info => const Color(0xFF2196F3),
      };
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: AppRadius.lgBr,
        boxShadow: [
          BoxShadow(
            color: getBackgroundColor().withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: AppSizes.iconSm),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

enum BrandBadgeVariant {
  primary,
  secondary,
  accent,
  success,
  warning,
  error,
  info,
}

/// Brand gradient divider.
class BrandDivider extends StatelessWidget {
  const BrandDivider({
    super.key,
    this.height = 1,
    this.margin = const EdgeInsets.symmetric(vertical: AppSpacing.xl),
  });

  final double height;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      child: const AppGradientBar(height: 1),
    );
  }
}

/// Brand section header.
class BrandSectionHeader extends StatelessWidget {
  const BrandSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: AppSizes.weekNavButtonSize,
                  height: AppSizes.weekNavButtonSize,
                  decoration: BoxDecoration(
                    gradient: theme
                        .extension<BrandColors>()!
                        .buttonPrimaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: AppSizes.iconMd),
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: AppSpacing.md),
                action!,
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const BrandDivider(),
        ],
      ),
    );
  }
}
