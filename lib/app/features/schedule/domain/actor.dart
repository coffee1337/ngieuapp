import 'package:freezed_annotation/freezed_annotation.dart';

part 'actor.freezed.dart';
part 'actor.g.dart';

enum ActorType { studentGroup, teacher, department }

@freezed
abstract class Actor with _$Actor {
  const factory Actor({
    required String id,
    required int departmentId,
    required String name,
    required ActorType type,
  }) = _Actor;

  factory Actor.fromStudentJson(Map<String, dynamic> json) =>
      Actor.fromApiJson(json, type: ActorType.studentGroup);

  factory Actor.fromTeacherJson(Map<String, dynamic> json) =>
      Actor.fromApiJson(json, type: ActorType.teacher);

  factory Actor.fromApiJson(
    Map<String, dynamic> json, {
    required ActorType type,
  }) {
    final rawDepartmentId = json['departmentId'];
    return Actor(
      id: json['id']?.toString() ?? '',
      departmentId: rawDepartmentId is int
          ? rawDepartmentId
          : int.tryParse(rawDepartmentId?.toString() ?? '') ?? 0,
      name: json['name']?.toString().trim() ?? '',
      type: type,
    );
  }

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
}
