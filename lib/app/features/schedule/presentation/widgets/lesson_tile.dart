import 'package:flutter/material.dart';

import '../../../../theme/app_tokens.dart';
import '../../domain/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNoLesson = lesson.subject == 'Нет пар';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimeColumn(
              startTime: lesson.startTime,
              endTime: lesson.endTime,
              pairNumber: lesson.pairNumber,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ContentColumn(lesson: lesson, isNoLesson: isNoLesson),
            ),
          ],
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
  });

  final DateTime startTime;
  final DateTime endTime;
  final int pairNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 74,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTime(startTime),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatTime(endTime),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '$pairNumber пара',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentColumn extends StatelessWidget {
  const _ContentColumn({required this.lesson, required this.isNoLesson});

  final Lesson lesson;
  final bool isNoLesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subject
        Text(
          lesson.subject,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isNoLesson
                ? colorScheme.onSurfaceVariant.withOpacity(0.6)
                : colorScheme.onSurface,
            fontStyle: isNoLesson ? FontStyle.italic : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        if (!isNoLesson) ...[
          const SizedBox(height: AppSpacing.sm),

          // Badges
          _BadgesSection(isChange: lesson.isChange, type: lesson.type),

          const SizedBox(height: AppSpacing.sm),

          // Metadata
          _MetadataSection(
            classroom: lesson.classroom,
            building: lesson.building,
            teacherNames: lesson.teacherNames,
            groupNames: lesson.groupNames,
          ),
        ],
      ],
    );
  }
}

class _BadgesSection extends StatelessWidget {
  const _BadgesSection({required this.isChange, required this.type});

  final bool isChange;
  final LessonType type;

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
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              'Замена',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.error.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            _lessonTypeLabel(type),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetadataSection extends StatelessWidget {
  const _MetadataSection({
    required this.classroom,
    required this.building,
    required this.teacherNames,
    required this.groupNames,
  });

  final String? classroom;
  final String? building;
  final List<String> teacherNames;
  final List<String> groupNames;

  @override
  Widget build(BuildContext context) {
    final locationText = _buildLocationText(classroom, building);
    final teachersText = teacherNames.isNotEmpty
        ? teacherNames.join(', ')
        : null;
    final groupsText = groupNames.isNotEmpty ? groupNames.join(', ') : null;

    return Column(
      children: [
        buildMetadataSection(
          context,
          icon: Icons.location_on_outlined,
          text: locationText,
        ),
        buildMetadataSection(
          context,
          icon: Icons.person_outline,
          text: teachersText,
        ),
        buildMetadataSection(
          context,
          icon: Icons.group_outlined,
          text: groupsText,
        ),
      ],
    );
  }

  String? _buildLocationText(String? classroom, String? building) {
    if (classroom == null || classroom.isEmpty) return null;

    if (building != null && building.isNotEmpty) {
      return '$classroom, $building';
    }

    return classroom;
  }
}

Widget buildMetadataSection(
  BuildContext context, {
  required IconData icon,
  required String? text,
}) {
  if (text == null || text.isEmpty) return const SizedBox.shrink();

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

String _formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

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
