import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/app_components.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/lesson.dart';
import '../../domain/utils/floor_utils.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.lesson});
  final Lesson lesson;

  Color _typeColor(BuildContext context) {
    final brand = Theme.of(context).extension<BrandColors>();
    if (brand == null) return Theme.of(context).colorScheme.primary;
    return switch (lesson.type) {
      LessonType.lecture => brand.primaryBrand,
      LessonType.practice => brand.purple,
      LessonType.lab => brand.deepBlue,
      LessonType.exam => Theme.of(context).colorScheme.error,
      LessonType.consultation => brand.orange,
      LessonType.event => const Color(0xFF4CAF50),
      LessonType.unknown => Theme.of(context).colorScheme.outline,
    };
  }

  String _typeLabel() => switch (lesson.type) {
    LessonType.lecture => 'Лекция',
    LessonType.practice => 'Практика',
    LessonType.lab => 'Лаб. работа',
    LessonType.exam => 'Экзамен',
    LessonType.consultation => 'Консультация',
    LessonType.event => 'Мероприятие',
    LessonType.unknown => '',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = DateFormat('HH:mm');
    final typeColor = _typeColor(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: time column with type accent stripe
            _TimeColumn(
              startTime: fmt.format(lesson.startTime),
              endTime: fmt.format(lesson.endTime),
              pairNumber: lesson.pairNumber,
              accentColor: typeColor,
            ),
            // Right: lesson content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges row: type + change status
                    _BadgesRow(
                      typeLabel: _typeLabel(),
                      typeColor: typeColor,
                      isChange: lesson.isChange,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Subject name -- main element
                    Text(
                      lesson.subject,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Teacher
                    if (lesson.teacherNames.isNotEmpty)
                      _InfoLine(
                        icon: Icons.person_outline,
                        text: lesson.teacherNames.join(', '),
                      ),
                    // Classroom
                    if (lesson.classroom.isNotEmpty)
                      _InfoLine(
                        icon: Icons.place_outlined,
                        text: FloorUtils.formatRoomForLesson(lesson.classroom),
                      ),
                    // Groups
                    if (lesson.groupNames.isNotEmpty)
                      _InfoLine(
                        icon: Icons.groups_outlined,
                        text: lesson.groupNames.join(', '),
                      ),
                  ],
                ),
              ),
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
    required this.accentColor,
  });

  final String startTime;
  final String endTime;
  final int pairNumber;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: AppSizes.lessonTimeColumnWidth,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          bottomLeft: Radius.circular(AppRadius.lg),
        ),
        border: Border(
          right: BorderSide(
            color: accentColor.withValues(alpha: 0.4),
            width: 2.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            startTime,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            endTime,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.xsBr,
            ),
            child: Text(
              '$pairNumber пара',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: accentColor,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({
    required this.typeLabel,
    required this.typeColor,
    required this.isChange,
  });

  final String typeLabel;
  final Color typeColor;
  final bool isChange;

  @override
  Widget build(BuildContext context) {
    if (typeLabel.isEmpty && !isChange) return const SizedBox.shrink();
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        if (typeLabel.isNotEmpty)
          LessonTypeBadge(label: typeLabel, color: typeColor),
        if (isChange) const ChangeBadge(),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconSm,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
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
