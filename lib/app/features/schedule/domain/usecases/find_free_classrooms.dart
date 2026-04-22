import '../lesson.dart';
import '../classroom_availability.dart';
import '../schedule_repository.dart';

class FindFreeClassrooms {
  FindFreeClassrooms(this._repo);
  final ScheduleRepository _repo;

  // Рабочий день универа
  static const _dayStart = TimeOfDay(hour: 8, minute: 0);
  static const _dayEnd = TimeOfDay(hour: 20, minute: 0);
  static const _minFreeWindow = Duration(minutes: 15);

  // Мусор, не являющийся физической аудиторией
  static final _excluded = RegExp(
    r'^(дист\.?|онлайн|удал[её]нно|по\s+плану|н/д|\-)\s*$',
    caseSensitive: false,
  );

  Future<List<ClassroomAvailability>> call({
    required DateTime date,
    required TimeOfDay from,
    required TimeOfDay to,
    Duration minDuration = const Duration(minutes: 45),
    String? buildingFilter,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final fromDt = _combine(day, from);
    final toDt = _combine(day, to);

    // 1. Все занятия за день
    var lessons = await _repo.getAllLessonsForDate(day);

    // 2. Фильтрация мусорных аудиторий
    lessons = lessons.where((l) =>
        l.classroom.isNotEmpty && !_excluded.hasMatch(l.classroom)
    ).toList();

    if (buildingFilter != null) {
      lessons = lessons.where((l) => l.building == buildingFilter).toList();
    }

    // 3. Группировка по кабинету
    final byRoom = <_RoomKey, List<_Interval>>{};
    for (final l in lessons) {
      final key = _RoomKey(l.classroom, l.building);
      byRoom.putIfAbsent(key, () => []).add(_Interval(l.startTime, l.endTime));
    }

    // 4. Для каждой комнаты — merge и поиск свободных окон
    final result = <ClassroomAvailability>[];
    final dayStartDt = _combine(day, _dayStart);
    final dayEndDt = _combine(day, _dayEnd);

    for (final entry in byRoom.entries) {
      final merged = _mergeIntervals(entry.value);
      final freeWindows = _gaps(merged, dayStartDt, dayEndDt);

      for (final w in freeWindows) {
        // Пересечение с запрошенным интервалом
        final s = w.start.isAfter(fromDt) ? w.start : fromDt;
        final e = w.end.isBefore(toDt) ? w.end : toDt;
        if (e.isAfter(s) && e.difference(s) >= minDuration) {
          result.add(ClassroomAvailability(
            classroom: entry.key.room,
            building: entry.key.building,
            freeFrom: s,
            freeUntil: e,
            freeDuration: e.difference(s),
          ));
        }
      }
    }

    // 5. Сортируем: сначала дольше свободны
    result.sort((a, b) => b.freeDuration.compareTo(a.freeDuration));
    return result;
  }

  List<_Interval> _mergeIntervals(List<_Interval> input) {
    if (input.isEmpty) return input;
    input.sort((a, b) => a.start.compareTo(b.start));
    final out = <_Interval>[input.first];
    for (var i = 1; i < input.length; i++) {
      final last = out.last;
      final cur = input[i];
      if (!cur.start.isAfter(last.end)) {
        out[out.length - 1] = _Interval(
          last.start,
          cur.end.isAfter(last.end) ? cur.end : last.end,
        );
      } else {
        out.add(cur);
      }
    }
    return out;
  }

  List<_Interval> _gaps(List<_Interval> busy, DateTime dayStart, DateTime dayEnd) {
    final gaps = <_Interval>[];
    var cursor = dayStart;
    for (final b in busy) {
      if (b.start.isAfter(cursor) &&
          b.start.difference(cursor) >= _minFreeWindow) {
        gaps.add(_Interval(cursor, b.start));
      }
      if (b.end.isAfter(cursor)) cursor = b.end;
    }
    if (dayEnd.isAfter(cursor) &&
        dayEnd.difference(cursor) >= _minFreeWindow) {
      gaps.add(_Interval(cursor, dayEnd));
    }
    return gaps;
  }

  DateTime _combine(DateTime d, TimeOfDay t) =>
      DateTime(d.year, d.month, d.day, t.hour, t.minute);
}

class _Interval {
  _Interval(this.start, this.end);
  final DateTime start;
  final DateTime end;
}

class _RoomKey {
  _RoomKey(this.room, this.building);
  final String room;
  final String building;
  @override
  bool operator ==(Object o) =>
      o is _RoomKey && o.room == room && o.building == building;
  @override
  int get hashCode => Object.hash(room, building);
}