import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_identity.freezed.dart';
part 'student_identity.g.dart';

@freezed
abstract class StudentIdentity with _$StudentIdentity {
  const factory StudentIdentity({
    required String actorId,
    required String groupName,
    required int departmentId,
    String? fullName,
  }) = _StudentIdentity;

  factory StudentIdentity.fromJson(Map<String, dynamic> json) =>
      _$StudentIdentityFromJson(json);
}

extension StudentIdentityDerived on StudentIdentity {
  int? get computedCourse {
    final match = RegExp(r'(?:Б|М|С)-(\d{2})').firstMatch(groupName);
    if (match == null) return null;
    final yy = int.parse(match.group(1)!);
    final enrolled = 2000 + yy;
    final now = DateTime.now();
    final academicYear = now.month >= 9 ? now.year : now.year - 1;
    return academicYear - enrolled + 1;
  }
}
