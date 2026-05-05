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

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNoPairs = lesson.subject == 'Нет пар';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSizes.iconLg * 2.5,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isNoPairs
                ? colorScheme.surfaceContainerHighest
                : colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            _formatTime(lesson.startTime),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isNoPairs
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (!isNoPairs) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            _formatTime(lesson.endTime),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
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

  bool _hasAnyMetadata() {
    return lesson.classroom?.isNotEmpty == true ||
        lesson.teacherNames.isNotEmpty ||
        lesson.groupNames.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNoPairs = lesson.subject == 'Нет пар';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                lesson.subject,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isNoPairs
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isNoPairs) const SizedBox(width: AppSpacing.sm),
            if (!isNoPairs) _BadgesRow(lesson: lesson),
          ],
        ),
        if (_hasAnyMetadata() && !isCompact) const SizedBox(height: AppSpacing.xs),
        if (_hasAnyMetadata() && !isCompact)
          _MetadataSection(lesson: lesson),
      ],
    );
  }
}

class _MetadataSection extends StatelessWidget {
  const _MetadataSection({
    required this.lesson,
  });

  final Lesson lesson;

  bool _hasClassroom() => lesson.classroom?.isNotEmpty == true;
  bool _hasTeacher() => lesson.teacherNames.isNotEmpty;
  bool _hasGroup() => lesson.groupNames.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isNoPairs = lesson.subject == 'Нет пар';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasClassroom() && !isNoPairs)
          _InfoLine(
            icon: Icons.location_on_outlined,
            text: lesson.classroom!,
          ),
        if (_hasTeacher())
          _InfoLine(
            icon: Icons.person_outline,
            text: lesson.teacherNames.join(', '),
          ),
        if (_hasGroup())
          _InfoLine(
            icon: Icons.group_outlined,
            text: lesson.groupNames.join(', '),
          ),
      ],
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({
    required this.lesson,
  });

  final Lesson lesson;

  String _lessonTypeLabel(LessonType type) {
    switch (type) {
      case LessonType.lecture:
        return 'Лекция';
      case LessonType.practice:
        return 'Практика';
      case LessonType.lab:
        return 'Лаб.';
      case LessonType.exam:
        return 'Экзамен';
      case LessonType.consultation:
        return 'Консультация';
      case LessonType.event:
        return 'Событие';
      case LessonType.unknown:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];
    
    final typeLabel = _lessonTypeLabel(lesson.type);
    if (typeLabel.isNotEmpty) {
      badges.add(
        _Badge(text: typeLabel),
      );
    }

    if (lesson.isChange) {
      badges.add(
        _ReplacementBadge(),
      );
    }
    
    if (badges.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: badges,
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
