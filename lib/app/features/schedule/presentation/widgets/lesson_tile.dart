import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:timetable/gen/assets.gen.dart';
import 'package:timetable/app/features/schedule/domain/lesson.dart';
import 'package:timetable/app/theme/app_colors.dart';
import 'package:timetable/app/theme/app_tokens.dart';
import 'package:timetable/app/theme/app_typography.dart';

class LessonTile extends HookConsumerWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    this.isCompact = false,
    this.showDate = false,
    this.onTap,
  });

  final Lesson lesson;
  final bool isCompact;
  final bool showDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final time = '${_formatTime(lesson.startTime)} - ${_formatTime(lesson.endTime)}';
    final subject = lesson.subject;
    final type = _lessonTypeLabel(lesson.type);
    final room = lesson.classroom;
    final building = lesson.building;

    final teacherNames = lesson.teacherNames;
    final groupNames = lesson.groupNames;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgBr,
        child: Ink(
          padding: EdgeInsets.all(isCompact ? AppSpacing.sm : AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.lgBr,
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDate)
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    _formatDate(lesson.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time column
                  SizedBox(
                    width: AppSizes.lessonTimeColumnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          time,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (lesson.isChange)
                          Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xs),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: AppSpacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.error.withOpacity(0.1),
                                borderRadius: AppRadius.xsBr,
                              ),
                              child: Text(
                                'Замена',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.error,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  // Main content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject and type
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subject,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!lesson.isEvent && type != 'Занятие')
                              Container(
                                margin: EdgeInsets.only(left: AppSpacing.sm),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: AppSpacing.xxs,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer.withOpacity(0.3),
                                  borderRadius: AppRadius.xsBr,
                                ),
                                child: Text(
                                  type,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        // Room and building
                        if (room.isNotEmpty || building.isNotEmpty)
                          Row(
                            children: [
                              Assets.icons.location.svg(
                                width: AppSizes.iconSm,
                                height: AppSizes.iconSm,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                room.isNotEmpty && building.isNotEmpty
                                    ? '$room, $building'
                                    : room.isNotEmpty
                                        ? room
                                        : building,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        // Metadata (teachers and groups)
                        if (teacherNames.isNotEmpty || groupNames.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xs),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (teacherNames.isNotEmpty)
                                  Row(
                                    children: [
                                      Assets.icons.person.svg(
                                        width: AppSizes.iconSm,
                                        height: AppSizes.iconSm,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      SizedBox(width: AppSpacing.xs),
                                      Expanded(
                                        child: Text(
                                          teacherNames.join(', '),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (groupNames.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: AppSpacing.xs),
                                    child: Row(
                                      children: [
                                        Assets.icons.group.svg(
                                          width: AppSizes.iconSm,
                                          height: AppSizes.iconSm,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        SizedBox(width: AppSpacing.xs),
                                        Expanded(
                                          child: Text(
                                            groupNames.join(', '),
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptySlotTile extends HookConsumerWidget {
  const EmptySlotTile({
    super.key,
    required this.pairNumber,
    this.isCompact = false,
    this.showDate = false,
    this.onTap,
  });

  final int pairNumber;
  final bool isCompact;
  final bool showDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgBr,
        child: Ink(
          padding: EdgeInsets.all(isCompact ? AppSpacing.sm : AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadius.lgBr,
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Time column
              SizedBox(
                width: AppSizes.lessonTimeColumnWidth,
                child: Text(
                  '${pairNumber * 2 - 1:02d}:00\n-${pairNumber * 2:02d}:00',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // Empty slot indicator
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Нет пар',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.4),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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

String _formatDate(DateTime date) {
  const months = [
    'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
    'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
  ];
  return '${date.day} ${months[date.month - 1]}';
}
