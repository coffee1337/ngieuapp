import 'package:freezed_annotation/freezed_annotation.dart';
part 'actor.freezed.dart';
part 'actor.g.dart';

enum ActorType { studentGroup, teacher, department }

@freezed
class Actor with _$Actor {
  const factory Actor({
    required String id,           // GUID или числовой id — храним строкой
    required int departmentId,
    required String name,
    required ActorType type,
  }) = _Actor;

  factory Actor.fromStudentJson(Map<String, dynamic> json) => Actor(
        id: json['id'] as String,
        departmentId: json['departmentId'] as int,
        name: json['name'] as String,
        type: ActorType.studentGroup,
      );

  factory Actor.fromTeacherJson(Map<String, dynamic> json) => Actor(
        id: json['id'] as String,
        departmentId: json['departmentId'] as int,
        name: json['name'] as String,
        type: ActorType.teacher,
      );

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
}