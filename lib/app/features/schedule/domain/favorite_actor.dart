import 'package:flutter/foundation.dart';
import 'package:ngieuapp/app/features/schedule/domain/actor.dart';

@immutable
class FavoriteActor {
  const FavoriteActor({
    required this.id,
    required this.name,
    required this.type,
    required this.departmentId,
    required this.departmentName,
  });

  factory FavoriteActor.fromActor(
    Actor actor, {
    required String departmentName,
  }) {
    return FavoriteActor(
      id: actor.id,
      name: actor.name,
      type: actor.type,
      departmentId: actor.departmentId,
      departmentName: departmentName,
    );
  }

  factory FavoriteActor.fromJson(Map<String, dynamic> json) {
    final typeName = json['type']?.toString();
    final type = ActorType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => ActorType.studentGroup,
    );

    return FavoriteActor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: type,
      departmentId: _intOrZero(json['departmentId']),
      departmentName: json['departmentName']?.toString() ?? '',
    );
  }

  final String id;
  final String name;
  final ActorType type;
  final int departmentId;
  final String departmentName;

  bool get isSupported =>
      type == ActorType.studentGroup || type == ActorType.teacher;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'departmentId': departmentId,
    'departmentName': departmentName,
  };

  FavoriteActor copyWith({
    String? id,
    String? name,
    ActorType? type,
    int? departmentId,
    String? departmentName,
  }) {
    return FavoriteActor(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FavoriteActor &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            type == other.type &&
            departmentId == other.departmentId &&
            departmentName == other.departmentName;
  }

  @override
  int get hashCode => Object.hash(id, name, type, departmentId, departmentName);
}

int _intOrZero(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
