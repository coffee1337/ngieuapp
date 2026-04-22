import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/app_gradient_bar.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/schedule_providers.dart';
import 'widgets/day_tabs.dart';
import 'widgets/lesson_tile.dart';

class WeekScheduleScreen extends ConsumerWidget {
  const WeekScheduleScreen({super.key, required this.actorId});
  final String actorId;

  int _todayIndex(DateTime weekStart) {
    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(weekStart)
        .inDays;
    if (diff < 0) return 0;
    if (diff > 5) return 5;
    return diff;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final lessonsAsync = ref.watch(weekScheduleProvider(actorId, weekStart));
    final weekEnd = weekStart.add(const Duration(days: 5));
    final fmt = DateFormat('d MMM', 'ru_RU');

    return Scaffold(
      appBar: AppBar(
        title: Text('${fmt.format(weekStart)} — ${fmt.format(weekEnd)}'),
        actions: [
          IconButton(
            tooltip: 'Предыдущая неделя',
            icon: const Icon(Icons.chevron_left),
            onPressed: () => ref.read(currentWeekStartProvider.notifier).prevWeek(),
          ),
          IconButton(
            tooltip: 'Сегодня',
            icon: const Icon(Icons.today),
            onPressed: () => ref.read(currentWeekStartProvider.notifier).thisWeek(),
          ),
          IconButton(
            tooltip: 'Следующая неделя',
            icon: const Icon(Icons.chevron_right),
            onPressed: () => ref.read(currentWeekStartProvider.notifier).nextWeek(),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: AppGradientBar(),
        ),
      ),
      body: DefaultTabController(
        length: 6,
        initialIndex: _todayIndex(weekStart),
        child: Column(
          children: [
            DayTabs(weekStart: weekStart),
            Expanded(
              child: lessonsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(
                    weekScheduleProvider(actorId, weekStart),
                  ),
                ),
                data: (lessons) => TabBarView(
                  children: List.generate(6, (i) {
                    final day = weekStart.add(Duration(days: i));
                    final dayLessons = lessons
                        .where((l) =>
                            l.date.year == day.year &&
                            l.date.month == day.month &&
                            l.date.day == day.day)
                        .toList()
                      ..sort((a, b) => a.pairNumber.compareTo(b.pairNumber));
                    return RefreshIndicator(
                      onRefresh: () async => ref.invalidate(
                        weekScheduleProvider(actorId, weekStart),
                      ),
                      child: dayLessons.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 80),
                                EmptyView(
                                  text: 'В этот день занятий нет',
                                  icon: Icons.self_improvement,
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
    );
  }
}