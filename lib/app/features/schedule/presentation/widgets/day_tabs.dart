import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../theme/app_theme.dart';
import '../../../../theme/app_tokens.dart';

class DayTab {
  const DayTab({required this.date, required this.isToday});
  final DateTime date;
  final bool isToday;
}

class DayTabs extends StatelessWidget {
  const DayTabs({
    super.key,
    required this.weekStart,
    required this.tabController,
  });

  final DateTime weekStart;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>()!;
    final today = DateTime.now();
    final dayFmt = DateFormat('EEE', 'ru_RU');
    final dateFmt = DateFormat('d', 'ru_RU');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: semantic.subtleDivider, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: ListenableBuilder(
        listenable: tabController,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              final d = weekStart.add(Duration(days: i));
              final isToday =
                  d.year == today.year &&
                  d.month == today.month &&
                  d.day == today.day;
              final dayName = dayFmt.format(d);
              final dateStr = dateFmt.format(d);
              final isActive = tabController.index == i;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 5 ? AppSpacing.sm : 0),
                  child: _DayChip(
                    dayName: dayName,
                    dateStr: dateStr,
                    isToday: isToday,
                    isActive: isActive,
                    onTap: () {
                      if (tabController.index != i) {
                        tabController.animateTo(i);
                      }
                    },
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _DayChip extends StatefulWidget {
  const _DayChip({
    required this.dayName,
    required this.dateStr,
    required this.isToday,
    required this.isActive,
    required this.onTap,
  });

  final String dayName;
  final String dateStr;
  final bool isToday;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_DayChip> createState() => _DayChipState();
}

class _DayChipState extends State<_DayChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _animController.forward().then((_) => _animController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.extension<BrandColors>();

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: AppSizes.dayChipMinHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? theme.colorScheme.primary
                : Colors.transparent,
            borderRadius: AppRadius.mdBr,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getDayName(widget.dayName),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: widget.isActive
                      ? Colors.white.withValues(alpha: 0.9)
                      : theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.3,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                widget.dateStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: widget.isActive
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              if (widget.isToday)
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xxs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isActive
                        ? Colors.white.withValues(alpha: 0.25)
                        : (brand?.orange ?? const Color(0xFFFFA300)),
                    borderRadius: AppRadius.xsBr,
                  ),
                  child: const Text(
                    'сегодня',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayName(String fullName) {
    if (fullName.length <= 3) return fullName;
    return fullName.substring(0, 3);
  }
}
