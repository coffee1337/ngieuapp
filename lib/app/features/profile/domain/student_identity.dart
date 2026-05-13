import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';

part 'student_identity.freezed.dart';

@freezed
abstract class StudentIdentity with _$StudentIdentity {
  const factory StudentIdentity({
    required String actorId,
    required String displayName,
    required ActorType actorType,
    required String departmentName,
    String? groupName,
    int? departmentId,
    String? fullName,
  }) = _StudentIdentity;

  factory StudentIdentity.fromJson(Map<String, dynamic> json) {
    final migrated = Map<String, dynamic>.from(json);
    migrated['displayName'] ??= migrated['groupName'] ?? '';
    migrated['actorType'] ??= ActorType.studentGroup.name;
    migrated['departmentName'] ??= migrated['departmentId'] == null
        ? 'Без института'
        : 'Кафедра №${migrated['departmentId']}';
    final actorTypeValue = migrated['actorType']?.toString();
    return StudentIdentity(
      actorId: migrated['actorId']?.toString() ?? '',
      displayName: migrated['displayName']?.toString() ?? '',
      actorType: ActorType.values.firstWhere(
        (type) => type.name == actorTypeValue,
        orElse: () => ActorType.studentGroup,
      ),
      departmentName: migrated['departmentName']?.toString() ?? 'Без института',
      groupName: migrated['groupName']?.toString(),
      departmentId: _intOrNull(migrated['departmentId']),
      fullName: migrated['fullName']?.toString(),
    );
  }
}

extension StudentIdentityDerived on StudentIdentity {
  bool get isStudentGroup => actorType == ActorType.studentGroup;

  int? get computedCourse {
    if (!isStudentGroup) return null;
    final match = RegExp(
      r'(?:Б|М|С)-(\d{2})',
    ).firstMatch(groupName ?? displayName);
    if (match == null) return null;
    final yy = int.parse(match.group(1)!);
    final enrolled = 2000 + yy;
    final now = DateTime.now();
    final academicYear = now.month >= 9 ? now.year : now.year - 1;
    return academicYear - enrolled + 1;
  }

  Map<String, dynamic> toJson() => {
    'actorId': actorId,
    'displayName': displayName,
    'actorType': actorType.name,
    'departmentName': departmentName,
    'groupName': groupName,
    'departmentId': departmentId,
    'fullName': fullName,
  };
}

int? _intOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
