import 'package:ngieuapp/app/features/schedule/domain/lesson.dart';

Lesson makeLesson({
  String id = 'test-id',
  DateTime? date,
  int pairNumber = 1,
  DateTime? startTime,
  DateTime? endTime,
  String subject = 'Математика',
  LessonType type = LessonType.lecture,
  String classroom = '121',
  String building = '',
  List<String> teacherNames = const ['Иванов И.И.'],
  List<String> groupNames = const ['ИТ-21'],
  WeekParity parity = WeekParity.any,
  bool isChange = false,
  bool isEvent = false,
  String? note,
}) {
  final d = date ?? DateTime(2025, 3, 10);
  return Lesson(
    id: id,
    date: d,
    pairNumber: pairNumber,
    startTime: startTime ?? DateTime(d.year, d.month, d.day, 8, 30),
    endTime: endTime ?? DateTime(d.year, d.month, d.day, 10, 0),
    subject: subject,
    type: type,
    classroom: classroom,
    building: building,
    teacherIds: const [],
    teacherNames: teacherNames,
    groupIds: const [],
    groupNames: groupNames,
    parity: parity,
    isChange: isChange,
    isEvent: isEvent,
    note: note,
  );
}
