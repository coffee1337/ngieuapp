import 'package:flutter/material.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson_type_ext.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNoLesson = lesson.subject == 'Нет пар';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isNoLesson
            ? colorScheme.surface.withValues(alpha: 0.6)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: _buildTimeColumn(colorScheme, isNoLesson),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContentColumn(context, colorScheme, isNoLesson),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(ColorScheme colorScheme, bool isNoLesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatTime(lesson.startTime),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isNoLesson
                ? colorScheme.onSurface.withValues(alpha: 0.5)
                : colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatTime(lesson.endTime),
          style: TextStyle(
            fontSize: 15,
            color: isNoLesson
                ? colorScheme.onSurface.withValues(alpha: 0.4)
                : colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${lesson.pairNumber} пара',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentColumn(
    BuildContext context,
    ColorScheme colorScheme,
    bool isNoLesson,
  ) {
    if (isNoLesson) {
      return Text(
        lesson.subject,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                lesson.subject,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 96,
              child: Column(
                children: [
                  if (lesson.isChange) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Замена',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      lesson.type.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildMetadataRows(colorScheme),
      ],
    );
  }

  Widget _buildMetadataRows(ColorScheme colorScheme) {
    final locationText = [
      lesson.classroom,
      lesson.building,
    ].where((v) => v.trim().isNotEmpty).join(', ');
    final teacherText = lesson.teacherNames.join(', ');
    final groupText = lesson.groupNames.join(', ');

    return Column(
      children: [
        if (locationText.isNotEmpty) ...[
          _buildMetadataRow(
            icon: Icons.location_on_outlined,
            text: locationText,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 4),
        ],
        if (teacherText.isNotEmpty) ...[
          _buildMetadataRow(
            icon: Icons.person_outline,
            text: teacherText,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 4),
        ],
        if (groupText.isNotEmpty)
          _buildMetadataRow(
            icon: Icons.groups_outlined,
            text: groupText,
            colorScheme: colorScheme,
          ),
      ],
    );
  }

  Widget _buildMetadataRow({
    required IconData icon,
    required String text,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

String _formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

