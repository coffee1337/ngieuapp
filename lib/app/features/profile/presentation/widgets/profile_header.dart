import 'package:flutter/material.dart';
import 'package:ngieuapp/app/features/profile/domain/student_identity.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.identity,
    required this.courseStats,
    required this.todayStats,
    super.key,
  });
  final StudentIdentity identity;
  final Widget courseStats;
  final Widget todayStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brandGradient = theme.extension<BrandColors>()!.brandGradient;
    final headerForeground = _bestForegroundFor(brandGradient);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        gradient: brandGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: headerForeground.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.88),
                  borderRadius: AppRadius.pillBr,
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.75),
                  ),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: scheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  identity.isStudentGroup ? 'Моя группа' : 'Преподаватель',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: headerForeground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            identity.displayName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style:
                (textScale > 1.15
                    ? theme.textTheme.titleLarge
                    : theme.textTheme.headlineLarge)
                    ?.copyWith(color: headerForeground, height: 1.15),
          ),
          if (identity.departmentName.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              identity.departmentName,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: headerForeground.withValues(alpha: 0.88),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 260 ||
                  textScale > 1.15 ||
                  !identity.isStudentGroup) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    courseStats,
                    const SizedBox(height: AppSpacing.md),
                    todayStats,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: courseStats),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: todayStats),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.86),
        borderRadius: AppRadius.xlBr,
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: value.length > 8 ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style:
                (value.length > 8
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.headlineMedium)
                    ?.copyWith(color: scheme.onSurface, height: 1.15),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

Color _bestForegroundFor(Gradient gradient) {
  var whiteMinimum = double.infinity;
  var darkMinimum = double.infinity;
  const dark = Color(0xFF111318);

  for (final background in gradient.colors) {
    final whiteContrast = _contrastRatio(Colors.white, background);
    final darkContrast = _contrastRatio(dark, background);
    if (whiteContrast < whiteMinimum) whiteMinimum = whiteContrast;
    if (darkContrast < darkMinimum) darkMinimum = darkContrast;
  }

  return whiteMinimum >= darkMinimum ? Colors.white : dark;
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = foreground.computeLuminance() > background.computeLuminance()
      ? foreground.computeLuminance()
      : background.computeLuminance();
  final darker = foreground.computeLuminance() > background.computeLuminance()
      ? background.computeLuminance()
      : foreground.computeLuminance();
  return (lighter + 0.05) / (darker + 0.05);
}
