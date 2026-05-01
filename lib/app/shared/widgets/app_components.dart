import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_tokens.dart';

/// Compact tappable field used in filter panels (date, time, dropdown-like).
class AppCompactField extends StatelessWidget {
  const AppCompactField({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdBr,
      child: Container(
        height: AppSizes.fieldHeight,
        decoration: BoxDecoration(
          color: active
              ? primaryColor.withValues(alpha: 0.08)
              : theme.colorScheme.surfaceContainerHigh,
          borderRadius: AppRadius.mdBr,
          border: Border.all(
            color: active ? primaryColor.withValues(alpha: 0.3) : semantic.cardBorder,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconSm,
              color: active ? primaryColor : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  color: active ? primaryColor : theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: AppSizes.iconLg,
              color: active ? primaryColor : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary action button with brand gradient.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.enabled = true,
    this.height = AppSizes.buttonHeightSm,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdBr),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconSm),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: enabled
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge showing availability duration (e.g. "50 min free").
class AvailabilityBadge extends StatelessWidget {
  const AvailabilityBadge({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: semantic.availabilityContainer,
        borderRadius: AppRadius.xsBr,
        border: Border.all(
          color: semantic.availability.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: semantic.onAvailabilityContainer,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

/// Badge for "ЗАМЕНА" status -- visible but not aggressive.
class ChangeBadge extends StatelessWidget {
  const ChangeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: semantic.warningContainer,
        borderRadius: AppRadius.xsBr,
        border: Border.all(
          color: semantic.warning.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        'ЗАМЕНА',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: semantic.onWarningContainer,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Lesson type badge (Лекция, Практика, etc.).
class LessonTypeBadge extends StatelessWidget {
  const LessonTypeBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.xsBr,
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Gradient divider using brand gradient.
class AppGradientDivider extends StatelessWidget {
  const AppGradientDivider({
    super.key,
    this.height = 1,
    this.margin = const EdgeInsets.symmetric(vertical: AppSpacing.xl),
  });

  final double height;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandColors>()!;
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(gradient: brand.brandGradient),
    );
  }
}
