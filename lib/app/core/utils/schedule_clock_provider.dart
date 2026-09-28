import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';

/// Refresh time-sensitive data at midnight and when returning from background.
final scheduleClockProvider = Provider<void>((ref) {
  Timer? timer;
  DateTime? lastRefresh;

  void refresh() {
    // Дебаунс: возврат из фона дважды за секунду не должен запускать
    // 5 цепочек рефетчей. Полночь идёт мимо дебаунса отдельным таймером.
    final now = DateTime.now();
    if (lastRefresh != null &&
        now.difference(lastRefresh!) < const Duration(seconds: 5)) {
      return;
    }
    lastRefresh = now;
    ref
      ..invalidate(currentWeekTypeProvider)
      ..invalidate(weekTypeProvider)
      ..invalidate(rawWeekScheduleProvider)
      ..invalidate(freeRoomsProvider)
      ..invalidate(scheduleSearchResultsProvider);
  }

  void scheduleMidnight() {
    timer?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    timer = Timer(nextDay.difference(now), () {
      lastRefresh = null;
      refresh();
      lastRefresh = DateTime.now();
      scheduleMidnight();
    });
  }

  final listener = AppLifecycleListener(
    onResume: () {
      refresh();
      scheduleMidnight();
    },
  );
  scheduleMidnight();
  ref.onDispose(() {
    timer?.cancel();
    listener.dispose();
  });
});
