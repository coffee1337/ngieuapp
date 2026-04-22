import 'package:freezed_annotation/freezed_annotation.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

enum LessonType { lecture, practice, lab, exam, consultation, unknown }
enum WeekParity { any, odd, even }

@freezed
class Lesson with _$Lesson {
  const Lesson._();
  const factory Lesson({
    required String id,                  // стабильный id: хэш от (date+pair+group+room)
    required DateTime date,              // нормализованная дата (00:00)
    required int pairNumber,             // 1..8 (номер пары)
    required DateTime startTime,         // полный timestamp
    required DateTime endTime,
    required String subject,
    required LessonType type,
    required String classroom,           // "215", "Спортзал", "дист."
    required String building,            // корпус, если есть
    required List<String> teacherIds,
    required List<String> teacherNames,
    required List<String> groupIds,
    required List<String> groupNames,
    @Default(WeekParity.any) WeekParity parity,
    String? subgroup,                    // "1 подгруппа"
    String? note,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  /// Удобно для поиска свободных кабинетов — занят ли этот слот
  bool overlaps(DateTime from, DateTime to) =>
      startTime.isBefore(to) && endTime.isAfter(from);
}