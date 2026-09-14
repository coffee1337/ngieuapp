import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

class SmartGap {
  const SmartGap({
    required this.start,
    required this.end,
    required this.previousLesson,
    required this.nextLesson,
  });

  final DateTime start;
  final DateTime end;
  final Lesson previousLesson;
  final Lesson nextLesson;

  Duration get duration => end.difference(start);
  DateTime get date => DateTime(start.year, start.month, start.day);
}
