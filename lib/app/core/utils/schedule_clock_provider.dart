import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ngieuapp/app/features/schedule/data/schedule_providers.dart';

/// Refresh time-sensitive data at midnight and when returning from background.
final scheduleClockProvider = Provider<void>((ref) {
  Timer? timer;
  void refresh() {
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
      refresh();
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
