/// Абстракция для будущего расширения: оценки студента.
/// Реализация появится, когда у вуза будет API.
abstract interface class AcademicRepository {
  Future<List<Grade>> getGrades(String actorId);
  Future<double?> getGpa(String actorId);
}

/// Оценка по предмету.
class Grade {
  const Grade({
    required this.subject,
    required this.semester,
    required this.kind,
    required this.status,
    this.score,
    this.takenAt,
    this.teacherName,
  });

  final String subject;
  final String semester; // "1 семестр 2024/2025"
  final GradeKind kind;
  final GradeStatus status;
  final int? score; // 2..5 или null (зачёт)
  final DateTime? takenAt;
  final String? teacherName;
}

enum GradeKind { exam, credit, differentialCredit, coursework }

enum GradeStatus { passed, failed, pending }
