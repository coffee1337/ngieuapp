import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/smart_gap.dart';
import 'package:ngieuapp/app/shared/widgets/empty_view.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class SmartGapsScreen extends ConsumerWidget {
  const SmartGapsScreen({required this.actorId, this.actorName, super.key});

  final String actorId;
  final String? actorName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final key = (actorId: actorId, weekStart: weekStart);
    final schedule = ref.watch(weekScheduleProvider(key));
    final weekEnd = weekStart.add(const Duration(days: 5));
    final rangeFormat = DateFormat('d MMM', 'ru_RU');

    return Scaffold(
      appBar: AppBar(title: const Text('Умные окна')),
      body: schedule.when(
        loading: () => const ScheduleSkeleton(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(rawWeekScheduleProvider(key)),
        ),
        data: (lessons) {
          final gaps = ref.watch(findSmartGapsProvider)(lessons: lessons);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _GapsHeader(
                  actorName: actorName,
                  range:
                      '${rangeFormat.format(weekStart)} — '
                      '${rangeFormat.format(weekEnd)}',
                  count: gaps.length,
                  onPrevious: () =>
                      ref.read(currentWeekStartProvider.notifier).prevWeek(),
                  onNext: () =>
                      ref.read(currentWeekStartProvider.notifier).nextWeek(),
                ),
              ),
              if (gaps.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyView(
                    icon: Icons.auto_awesome_rounded,
                    text: 'На этой неделе длинных окон нет',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.md,
                    AppSpacing.xl,
                    AppSpacing.section,
                  ),
                  sliver: SliverList.separated(
                    itemCount: gaps.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (context, index) => _GapCard(
                      gap: gaps[index],
                      onFindRoom: () => context.push(
                        '/schedule/free-rooms',
                        extra: gaps[index],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _GapsHeader extends StatelessWidget {
  const _GapsHeader({
    required this.actorName,
    required this.range,
    required this.count,
    required this.onPrevious,
    required this.onNext,
  });

  final String? actorName;
  final String range;
  final int count;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
        borderRadius: AppRadius.xxlBr,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            actorName ?? 'Выбранное расписание',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: 'Предыдущая неделя',
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  range,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Следующая неделя',
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            count == 0
                ? 'Свободных интервалов от 25 минут не найдено'
                : 'Найдено свободных интервалов: $count',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _GapCard extends StatelessWidget {
  const _GapCard({required this.gap, required this.onFindRoom});

  final SmartGap gap;
  final VoidCallback onFindRoom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final time = DateFormat('HH:mm', 'ru_RU');
    final date = DateFormat('EEEE, d MMMM', 'ru_RU').format(gap.date);
    final minutes = gap.duration.inMinutes;
    final durationText = minutes >= 60
        ? '${minutes ~/ 60} ч ${minutes % 60 == 0 ? '' : '${minutes % 60} мин'}'
        : '$minutes мин';

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: AppRadius.mdBr,
                  ),
                  child: Icon(
                    Icons.hourglass_empty_rounded,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${time.format(gap.start)} — ${time.format(gap.end)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${_capitalize(date)} · $durationText',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _LessonEdge(
              icon: Icons.logout_rounded,
              label: 'После',
              subject: gap.previousLesson.subject,
              room: gap.previousLesson.classroom,
            ),
            const SizedBox(height: AppSpacing.md),
            _LessonEdge(
              icon: Icons.login_rounded,
              label: 'Перед',
              subject: gap.nextLesson.subject,
              room: gap.nextLesson.classroom,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: onFindRoom,
                icon: const Icon(Icons.meeting_room_outlined),
                label: const Text('Подобрать свободную аудиторию'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _LessonEdge extends StatelessWidget {
  const _LessonEdge({
    required this.icon,
    required this.label,
    required this.subject,
    required this.room,
  });

  final IconData icon;
  final String label;
  final String subject;
  final String room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconMd, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 48,
          child: Text(label, style: theme.textTheme.labelMedium),
        ),
        Expanded(
          child: Text(
            subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        if (room.trim().isNotEmpty) ...[
          const SizedBox(width: AppSpacing.md),
          Text('ауд. $room', style: theme.textTheme.labelMedium),
        ],
      ],
    );
  }
}
