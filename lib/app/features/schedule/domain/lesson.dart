import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

enum LessonType { lecture, practice, lab, exam, consultation, event, unknown }

enum WeekParity { any, odd, even }

@freezed
abstract class Lesson with _$Lesson {
  const Lesson._();

  const factory Lesson({
    required String id,
    required DateTime date,
    required int pairNumber,
    required DateTime startTime,
    required DateTime endTime,
    required String subject,
    required LessonType type,
    required String classroom,
    required String building,
    required List<String> teacherIds,
    required List<String> teacherNames,
    required List<String> groupIds,
    required List<String> groupNames,
    @Default(WeekParity.any) WeekParity parity,
    @Default(false) bool isChange,
    @Default(false) bool isEvent,
    String? subgroup,
    String? note,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  bool overlaps(DateTime from, DateTime to) =>
      startTime.isBefore(to) && endTime.isAfter(from);
}
