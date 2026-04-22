import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayTab {
  const DayTab({required this.date, required this.isToday});
  final DateTime date;
  final bool isToday;
}

class DayTabs extends StatelessWidget {
  const DayTabs({super.key, required this.weekStart});

  final DateTime weekStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final dayFmt = DateFormat('EEE', 'ru_RU');
    final dateFmt = DateFormat('d', 'ru_RU');

    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: List.generate(6, (i) {
        final d = weekStart.add(Duration(days: i));
        final isToday = d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
        return Tab(
          height: 54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayFmt.format(d).toUpperCase(),
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                dateFmt.format(d),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isToday ? theme.colorScheme.primary : null,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}