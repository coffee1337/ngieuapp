import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/core/network/connectivity_provider.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';
import 'package:ngieuapp/app/features/schedule/presentation/widgets/day_tabs.dart';
import 'package:ngieuapp/app/features/schedule/presentation/widgets/lesson_tile.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/shared/widgets/empty_view.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class WeekScheduleScreen extends ConsumerWidget {
  const WeekScheduleScreen({
    required this.actorId,
    this.initialActor,
    super.key,
  });
  final String actorId;
  final FavoriteActor? initialActor;

  int _todayIndex(DateTime weekStart) {
    final today = DateTime.now();
    final diff = DateTime(
      today.year,
      today.month,
      today.day,
    ).difference(weekStart).inDays;
    if (diff < 0) return 0;
    if (diff > 5) return 5;
    return diff;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final key = (actorId: actorId, weekStart: weekStart);
    final lessonsAsync = ref.watch(weekScheduleProvider(key));
    final weekEnd = weekStart.add(const Duration(days: 5));
    final showChanges = ref.watch(appSettingsProvider).showChanges;
    final theme = Theme.of(context);
    final weekTypeAsync = ref.watch(weekTypeProvider(weekStart));
    final currentDate =
        ref.watch(currentWeekTypeProvider).valueOrNull?.date ?? DateTime.now();
    final favorites = ref.watch(favoriteActorsProvider).valueOrNull ?? const [];
    final favorite = _favoriteById(favorites, actorId);
    final displayActor = favorite ?? _initialActorById(actorId);
    final isFavorite = favorite != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(displayActor?.name ?? 'Расписание'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.star_rounded : Icons.star_border),
            tooltip: isFavorite
                ? 'Удалить из избранного'
                : 'Добавить в избранное',
            onPressed: displayActor == null
                ? null
                : () => _toggleFavorite(ref, favorite, displayActor),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Выбрать расписание',
            onPressed: () => context.push('/schedule/pick'),
          ),
          IconButton(
            icon: Icon(
              showChanges
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: AppSizes.iconLg,
            ),
            tooltip: showChanges ? 'Скрыть изменения' : 'Показать изменения',
            onPressed: () => ref
                .read(appSettingsProvider.notifier)
                .setShowChanges(!showChanges),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 6,
        initialIndex: _todayIndex(weekStart),
        animationDuration: AppDurations.normal,
        child: Builder(
          builder: (context) => NestedScrollView(
            headerSliverBuilder: (context, innerScrolled) => [
              SliverToBoxAdapter(
                child: _WeekHeader(
                  actorId: actorId,
                  weekStart: weekStart,
                  weekEnd: weekEnd,
                  weekTypeAsync: weekTypeAsync,
                  departmentName: displayActor?.departmentName,
                ),
              ),
              SliverToBoxAdapter(
                child: DayTabs(
                  weekStart: weekStart,
                  currentDate: currentDate,
                  tabController: DefaultTabController.of(context),
                ),
              ),
            ],
            body: lessonsAsync.when(
              loading: () => const ScheduleSkeleton(),
              error: (error, _) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(rawWeekScheduleProvider(key)),
              ),
              data: (lessons) {
                final lessonsByDay = _groupLessonsByDay(lessons, weekStart);
                return TabBarView(
                  physics: const PageScrollPhysics(),
                  children: List.generate(6, (index) {
                    final day = weekStart.add(Duration(days: index));
                    final dayLessons = lessonsByDay[index];
                    return RefreshIndicator(
                      color: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      onRefresh: () => _refresh(context, ref, key),
                      child: ListView.builder(
                        key: PageStorageKey(
                          '${actorId}_${day.toIso8601String()}',
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: dayLessons.isEmpty ? 1 : dayLessons.length,
                        itemBuilder: (_, itemIndex) => dayLessons.isEmpty
                            ? const EmptyView(
                                text: 'В этот день занятий нет',
                                icon: Icons.self_improvement,
                              )
                            : LessonTile(lesson: dayLessons[itemIndex]),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<List<Lesson>> _groupLessonsByDay(
    List<Lesson> lessons,
    DateTime weekStart,
  ) {
    final days = List.generate(6, (_) => <Lesson>[]);
    for (final lesson in lessons) {
      final index = DateTime(
        lesson.date.year,
        lesson.date.month,
        lesson.date.day,
      ).difference(weekStart).inDays;
      if (index >= 0 && index < days.length) days[index].add(lesson);
    }
    for (final lessons in days) {
      lessons.sort((a, b) => a.pairNumber.compareTo(b.pairNumber));
    }
    return days;
  }

  Future<void> _refresh(
    BuildContext context,
    WidgetRef ref,
    WeekKey key,
  ) async {
    try {
      await ref.read(refreshWeekScheduleProvider)(key);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Не удалось обновить расписание. Сохранённые данные доступны офлайн.',
          ),
        ),
      );
    }
  }

  FavoriteActor? _favoriteById(List<FavoriteActor> favorites, String actorId) {
    for (final favorite in favorites) {
      if (favorite.id == actorId) return favorite;
    }
    return null;
  }

  FavoriteActor? _initialActorById(String actorId) {
    final actor = initialActor;
    if (actor == null || actor.id != actorId) return null;
    return actor;
  }

  Future<void> _toggleFavorite(
    WidgetRef ref,
    FavoriteActor? favorite,
    FavoriteActor? displayActor,
  ) async {
    final repo = ref.read(favoriteActorsLocalDataSourceProvider);
    if (favorite == null) {
      await repo.addFavoriteActor(displayActor!);
    } else {
      await repo.removeFavoriteActor(actorId);
    }
    ref
      ..invalidate(favoriteActorsProvider)
      ..invalidate(activeFavoriteActorIdProvider);
  }
}

class _WeekHeader extends ConsumerWidget {
  const _WeekHeader({
    required this.actorId,
    required this.weekStart,
    required this.weekEnd,
    required this.weekTypeAsync,
    required this.departmentName,
  });

  final String actorId;
  final DateTime weekStart;
  final DateTime weekEnd;
  final AsyncValue<WeekType> weekTypeAsync;
  final String? departmentName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final isOnline = ref.watch(connectivityProvider);
    final lastUpdated = ref.watch(scheduleLastUpdatedProvider(actorId));
    final fmt = DateFormat('d MMM', 'ru_RU');
    final currentDate =
        ref.watch(currentWeekTypeProvider).valueOrNull?.date ?? DateTime.now();
    final isCurrentWeek = DateUtils.isSameDay(
      weekStart,
      currentDate.startOfWeek,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: semantic.subtleDivider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (departmentName != null && departmentName!.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.star_outline,
                  size: AppSizes.iconSm,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    departmentName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          _ScheduleFreshness(
            isOnline: isOnline,
            lastUpdated: lastUpdated.valueOrNull,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              _WeekNavButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Предыдущая неделя',
                onTap: () =>
                    ref.read(currentWeekStartProvider.notifier).prevWeek(),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context, ref),
                  child: Text(
                    '${fmt.format(weekStart)} — ${fmt.format(weekEnd)}',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              _WeekNavButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Следующая неделя',
                onTap: () =>
                    ref.read(currentWeekStartProvider.notifier).nextWeek(),
              ),
            ],
          ),
          if (!isCurrentWeek)
            Center(
              child: TextButton.icon(
                onPressed: () =>
                    ref.read(currentWeekStartProvider.notifier).thisWeek(),
                icon: const Icon(Icons.today_rounded, size: 18),
                label: const Text('Вернуться к текущей неделе'),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          weekTypeAsync.when(
            data: (weekType) => _WeekTypeIndicator(
              isUpperWeek: weekType.isUpperWeek,
              isCurrentWeek: isCurrentWeek,
            ),
            loading: () => Container(
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: AppRadius.mdBr,
                border: Border.all(color: semantic.cardBorder),
              ),
              child: const Center(
                child: SizedBox(
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => Container(
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: AppRadius.mdBr,
              ),
              child: Center(
                child: Text(
                  weekStart.isEvenWeek ? 'Верхняя неделя' : 'Нижняя неделя',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(currentWeekStartProvider),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null) {
      ref.read(currentWeekStartProvider.notifier).setDate(picked);
    }
  }
}

class _ScheduleFreshness extends StatelessWidget {
  const _ScheduleFreshness({required this.isOnline, required this.lastUpdated});

  final bool isOnline;
  final DateTime? lastUpdated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timestamp = lastUpdated;
    final text = switch ((isOnline, timestamp)) {
      (false, final DateTime value) =>
        'Офлайн • данные от ${_formatUpdatedAt(value)}',
      (false, null) => 'Офлайн • сохранённого расписания пока нет',
      (true, final DateTime value) =>
        'Последнее обновление: ${_formatUpdatedAt(value)}',
      (true, null) => 'Расписание ещё не сохранено',
    };

    return Row(
      children: [
        Icon(
          isOnline ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
          size: AppSizes.iconSm,
          color: isOnline ? theme.colorScheme.primary : theme.colorScheme.error,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatUpdatedAt(DateTime value) {
    final pattern = DateUtils.isSameDay(value, DateTime.now())
        ? 'Сегодня, HH:mm'
        : 'd MMM, HH:mm';
    return DateFormat(pattern, 'ru_RU').format(value);
  }
}

class _WeekNavButton extends StatelessWidget {
  const _WeekNavButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size.square(AppSizes.weekNavButtonSize),
        backgroundColor: scheme.surfaceContainer,
        foregroundColor: scheme.onSurface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlBr),
      ),
    );
  }
}

class _WeekTypeIndicator extends StatelessWidget {
  const _WeekTypeIndicator({
    required this.isUpperWeek,
    required this.isCurrentWeek,
  });

  final bool isUpperWeek;
  final bool isCurrentWeek;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = isCurrentWeek
        ? scheme.onPrimaryContainer
        : scheme.onSurface;

    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isCurrentWeek
            ? scheme.primaryContainer
            : scheme.surfaceContainerHigh,
        borderRadius: AppRadius.xlBr,
        border: Border.all(
          color: isCurrentWeek ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCurrentWeek
                  ? scheme.primary.withValues(alpha: 0.12)
                  : scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUpperWeek
                  ? Icons.keyboard_double_arrow_up_rounded
                  : Icons.keyboard_double_arrow_down_rounded,
              color: isCurrentWeek ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUpperWeek ? 'Верхняя неделя' : 'Нижняя неделя',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Определено автоматически по дате',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isCurrentWeek
                        ? scheme.onPrimaryContainer.withValues(alpha: 0.78)
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentWeek) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.pillBr,
              ),
              child: Text(
                'Сейчас',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
