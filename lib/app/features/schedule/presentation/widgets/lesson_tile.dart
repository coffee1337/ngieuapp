import 'package:flutter/material.dart';
import 'package:ngieu_app/app/core/theme/app_colors.dart';
import 'package:ngieu_app/app/core/theme/app_spacing.dart';
import 'package:ngieu_app/app/core/theme/app_text_styles.dart';
import 'package:ngieu_app/app/core/theme/app_sizes.dart';
import 'package:ngieu_app/app/features/schedule/domain/models/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    this.onTap,
  });

  final Lesson lesson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TimeColumn(
                  startTime: lesson.startTime,
                  endTime: lesson.endTime,
                  pairNumber: lesson.pairNumber,
                  isChange: lesson.isChange,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.subject,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _InfoLine(
                          icon: Icons.person_outline,
                          text: lesson.teacherNames,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _InfoLine(
                          icon: Icons.location_on_outlined,
                          text: lesson.classroom,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _InfoLine(
                          icon: Icons.group_outlined,
                          text: lesson.groupNames,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _BadgesRow(
                          lessonType: lesson.type,
                          isChange: lesson.isChange,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.startTime,
    required this.endTime,
    required this.pairNumber,
    required this.isChange,
  });

  final DateTime startTime;
  final DateTime endTime;
  final int pairNumber;
  final bool isChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: AppSizes.lessonTimeColumnWidth,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: isChange
            ? colorScheme.errorContainer.withValues(alpha: 0.3)
            : colorScheme.surfaceContainerHigh,
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(startTime),
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            _formatTime(endTime),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: isChange
                  ? colorScheme.error
                  : colorScheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              pairNumber.toString(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({
    required this.lessonType,
    required this.isChange,
  });

  final String lessonType;
  final bool isChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        if (isChange)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              'Замена',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            lessonType,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
