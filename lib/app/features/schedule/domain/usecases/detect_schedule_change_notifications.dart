import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class ScheduleChangeNotification {
  const ScheduleChangeNotification({
    required this.lesson,
    required this.fingerprint,
  });

  final Lesson lesson;
  final String fingerprint;
}

class DetectScheduleChangeNotifications {
  const DetectScheduleChangeNotifications();

  List<ScheduleChangeNotification> call({
    required String actorId,
    required List<Lesson> oldLessons,
    required List<Lesson> freshLessons,
    required DateTime now,
    int lookAheadDays = 2,
    Set<String> sentFingerprints = const {},
  }) {
    final oldFingerprints = oldLessons
        .where((lesson) => lesson.isChange)
        .map((lesson) => fingerprintFor(actorId, lesson))
        .toSet();

    return freshLessons
        .where((lesson) => lesson.isChange)
        .where((lesson) => _isWithinLookAhead(lesson.date, now, lookAheadDays))
        .map(
          (lesson) => ScheduleChangeNotification(
            lesson: lesson,
            fingerprint: fingerprintFor(actorId, lesson),
          ),
        )
        .where(
          (candidate) =>
              !oldFingerprints.contains(candidate.fingerprint) &&
              !sentFingerprints.contains(candidate.fingerprint),
        )
        .toList();
  }

  static String fingerprintFor(String actorId, Lesson lesson) {
    final key = [
      actorId,
      _dateKey(lesson.date),
      lesson.pairNumber,
      _timeKey(lesson.startTime),
      _timeKey(lesson.endTime),
      lesson.subject,
      lesson.classroom,
      lesson.building,
      lesson.teacherNames.join(','),
      lesson.groupNames.join(','),
      lesson.isEvent,
      lesson.note ?? '',
    ].join('|');
    return _fnv1a(key).toRadixString(36);
  }

  static bool _isWithinLookAhead(
    DateTime date,
    DateTime now,
    int lookAheadDays,
  ) {
    final day = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final end = today.add(Duration(days: lookAheadDays));
    return !day.isBefore(today) && day.isBefore(end);
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static String _timeKey(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  static int _fnv1a(String value) {
    var hash = 0x811c9dc5;
    for (var i = 0; i < value.length; i++) {
      hash ^= value.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }
}
