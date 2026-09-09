import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/data/favorite_actors_providers.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';
import 'package:ngieuapp/app/features/schedule/domain/favorite_actor.dart';
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
            onPressed: () => _toggleFavorite(ref, favorite, displayActor),
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
        child: Builder(
          builder: (context) => NestedScrollView(
            headerSliverBuilder: (context, innerScrolled) => [
              SliverToBoxAdapter(
                child: _WeekHeader(
                  weekStart: weekStart,
                  weekEnd: weekEnd,
                  weekTypeAsync: weekTypeAsync,
                  departmentName: displayActor?.departmentName,
                ),
              ),
              SliverToBoxAdapter(
                child: DayTabs(
                  weekStart: weekStart,
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
              data: (lessons) => TabBarView(
                children: List.generate(6, (index) {
                  final day = weekStart.add(Duration(days: index));
                  final dayLessons =
                      lessons
                          .where(
                            (lesson) => DateUtils.isSameDay(lesson.date, day),
                          )
                          .toList()
                        ..sort((a, b) => a.pairNumber.compareTo(b.pairNumber));
                  return RefreshIndicator(
                    color: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    onRefresh: () async =>
                        ref.invalidate(rawWeekScheduleProvider(key)),
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
              ),
            ),
          ),
        ),
      ),
    );
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
      await repo.addFavoriteActor(
        displayActor ??
            FavoriteActor(
              id: actorId,
              name: 'Расписание $actorId',
              type: ActorType.studentGroup,
              departmentId: 0,
              departmentName: '',
            ),
      );
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
    required this.weekStart,
    required this.weekEnd,
    required this.weekTypeAsync,
    required this.departmentName,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final AsyncValue<WeekType> weekTypeAsync;
  final String? departmentName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final fmt = DateFormat('d MMM', 'ru_RU');

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
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
          Center(
            child: TextButton.icon(
              onPressed: () =>
                  ref.read(currentWeekStartProvider.notifier).thisWeek(),
              icon: const Icon(Icons.today_rounded, size: 18),
              label: const Text('Сегодня'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          weekTypeAsync.when(
            data: (weekType) => _WeekTypeSelector(weekType: weekType),
            loading: () => Container(
              height: AppSizes.buttonHeightSm,
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
              height: AppSizes.buttonHeightSm,
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

class _WeekTypeSelector extends ConsumerWidget {
  const _WeekTypeSelector({required this.weekType});
  final WeekType weekType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(weekTypeOverrideProvider);
    final isEven = override ?? weekType.isEvenWeek;
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<bool>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlBr),
        ),
        segments: const [
          ButtonSegment(value: true, label: Text('Верхняя')),
          ButtonSegment(value: false, label: Text('Нижняя')),
        ],
        selected: {isEven},
        onSelectionChanged: (selection) =>
            ref.read(weekTypeOverrideProvider.notifier).state = selection.first,
      ),
    );
  }
}
