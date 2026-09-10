import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson_type_ext.dart';
import 'package:ngieuapp/app/shared/widgets/app_components.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({required this.lesson, super.key});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isFree = lesson.subject == 'Нет пар';
    final accent = switch (lesson.type) {
      LessonType.lecture => scheme.primary,
      LessonType.practice => scheme.secondary,
      LessonType.lab => scheme.tertiary,
      LessonType.exam => scheme.error,
      _ => scheme.onSurfaceVariant,
    };
    final time = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatTime(lesson.startTime),
          style: theme.textTheme.titleLarge?.copyWith(
            color: isFree ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
        ),
        Text(
          _formatTime(lesson.endTime),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('${lesson.pairNumber} пара', style: theme.textTheme.bodySmall),
      ],
    );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFree) ...[
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              LessonTypeBadge(label: lesson.type.label, color: accent),
              if (lesson.isChange) const ChangeBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text(
          lesson.subject,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
            height: 1.35,
            color: isFree ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
        ),
        if (!isFree) ...[
          const SizedBox(height: AppSpacing.lg),
          if (lesson.classroom.trim().isNotEmpty ||
              lesson.building.trim().isNotEmpty)
            _LessonDetail(
              icon: Icons.location_on_outlined,
              text: [
                if (lesson.classroom.trim().isNotEmpty)
                  'Ауд. ${lesson.classroom}',
                if (lesson.building.trim().isNotEmpty) lesson.building,
              ].join(' · '),
              onTap: lesson.classroom.trim().isEmpty
                  ? null
                  : () => context.push(
                      '/campus?room=${Uri.encodeQueryComponent(lesson.classroom.trim())}',
                    ),
            ),
          if (lesson.teacherNames.isNotEmpty)
            _LessonDetail(
              icon: Icons.person_outline_rounded,
              text: lesson.teacherNames.join(', '),
            ),
          if (lesson.groupNames.isNotEmpty)
            _LessonDetail(
              icon: Icons.groups_outlined,
              text: lesson.groupNames.join(', '),
            ),
        ],
      ],
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isFree ? scheme.surfaceContainerLow : scheme.surfaceContainer,
        borderRadius: AppRadius.xxlBr,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 280 ||
                MediaQuery.textScalerOf(context).scale(16) > 24;
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  time,
                  const SizedBox(height: AppSpacing.xl),
                  content,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 76, child: time),
                Container(
                  width: 3,
                  height: 48,
                  margin: const EdgeInsets.only(left: 4, right: 16),
                  decoration: BoxDecoration(
                    color: isFree ? scheme.outlineVariant : accent,
                    borderRadius: AppRadius.pillBr,
                  ),
                ),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LessonDetail extends StatelessWidget {
  const _LessonDetail({required this.icon, required this.text, this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              borderRadius: AppRadius.mdBr,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: content,
              ),
            ),
    );
  }
}

String _formatTime(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
