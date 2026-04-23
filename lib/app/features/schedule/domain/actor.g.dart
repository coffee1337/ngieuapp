// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Actor _$ActorFromJson(Map<String, dynamic> json) => _Actor(
  id: json['id'] as String,
  departmentId: (json['departmentId'] as num).toInt(),
  name: json['name'] as String,
  type: $enumDecode(_$ActorTypeEnumMap, json['type']),
);

Map<String, dynamic> _$ActorToJson(_Actor instance) => <String, dynamic>{
  'id': instance.id,
  'departmentId': instance.departmentId,
  'name': instance.name,
  'type': _$ActorTypeEnumMap[instance.type]!,
};

const _$ActorTypeEnumMap = {
  ActorType.studentGroup: 'studentGroup',
  ActorType.teacher: 'teacher',
  ActorType.department: 'department',
};
