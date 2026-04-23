// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  pairNumber: (json['pairNumber'] as num).toInt(),
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  subject: json['subject'] as String,
  type: $enumDecode(_$LessonTypeEnumMap, json['type']),
  classroom: json['classroom'] as String,
  building: json['building'] as String,
  teacherIds: (json['teacherIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  teacherNames: (json['teacherNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  groupIds: (json['groupIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  groupNames: (json['groupNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  parity:
      $enumDecodeNullable(_$WeekParityEnumMap, json['parity']) ??
      WeekParity.any,
  isChange: json['isChange'] as bool? ?? false,
  isEvent: json['isEvent'] as bool? ?? false,
  subgroup: json['subgroup'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'pairNumber': instance.pairNumber,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'subject': instance.subject,
  'type': _$LessonTypeEnumMap[instance.type]!,
  'classroom': instance.classroom,
  'building': instance.building,
  'teacherIds': instance.teacherIds,
  'teacherNames': instance.teacherNames,
  'groupIds': instance.groupIds,
  'groupNames': instance.groupNames,
  'parity': _$WeekParityEnumMap[instance.parity]!,
  'isChange': instance.isChange,
  'isEvent': instance.isEvent,
  'subgroup': instance.subgroup,
  'note': instance.note,
};

const _$LessonTypeEnumMap = {
  LessonType.lecture: 'lecture',
  LessonType.practice: 'practice',
  LessonType.lab: 'lab',
  LessonType.exam: 'exam',
  LessonType.consultation: 'consultation',
  LessonType.event: 'event',
  LessonType.unknown: 'unknown',
};

const _$WeekParityEnumMap = {
  WeekParity.any: 'any',
  WeekParity.odd: 'odd',
  WeekParity.even: 'even',
};
