import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class FilterWeekSchedule {
  List<Lesson> call({
    required List<Lesson> lessons,
    required DateTime weekStart,
    required bool isEvenWeek,
    required bool showChanges,
  }) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final thisWeek = lessons
        .where(
          (l) => !l.date.isBefore(weekStart) && l.date.isBefore(weekEnd),
        )
        .toList();

    final byCell = <String, List<Lesson>>{};
    for (final l in thisWeek) {
      final k = '${l.date.toIso8601String()}|${l.pairNumber}';
      byCell.putIfAbsent(k, () => []).add(l);
    }

    final result = <Lesson>[];
    for (final cell in byCell.values) {
      final changes = cell.where((l) => l.isChange).toList();
      final regulars = cell.where((l) => !l.isChange).toList();

      if (showChanges && changes.isNotEmpty) {
        final visible = changes
            .where(
              (l) => !(l.isEvent &&
                  l.subject.toLowerCase() == 'мероприятие' &&
                  l.classroom.isEmpty),
            )
            .toList();
        if (visible.isEmpty) {
          result.add(
            changes.first.copyWith(
              subject: 'Занятие отменено',
              isEvent: true,
            ),
          );
        } else {
          result.addAll(visible);
        }
      } else {
        for (final l in regulars) {
          if (_parityMatches(l, isEvenWeek)) {
            result.add(l);
          }
        }
      }
    }
    return result;
  }

  static bool _parityMatches(Lesson l, bool isEvenWeek) {
    if (l.parity == WeekParity.any) return true;
    return (l.parity == WeekParity.even) == isEvenWeek;
  }
}
