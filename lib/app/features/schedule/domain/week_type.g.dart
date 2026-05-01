// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeekType _$WeekTypeFromJson(Map<String, dynamic> json) => _WeekType(
  date: DateTime.parse(json['date'] as String),
  isUpperWeek: json['isUpperWeek'] as bool,
);

Map<String, dynamic> _$WeekTypeToJson(_WeekType instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'isUpperWeek': instance.isUpperWeek,
};
