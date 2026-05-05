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

  String _formatTime(DateTime time) => 
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

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
        border: Border.all(
          color: isNoPairs
              ? colorScheme.outline.withValues(alpha: 0.2)
              : colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: isNoPairs ? null : [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with subject and time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    lesson.subject,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontStyle: isNoPairs ? FontStyle.italic : null,
                      color: isNoPairs 
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                if (!isNoPairs)
                  Text(
                    _formatTime(lesson.startTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            
            if (!isNoPairs) ...[
              const SizedBox(height: AppSpacing.xs),
              
              // Type and replacement badge
              Row(
                children: [
                  Text(
                    _lessonTypeLabel(lesson.type),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (lesson.isChange) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        'Замена',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              // Metadata rows
              _buildMetadataRow(
                context,
                '📍',
                lesson.classroom,
                lesson.building,
              ),
              
              if (lesson.teacherNames.isNotEmpty)
                _buildMetadataRow(
                  context,
                  '👨‍🏫',
                  lesson.teacherNames.join(', '),
                  null,
                ),
              
              if (lesson.groupNames.isNotEmpty)
                _buildMetadataRow(
                  context,
                  '👥',
                  lesson.groupNames.join(', '),
                  null,
                ),
              
              if (lesson.subgroup != null)
                _buildMetadataRow(
                  context,
                  '📚',
                  'Подгруппа ${lesson.subgroup}',
                  null,
                ),
              
              if (lesson.note != null && lesson.note!.isNotEmpty)
                _buildMetadataRow(
                  context,
                  '📝',
                  lesson.note!,
                  null,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context,
    String icon,
    String primary,
    String? secondary,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.iconLg,
            child: Text(
              icon,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              secondary != null ? '$primary, $secondary' : primary,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
