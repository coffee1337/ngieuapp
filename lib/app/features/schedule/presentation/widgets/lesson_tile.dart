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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Special case for "No lessons"
    if (lesson.subject == 'Нет пар' || (lesson.isEvent == false && lesson.subject == 'Нет пар')) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: AppRadius.lgBr,
        ),
        child: Text(
          'Нет пар',
          style: textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgBr,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.lgBr,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject
                  Text(
                    lesson.subject,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  
                  // Badges
                  _buildBadges(context),
                  
                  if (lesson.teacherNames.isNotEmpty || lesson.groupNames.isNotEmpty || _getLocationText().isNotEmpty) 
                    const SizedBox(height: AppSpacing.sm),
                  
                  // Metadata
                  _buildMetadata(context),
                ],
              ),
            ),
            
            // Time block
            _buildTimeBlock(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final badges = <Widget>[];
    
    // Change badge
    if (lesson.isChange) {
      badges.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: AppRadius.smBr,
          ),
          child: Text(
            'Замена',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    
    // Lesson type badge
    badges.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.smBr,
        ),
        child: Text(
          _lessonTypeLabel(lesson.type),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
    
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: badges,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        if (_getLocationText().isNotEmpty)
          _buildMetadataItem(
            context,
            Icons.location_on_outlined,
            _getLocationText(),
          ),
        
        // Teachers
        if (lesson.teacherNames.isNotEmpty)
          _buildMetadataItem(
            context,
            Icons.person_outline,
            lesson.teacherNames.join(', '),
          ),
        
        // Groups
        if (lesson.groupNames.isNotEmpty)
          _buildMetadataItem(
            context,
            Icons.group_outlined,
            lesson.groupNames.join(', '),
          ),
      ],
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start time (prominent)
          Text(
            _formatTime(lesson.startTime),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          // End time (calm)
          Text(
            _formatTime(lesson.endTime),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocationText() {
    if (lesson.classroom.isEmpty) {
      return lesson.building;
    }
    
    if (lesson.building.isEmpty) {
      return lesson.classroom;
    }
    
    if (lesson.classroom == 'Дистанционно') {
      return lesson.classroom;
    }
    
    return '${lesson.classroom} • ${lesson.building}';
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
}
