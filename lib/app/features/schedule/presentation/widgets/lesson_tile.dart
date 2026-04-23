import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.lesson});
  final Lesson lesson;

  Color _typeColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (lesson.type) {
      LessonType.lecture => scheme.primary,
      LessonType.practice => scheme.tertiary,
      LessonType.lab => scheme.secondary,
      LessonType.exam => scheme.error,
      LessonType.consultation => scheme.outline,
      LessonType.event => scheme.tertiary,
      LessonType.unknown => scheme.outline,
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: lesson.isChange
            ? theme.colorScheme.errorContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: lesson.isChange
            ? Border.all(color: theme.colorScheme.error, width: 1)
            : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fmt.format(lesson.startTime)}\n${fmt.format(lesson.endTime)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.pairNumber} пара',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (_typeLabel().isNotEmpty)
                          Text(
                            _typeLabel(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (lesson.isChange) ...[
                          if (_typeLabel().isNotEmpty) const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ЗАМЕНА',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lesson.subject,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (lesson.teacherNames.isNotEmpty)
                      _IconLine(
                        icon: Icons.person_outline,
                        text: lesson.teacherNames.join(', '),
                      ),
                    if (lesson.classroom.isNotEmpty)
                      _IconLine(
                        icon: Icons.place_outlined,
                        text: lesson.building.isEmpty
                            ? 'Ауд. ${lesson.classroom}'
                            : 'Ауд. ${lesson.classroom} (${lesson.building})',
                      ),
                    if (lesson.groupNames.isNotEmpty)
                      _IconLine(
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

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}