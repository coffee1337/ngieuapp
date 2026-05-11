import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/core/utils/date_ext.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';
import 'package:ngieuapp/app/features/schedule/domain/week_type.dart';
import 'package:ngieuapp/app/features/schedule/presentation/widgets/day_tabs.dart';
import 'package:ngieuapp/app/features/schedule/presentation/widgets/lesson_tile.dart';
import 'package:ngieuapp/app/features/settings/data/settings_providers.dart';
import 'package:ngieuapp/app/shared/widgets/app_gradient_bar.dart';
import 'package:ngieuapp/app/shared/widgets/empty_view.dart';
import 'package:ngieuapp/app/shared/widgets/error_view.dart';
import 'package:ngieuapp/app/shared/widgets/skeleton.dart';
import 'package:ngieuapp/app/theme/app_theme.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class WeekScheduleScreen extends ConsumerWidget {
  const WeekScheduleScreen({required this.actorId, super.key});
  final String actorId;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(AppSizes.gradientBarHeight),
          child: AppGradientBar(),
        ),
      ),
      body: Column(
        children: [
          _WeekHeader(
            weekStart: weekStart,
            weekEnd: weekEnd,
            weekTypeAsync: weekTypeAsync,
          ),
          Expanded(
            child: DefaultTabController(
              length: 6,
              initialIndex: _todayIndex(weekStart),
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      final tabController = DefaultTabController.of(context);
                      return DayTabs(
                        weekStart: weekStart,
                        tabController: tabController,
                      );
                    },
                  ),
                  Expanded(
                    child: lessonsAsync.when(
                      loading: () => const ScheduleSkeleton(),
                      error: (e, _) => ErrorView(
                        error: e,
                        onRetry: () =>
                            ref.invalidate(rawWeekScheduleProvider(key)),
                      ),
                      data: (lessons) => TabBarView(
                        children: List.generate(6, (i) {
                          final day = weekStart.add(Duration(days: i));
                          final dayLessons =
                              lessons
                                  .where(
                                    (l) =>
                                        l.date.year == day.year &&
                                        l.date.month == day.month &&
                                        l.date.day == day.day,
                                  )
                                  .toList()
                                ..sort(
                                  (a, b) =>
                                      a.pairNumber.compareTo(b.pairNumber),
                                );
                          return RefreshIndicator(
                            color: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            onRefresh: () async =>
                                ref.invalidate(rawWeekScheduleProvider(key)),
                            child: dayLessons.isEmpty
                                ? ListView(
                                    children: const [
                                      SizedBox(height: 100),
                                      EmptyView(
                                        text: 'В этот день занятий нет',
                                        icon: Icons.self_improvement,
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.md,
                                      bottom: 80,
                                    ),
                                    itemCount: dayLessons.length,
                                    itemBuilder: (_, idx) =>
                                        LessonTile(lesson: dayLessons[idx]),
                                  ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekHeader extends ConsumerWidget {
  const _WeekHeader({
    required this.weekStart,
    required this.weekEnd,
    required this.weekTypeAsync,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final AsyncValue<WeekType> weekTypeAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final fmt = DateFormat('d MMM', 'ru_RU');

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: semantic.subtleDivider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _WeekNavButton(
                icon: Icons.chevron_left_rounded,
                onTap: () =>
                    ref.read(currentWeekStartProvider.notifier).prevWeek(),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context, ref),
                      child: Text(
                        '${fmt.format(weekStart)} — ${fmt.format(weekEnd)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    InkWell(
                      onTap: () => ref
                          .read(currentWeekStartProvider.notifier)
                          .thisWeek(),
                      borderRadius: AppRadius.mdBr,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: AppRadius.mdBr,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.today_rounded,
                              size: AppSizes.iconSm,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Сегодня',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _WeekNavButton(
                icon: Icons.calendar_today_rounded,
                onTap: () => _selectDate(context, ref),
              ),
              const SizedBox(width: AppSpacing.md),
              _WeekNavButton(
                icon: Icons.chevron_right_rounded,
                onTap: () =>
                    ref.read(currentWeekStartProvider.notifier).nextWeek(),
              ),
            ],
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
  const _WeekNavButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdBr,
      child: Container(
        width: AppSizes.weekNavButtonSize,
        height: AppSizes.weekNavButtonSize,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: AppRadius.mdBr,
          border: Border.all(color: semantic.cardBorder),
        ),
        child: Icon(
          icon,
          size: AppSizes.iconLg,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _WeekTypeSelector extends ConsumerWidget {
  const _WeekTypeSelector({required this.weekType});
  final WeekType weekType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final weekTypeOverride = ref.watch(weekTypeOverrideProvider);
    final isEvenWeek = weekTypeOverride ?? weekType.isEvenWeek;

    return Container(
      height: AppSizes.buttonHeightSm,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.mdBr,
        border: Border.all(color: semantic.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _WeekTypeButton(
              label: 'Верхняя',
              isSelected: isEvenWeek,
              onTap: () =>
                  ref.read(weekTypeOverrideProvider.notifier).state = true,
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: _WeekTypeButton(
              label: 'Нижняя',
              isSelected: !isEvenWeek,
              onTap: () =>
                  ref.read(weekTypeOverrideProvider.notifier).state = false,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekTypeButton extends StatelessWidget {
  const _WeekTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: AppRadius.smBr,
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
