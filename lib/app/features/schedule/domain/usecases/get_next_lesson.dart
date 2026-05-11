import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class GetNextLesson {
  Lesson? call(List<Lesson> lessons, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    final future = lessons
        .where((l) => l.endTime.isAfter(ref) && !l.isEvent)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return future.isEmpty ? null : future.first;
  }
}
