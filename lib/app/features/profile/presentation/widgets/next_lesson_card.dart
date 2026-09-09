import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class NextLessonCard extends StatelessWidget {
  const NextLessonCard({required this.lesson, super.key});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fmt = DateFormat('HH:mm');
    final now = DateTime.now();
    final isNow =
        !now.isBefore(lesson.startTime) && now.isBefore(lesson.endTime);
    final minutes = lesson.startTime.difference(now).inMinutes;
    final String status;
    if (isNow) {
      status = 'Идёт сейчас';
    } else if (minutes >= 0 && minutes < 60) {
      status = 'Через $minutes мин';
    } else if (minutes >= 60 && minutes < 1440) {
      status = 'Через ${minutes ~/ 60} ч';
    } else {
      status = DateFormat('EEE, HH:mm', 'ru_RU').format(lesson.startTime);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  isNow ? 'Текущая пара' : 'Следующая пара',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: AppRadius.smBr,
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(lesson.subject, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
            _LessonInfo(
              icon: Icons.schedule_rounded,
              text:
                  '${fmt.format(lesson.startTime)} — ${fmt.format(lesson.endTime)}',
            ),
            if (lesson.classroom.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _LessonInfo(
                icon: Icons.place_outlined,
                text: 'Ауд. ${lesson.classroom}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonInfo extends StatelessWidget {
  const _LessonInfo({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
