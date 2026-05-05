import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../schedule/domain/lesson.dart';
import '../../schedule/providers/schedule_provider.dart';
import '../widgets/lesson_type_badge.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    this.onTap,
    this.onLongPress,
  });

  final Lesson lesson;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scheduleProvider = context.read<ScheduleProvider>();
    final isCompact = scheduleProvider.isCompactMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppRadius.lgBr,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? colorScheme.outlineVariant.withValues(alpha: 0.15)
                  : colorScheme.outlineVariant.withValues(alpha: 0.25),
              width: 0.5,
            ),
            borderRadius: AppRadius.lgBr,
            color: lesson.isChange
                ? colorScheme.errorContainer.withValues(alpha: 0.05)
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: isCompact ? AppSpacing.sm : AppSpacing.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimeColumn(
                  lesson: lesson,
                  isCompact: isCompact,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ContentColumn(
                    lesson: lesson,
                    isCompact: isCompact,
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
    required this.lesson,
    required this.isCompact,
  });

  final Lesson lesson;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.pairNumber.toString(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: lesson.isChange
                  ? colorScheme.error
                  : colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatTime(lesson.startTime),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatTime(lesson.endTime),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentColumn extends StatelessWidget {
  const _ContentColumn({
    required this.lesson,
    required this.isCompact,
  });

  final Lesson lesson;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (lesson.subject.isEmpty) {
      return _buildEmptyLesson(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                lesson.subject,
                style: TextStyle(
                  fontSize: isCompact ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: isCompact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (!isCompact) ...[
          const SizedBox(height: 4),
          _buildBadges(context),
        ],
        const SizedBox(height: 6),
        _buildMetadata(context),
      ],
    );
  }

  Widget _buildEmptyLesson(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Нет пар',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBadges(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        if (lesson.isChange)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.12),
              borderRadius: AppRadius.xsBr,
            ),
            child: Text(
              'Замена',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (lesson.type != LessonType.unknown)
          LessonTypeBadge(type: lesson.type),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final locationText = _buildLocationText(lesson.classroom, lesson.building);
    final teachersText = lesson.teacherNames.join(', ');
    final groupsText = lesson.groupNames.join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.2,
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
