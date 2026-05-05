import 'package:flutter/material.dart';

import '../../../../theme/app_tokens.dart';
import '../../domain/lesson.dart';

/// Карточка занятия для списка.
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
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBr,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(lesson: lesson),
              AppSpacing.smGap,
              _InfoSection(lesson: lesson),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.subject,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.xsGap,
              _BadgesRow(lesson: lesson),
            ],
          ),
        ),
        AppSpacing.mdGap,
        _TimeColumn(
          startTime: lesson.startTime,
          endTime: lesson.endTime,
        ),
      ],
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.startTime,
    required this.endTime,
  });

  final DateTime startTime;
  final DateTime endTime;

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatTime(startTime),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
          ),
        ),
        Text(
          _formatTime(endTime),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        _InfoLine(
          icon: Icons.location_on_outlined,
          text: lesson.building.isNotEmpty && lesson.classroom.isNotEmpty
              ? '${lesson.building}, ${lesson.classroom}'
              : lesson.building.isNotEmpty
                  ? lesson.building
                  : lesson.classroom,
        ),
        if (lesson.teacherNames.isNotEmpty) ...[
          AppSpacing.xsGap,
          _InfoLine(
            icon: Icons.person_outline,
            text: lesson.teacherNames.join(', '),
          ),
        ],
        if (lesson.groupNames.isNotEmpty) ...[
          AppSpacing.xsGap,
          _InfoLine(
            icon: Icons.group_outlined,
            text: lesson.groupNames.join(', '),
          ),
        ],
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
        return 'Занятие';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badges = <Widget>[];
    
    final typeLabel = _lessonTypeLabel(lesson.type);
    if (typeLabel.isNotEmpty) {
      badges.add(
        _Badge(text: typeLabel),
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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.smBr,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconSm,
          color: colorScheme.onSurfaceVariant,
        ),
        AppSpacing.xsGap,
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
