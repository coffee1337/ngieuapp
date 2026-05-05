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
    
    final isNoLesson = lesson.subject == 'Нет пар' || 
                      lesson.subject.toLowerCase().contains('нет пар');
    final showReplacementBadge = lesson.isChange && !isNoLesson;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: isNoLesson 
          ? colorScheme.surfaceVariant.withOpacity(0.5)
          : colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Левая колонка времени
              SizedBox(
                width: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTime(lesson.startTime),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isNoLesson 
                            ? colorScheme.onSurfaceVariant.withOpacity(0.6)
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(lesson.endTime),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isNoLesson 
                            ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isNoLesson 
                            ? colorScheme.outline.withOpacity(0.2)
                            : colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${lesson.pairNumber} пара',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isNoLesson 
                              ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                              : colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Правая часть с информацией
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Верхняя строка с предметом и бейджами
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            lesson.subject,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontStyle: isNoLesson ? FontStyle.italic : null,
                              color: isNoLesson 
                                  ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                                  : colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showReplacementBadge || !isNoLesson) ...[
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (showReplacementBadge)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Замена',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              if (!isNoLesson) ...[
                                if (showReplacementBadge) const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _lessonTypeLabel(lesson.type),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                    if (!isNoLesson) ...[
                      const SizedBox(height: 12),
                      // Метаданные
                      _buildMetadataSection(
                        context,
                        icon: Icons.location_on_outlined,
                        text: lesson.classroom.isNotEmpty 
                            ? lesson.building.isNotEmpty 
                                ? '${lesson.classroom}, ${lesson.building}'
                                : lesson.classroom
                            : null,
                      ),
                      _buildMetadataSection(
                        context,
                        icon: Icons.person_outline,
                        text: lesson.teacherNames.isNotEmpty 
                            ? lesson.teacherNames.join(', ')
                            : null,
                      ),
                      _buildMetadataSection(
                        context,
                        icon: Icons.group_outlined,
                        text: lesson.groupNames.isNotEmpty 
                            ? lesson.groupNames.join(', ')
                            : null,
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

  Widget _buildMetadataSection(
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
