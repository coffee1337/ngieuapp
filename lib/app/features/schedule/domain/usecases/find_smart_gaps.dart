import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';
import 'package:ngieuapp/app/features/schedule/domain/smart_gap.dart';

class FindSmartGaps {
  const FindSmartGaps();

  List<SmartGap> call({
    required List<Lesson> lessons,
    Duration minimumDuration = const Duration(minutes: 25),
  }) {
    if (lessons.length < 2) return const [];
    final byDay = <DateTime, List<Lesson>>{};
    for (final lesson in lessons) {
      final day = DateTime(
        lesson.date.year,
        lesson.date.month,
        lesson.date.day,
      );
      byDay.putIfAbsent(day, () => []).add(lesson);
    }

    final gaps = <SmartGap>[];
    final days = byDay.keys.toList()..sort();
    for (final day in days) {
      final dayLessons = byDay[day]!
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      var busyUntil = dayLessons.first.endTime;
      var previous = dayLessons.first;
      for (final next in dayLessons.skip(1)) {
        final gap = next.startTime.difference(busyUntil);
        if (gap >= minimumDuration) {
          gaps.add(
            SmartGap(
              start: busyUntil,
              end: next.startTime,
              previousLesson: previous,
              nextLesson: next,
            ),
          );
        }
        if (next.endTime.isAfter(busyUntil)) {
          busyUntil = next.endTime;
          previous = next;
        }
      }
    }
    return gaps;
  }
}
