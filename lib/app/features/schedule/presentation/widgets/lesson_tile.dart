import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/lesson.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.lesson});
  final Lesson lesson;

  Color _typeColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    return switch (lesson.type) {
      LessonType.lecture => isDark ? scheme.primary : scheme.primary,
      LessonType.practice => isDark ? const Color(0xFF80CBC4) : scheme.tertiary,
      LessonType.lab => isDark ? const Color(0xFFCE93D8) : scheme.secondary,
      LessonType.exam => scheme.error,
      LessonType.consultation => isDark ? scheme.outline : scheme.outline,
      LessonType.event => isDark ? const Color(0xFF80CBC4) : scheme.tertiary,
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
    final isDark = theme.brightness == Brightness.dark;

    // Change card background: subtle for dark, with error tint for changes
    final cardColor = lesson.isChange
        ? (isDark
            ? theme.colorScheme.error.withValues(alpha: 0.15)
            : theme.colorScheme.errorContainer.withValues(alpha: 0.5))
        : theme.colorScheme.surfaceContainer;

    final borderColor = lesson.isChange
        ? theme.colorScheme.error.withValues(alpha: isDark ? 0.6 : 0.7)
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.2)
            : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left strip
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
            // Time + pair number
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fmt.format(lesson.startTime)}\n${fmt.format(lesson.endTime)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                      fontFeatures: const [FontFeature.tabularFigures()],
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
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type + change badge
                    Row(
                      children: [
                        if (_typeLabel().isNotEmpty)
                          Text(
                            _typeLabel(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (lesson.isChange) ...[
                          if (_typeLabel().isNotEmpty) const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? theme.colorScheme.error.withValues(alpha: 0.8)
                                  : theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ЗАМЕНА',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : theme.colorScheme.onError,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      lesson.subject,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
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
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
