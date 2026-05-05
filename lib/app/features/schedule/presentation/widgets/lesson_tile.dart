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
    final brightness = Theme.of(context).brightness;

    // Special case for "No lessons"
    if (lesson.subject == 'Нет пар' || (lesson.isEvent == false && lesson.subject == 'Нет пар')) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.lgBr,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgBr,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time column
                SizedBox(
                  width: 52,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.startTimeFormatted,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lesson.endTimeFormatted,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject with badges
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              lesson.subject,
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          // Badges
                          if (lesson.isReplacement)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer.withValues(
                                  alpha: brightness == Brightness.dark ? 0.35 : 0.55,
                                ),
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
                          if (lesson.isEvent && lesson.lessonType != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
                                borderRadius: AppRadius.smBr,
                              ),
                              child: Text(
                                lesson.lessonType!,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Metadata
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (lesson.classroom.isNotEmpty || lesson.building.isNotEmpty)
                            _buildMetadataRow(
                              context,
                              Icons.room_outlined,
                              _formatLocation(lesson.classroom, lesson.building),
                              colorScheme,
                              textTheme,
                            ),
                          if (lesson.teacher.isNotEmpty)
                            _buildMetadataRow(
                              context,
                              Icons.person_outline,
                              lesson.teacher,
                              colorScheme,
                              textTheme,
                            ),
                          if (lesson.group.isNotEmpty)
                            _buildMetadataRow(
                              context,
                              Icons.group_outlined,
                              lesson.group,
                              colorScheme,
                              textTheme,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context,
    IconData icon,
    String text,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLocation(String classroom, String building) {
    if (classroom.isEmpty) return building;
    if (building.isEmpty) return classroom;
    if (classroom == building) return classroom;
    return '$classroom, $building';
  }
}
