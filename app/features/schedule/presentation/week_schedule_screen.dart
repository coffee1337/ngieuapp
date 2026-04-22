class WeekScheduleScreen extends ConsumerWidget {
  const WeekScheduleScreen({super.key, required this.actorId});
  final String actorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(currentWeekStartProvider);
    final lessonsAsync = ref.watch(weekScheduleProvider(actorId, weekStart));

    return Scaffold(
      appBar: AppBar(title: const Text('Расписание')),
      body: DefaultTabController(
        length: 6,
        initialIndex: _todayIndex(weekStart),
        child: Column(children: [
          TabBar(tabs: _dayTabs(weekStart)),
          Expanded(
            child: lessonsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(error: e, onRetry: () =>
                  ref.invalidate(weekScheduleProvider(actorId, weekStart))),
              data: (lessons) => TabBarView(
                children: List.generate(6, (i) {
                  final day = weekStart.add(Duration(days: i));
                  final dayLessons = lessons
                      .where((l) => DateUtils.isSameDay(l.date, day))
                      .toList()
                    ..sort((a, b) => a.pairNumber.compareTo(b.pairNumber));
                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(
                      weekScheduleProvider(actorId, weekStart),
                    ),
                    child: dayLessons.isEmpty
                        ? const EmptyView(text: 'Занятий нет')
                        : ListView.separated(
                            itemCount: dayLessons.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (_, idx) => LessonTile(lesson: dayLessons[idx]),
                          ),
                  );
                }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}