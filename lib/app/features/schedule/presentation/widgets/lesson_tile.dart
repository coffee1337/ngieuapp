import 'package:flutter/material.dart';

import '../../../../theme/app_tokens.dart';
import '../../domain/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    this.isCompact = false,
  });

  final Lesson lesson;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNoPairs = lesson.subject == 'Нет пар';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isNoPairs
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isNoPairs
            ? Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isCompact ? AppSpacing.sm : AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) _TimeColumn(lesson: lesson),
            if (!isCompact) const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ContentSection(
                lesson: lesson,
                isCompact: isCompact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: AppSizes.lessonTimeColumnWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${lesson.startTime.hour.toString().padLeft(2, '0')}:${lesson.startTime.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${lesson.endTime.hour.toString().padLeft(2, '0')}:${lesson.endTime.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${lesson.pairNumber} пара',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.lesson,
    required this.isCompact,
  });

  final Lesson lesson;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNoPairs = lesson.subject == 'Нет пар';

    if (isNoPairs) {
      return Text(
        'Нет пар',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lesson.subject,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: isCompact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lesson.isChange) ...[
                        const SizedBox(width: AppSpacing.xs),
                        const _ReplacementBadge(),
                      ],
                    ],
                  ),
                  if (!isCompact) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _LessonTypeLabel(type: lesson.type),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (!isCompact) ...[
          const SizedBox(height: AppSpacing.sm),
          _InfoLine(
            icon: Icons.location_on_outlined,
            text: lesson.classroom.isNotEmpty
                ? '${lesson.classroom}, ${lesson.building}'
                : lesson.building,
          ),
          if (lesson.teacherNames.isNotEmpty)
            _InfoLine(
              icon: Icons.person_outline,
              text: lesson.teacherNames.join(', '),
            ),
          if (lesson.groupNames.isNotEmpty)
            _InfoLine(
              icon: Icons.group_outlined,
              text: lesson.groupNames.join(', '),
            ),
          if (lesson.subgroup != null)
            _InfoLine(
              icon: Icons.subdirectory_arrow_right_outlined,
              text: 'Подгруппа ${lesson.subgroup}',
            ),
          if (lesson.note != null)
            _InfoLine(
              icon: Icons.info_outline,
              text: lesson.note!,
            ),
        ],
      ],
    );
  }
}

class _LessonTypeLabel extends StatelessWidget {
  const _LessonTypeLabel({
    required this.type,
  });

  final LessonType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String label;
    Color labelColor;

    switch (type) {
      case LessonType.lecture:
        label = 'Лекция';
        labelColor = colorScheme.primary;
        break;
      case LessonType.practice:
        label = 'Практика';
        labelColor = colorScheme.secondary;
        break;
      case LessonType.lab:
        label = 'Лабораторная';
        labelColor = colorScheme.tertiary;
        break;
      case LessonType.exam:
        label = 'Экзамен';
        labelColor = colorScheme.error;
        break;
      case LessonType.consultation:
        label = 'Консультация';
        labelColor = colorScheme.outline;
        break;
      case LessonType.event:
        label = 'Мероприятие';
        labelColor = colorScheme.primary;
        break;
      case LessonType.unknown:
        label = 'Неизвестный тип';
        labelColor = colorScheme.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: labelColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: labelColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: labelColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ReplacementBadge extends StatelessWidget {
  const _ReplacementBadge();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: isDark ? 0.35 : 0.55),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        'Замена',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconSm,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
