// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentIdentity _$StudentIdentityFromJson(Map<String, dynamic> json) =>
    _StudentIdentity(
      actorId: json['actorId'] as String,
      groupName: json['groupName'] as String,
      departmentId: (json['departmentId'] as num).toInt(),
      fullName: json['fullName'] as String?,
    );

Map<String, dynamic> _$StudentIdentityToJson(_StudentIdentity instance) =>
    <String, dynamic>{
      'actorId': instance.actorId,
      'groupName': instance.groupName,
      'departmentId': instance.departmentId,
      'fullName': instance.fullName,
    };
