abstract interface class AcademicRepository {
  Future<List<Semester>> getSemesters(String actorId);
  Future<List<Grade>> getGradesForSemester(String actorId, String semesterId);
  Future<GradeSummary> getSummary(String actorId);  // GPA, долги, пересдачи
}

@freezed
class Grade with _$Grade {
  const factory Grade({
    required String subject,
    required String semesterId,
    required GradeKind kind,           // exam, credit, coursework
    required int? score,               // 2..5 или null (зачёт)
    required GradeStatus status,       // passed, failed, pending
    DateTime? takenAt,
    String? teacherName,
  }) = _Grade;
  factory Grade.fromJson(Map<String, dynamic> j) => _$GradeFromJson(j);
}