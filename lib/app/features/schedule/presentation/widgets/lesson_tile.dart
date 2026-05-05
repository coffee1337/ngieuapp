import 'package:flutter/material.dart';
import '../../domain/lesson.dart';
import '../../../theme/app_theme.dart';

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
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimeColumn(lesson: lesson),
            AppSpacing.smGap,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject - главный элемент
                  Text(
                    lesson.subject,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.xsGap,
                  // Badges ниже subject
                  _BadgesRow(lesson: lesson),
                  AppSpacing.xsGap,
                  // Metadata ниже badges
                  _InfoLine(
                    icon: Icons.person_outline,
                    text: lesson.teacher,
                  ),
                  if (lesson.group.isNotEmpty) ...[
                    AppSpacing.xsGap,
                    _InfoLine(
                      icon: Icons.group_outlined,
                      text: lesson.group,
                    ),
                  ],
                  AppSpacing.xsGap,
                  _InfoLine(
                    icon: Icons.room_outlined,
                    text: lesson.classroom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: AppSizes.lessonTimeColumnWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Компактный pill для номера пары
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: lesson.isChange 
                ? colorScheme.primary.withOpacity(0.1)
                : colorScheme.surfaceContainerHighest,
              borderRadius: AppRadius.pillBr,
            ),
            child: Text(
              '${lesson.pairNumber}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: lesson.isChange 
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.xsGap,
          Text(
            lesson.startTime,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            lesson.endTime,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badges = <Widget>[];
    
    // Бейдж "Замена" - заметный, но мягкий
    if (lesson.isChange) {
      badges.add(
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: colorScheme.error.withOpacity(0.1),
            borderRadius: AppRadius.smBr,
          ),
          child: Text(
            'Замена',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    
    // Бейдж типа занятия - вторичный
    if (lesson.type.isNotEmpty) {
      if (badges.isNotEmpty) {
        badges.add(AppSpacing.xsGap);
      }
      badges.add(
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: AppRadius.smBr,
          ),
          child: Text(
            lesson.type,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
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
