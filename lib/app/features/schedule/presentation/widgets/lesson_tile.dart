import 'package:flutter/material.dart';
import '../../domain/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDarkMode = theme.brightness == Brightness.dark;
    final isNoLesson = lesson.subject == 'Нет пар';

    return Card(
      elevation: 0,
      color: isDarkMode
          ? colorScheme.surfaceContainerLow.withValues(alpha: 0.35)
          : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: isDarkMode ? 0.1 : 0.15),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: isNoLesson
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : const EdgeInsets.all(16),
        child: isNoLesson
            ? _buildNoLessonContent(context)
            : _buildLessonContent(context),
      ),
    );
  }

  Widget _buildNoLessonContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 86,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(lesson.startTime),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(lesson.endTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            lesson.subject,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time column - fixed width 86px
        SizedBox(
          width: 86,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(lesson.startTime),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(lesson.endTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${lesson.pairNumber} пара',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Content column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject with badges
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.subject,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _buildBadges(context),
                ],
              ),
              const SizedBox(height: 8),
              // Metadata
              _buildMetadata(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadges(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        if (lesson.isChange)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Text(
              'Замена',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.red.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colorScheme.outline.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _lessonTypeLabel(lesson.type),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final location = lesson.classroom.isNotEmpty ? lesson.classroom : null;
    final teachers = lesson.teacherNames.isNotEmpty ? lesson.teacherNames.join(', ') : null;
    final groups = lesson.groupNames.isNotEmpty ? lesson.groupNames.join(', ') : null;

    return Column(
      children: [
        if (location != null)
          _buildMetadataRow(context, icon: Icons.location_on_outlined, text: location),
        if (teachers != null)
          _buildMetadataRow(context, icon: Icons.person_outline, text: teachers),
        if (groups != null)
          _buildMetadataRow(context, icon: Icons.group_outlined, text: groups),
      ],
    );
  }

  Widget _buildMetadataRow(
    BuildContext context, {
    required IconData icon,
    required String? text,
  }) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                height: 1.1,
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
