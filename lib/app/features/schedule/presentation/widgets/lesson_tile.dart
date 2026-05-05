import 'package:flutter/material.dart';

import '../../../../theme/app_tokens.dart';
import '../../domain/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    required this.lesson,
    required this.startTime,
    required this.endTime,
    this.isCompact = false,
    this.onTap,
    super.key,
  });

  final Lesson lesson;
  final String startTime;
  final String endTime;
  final bool isCompact;
  final VoidCallback? onTap;

  bool get _hasAnyMetadata =>
      (lesson.classroom?.isNotEmpty == true) ||
      lesson.teacherNames.isNotEmpty ||
      lesson.groupNames.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TimeColumn(
                startTime: startTime,
                endTime: endTime,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _LessonContent(lesson: lesson),
              ),
            ],
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
  });

  final String startTime;
  final String endTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.lessonTimeColumnWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            startTime,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            endTime,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({
    required this.lesson,
  });

  final Lesson lesson;

  bool get _hasAnyMetadata =>
      (lesson.classroom?.isNotEmpty == true) ||
      lesson.teacherNames.isNotEmpty ||
      lesson.groupNames.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isNoPairs = lesson.subject == 'Нет пар';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.subject,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (_hasAnyMetadata) const SizedBox(height: AppSpacing.xs),
              if (_hasAnyMetadata)
                _MetadataSection(lesson: lesson),
            ],
          ),
        ),
        if (!isNoPairs) const SizedBox(width: AppSpacing.sm),
        if (!isNoPairs) _BadgesRow(lesson: lesson),
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
