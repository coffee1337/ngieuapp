import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class NextLessonCard extends StatelessWidget {
  const NextLessonCard({required this.lesson, super.key});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fmt = DateFormat('HH:mm');
    final now = DateTime.now();
    final isNow = now.isAfter(lesson.startTime) && now.isBefore(lesson.endTime);
    final minsUntilStart = lesson.startTime.difference(now).inMinutes;

    String statusText;
    if (isNow) {
      statusText = 'Идёт сейчас';
    } else if (minsUntilStart < 60) {
      statusText = 'Через $minsUntilStart мин';
    } else if (minsUntilStart < 60 * 24) {
      final h = minsUntilStart ~/ 60;
      statusText = 'Через $h ч';
    } else {
      statusText = DateFormat('EEE, HH:mm', 'ru_RU').format(lesson.startTime);
    }

    final containerColor = isNow
        ? theme.colorScheme.primaryContainer
        : (isDark
              ? theme.colorScheme.surfaceContainerHigh
              : theme.colorScheme.primaryContainer);

    final onContainerColor = isNow
        ? theme.colorScheme.onPrimaryContainer
        : (isDark
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onPrimaryContainer);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark && !isNow
            ? Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isNow ? Icons.play_circle_fill : Icons.upcoming,
                size: 18,
                color: onContainerColor,
              ),
              const SizedBox(width: 6),
              Text(
                isNow ? 'СЕЙЧАС' : 'СЛЕДУЮЩАЯ ПАРА',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: onContainerColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isNow
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isNow
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lesson.subject,
            style: theme.textTheme.titleMedium?.copyWith(
              color: onContainerColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: onContainerColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '${fmt.format(lesson.startTime)}—${fmt.format(lesson.endTime)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onContainerColor,
                ),
              ),
              const SizedBox(width: 12),
              if (lesson.classroom.isNotEmpty) ...[
                Icon(
                  Icons.place,
                  size: 14,
                  color: onContainerColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'Ауд. ${lesson.classroom}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onContainerColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
