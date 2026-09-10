import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class DayTab {
  const DayTab({required this.date, required this.isToday});
  final DateTime date;
  final bool isToday;
}

class DayTabs extends StatefulWidget {
  const DayTabs({
    required this.weekStart,
    required this.tabController,
    super.key,
  });
  final DateTime weekStart;
  final TabController tabController;

  @override
  State<DayTabs> createState() => _DayTabsState();
}

class _DayTabsState extends State<DayTabs> {
  static final _shortDayFormat = DateFormat('EEE', 'ru_RU');
  static final _semanticDateFormat = DateFormat('EEEE, d MMMM', 'ru_RU');

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tabController.index;
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(covariant DayTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabController == widget.tabController) return;
    oldWidget.tabController.removeListener(_handleTabChange);
    _selectedIndex = widget.tabController.index;
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    final nextIndex = widget.tabController.index;
    if (nextIndex == _selectedIndex || !mounted) return;
    setState(() => _selectedIndex = nextIndex);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = MediaQuery.textScalerOf(context).scale(32) + 20;
          final width = ((constraints.maxWidth - 40) / 6)
              .clamp(minWidth, double.infinity)
              .toDouble();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(6, (index) {
                final date = widget.weekStart.add(Duration(days: index));
                final selected = _selectedIndex == index;
                final today = DateUtils.isSameDay(date, now);
                final foreground = selected
                    ? scheme.onPrimary
                    : scheme.onSurface;
                return Padding(
                  padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                  child: Semantics(
                    selected: selected,
                    label:
                        '${_semanticDateFormat.format(date)}${today ? ', сегодня' : ''}',
                    child: SizedBox(
                      width: width,
                      child: Material(
                        color: selected
                            ? scheme.primary
                            : scheme.surfaceContainer,
                        borderRadius: AppRadius.xlBr,
                        child: InkWell(
                          borderRadius: AppRadius.xlBr,
                          onTap: () => widget.tabController.animateTo(
                            index,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: AppSizes.dayChipMinHeight,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.xlBr,
                              border: Border.all(
                                color: today && !selected
                                    ? scheme.primary
                                    : Colors.transparent,
                              ),
                            ),
                            child: ExcludeSemantics(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _shortDayFormat.format(date),
                                    style: textTheme.labelMedium?.copyWith(
                                      color: selected
                                          ? foreground
                                          : scheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${date.day}',
                                    style: textTheme.titleLarge?.copyWith(
                                      color: foreground,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: today
                                          ? foreground
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
