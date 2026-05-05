import 'package:flutter/material.dart';

import '../../../../theme/app_tokens.dart';
import '../../domain/lesson.dart';

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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdBr,
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBr,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time column
              SizedBox(
                width: AppSizes.lessonTimeColumnWidth,
                child: Text(
                  '${_formatTime(lesson.startTime)}\n${_formatTime(lesson.endTime)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject and badges row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lesson.subject,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lesson.isChange) ...[
                          SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.1),
                              borderRadius: AppRadius.smBr,
                            ),
                            child: Text(
                              'Замена',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    // Type and classroom
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.3),
                            borderRadius: AppRadius.smBr,
                          ),
                          child: Text(
                            _lessonTypeLabel(lesson.type),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          lesson.classroom,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (lesson.building.isNotEmpty) ...[
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            lesson.building,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Teachers or groups
                    if (lesson.teacherNames.isNotEmpty || lesson.groupNames.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        lesson.teacherNames.isNotEmpty
                            ? lesson.teacherNames.join(', ')
                            : lesson.groupNames.join(', '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
