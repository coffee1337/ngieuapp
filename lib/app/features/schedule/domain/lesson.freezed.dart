// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lesson {

 String get id; DateTime get date; int get pairNumber; DateTime get startTime; DateTime get endTime; String get subject; LessonType get type; String get classroom; String get building; List<String> get teacherIds; List<String> get teacherNames; List<String> get groupIds; List<String> get groupNames; WeekParity get parity; bool get isChange; bool get isEvent; String? get subgroup; String? get note;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.pairNumber, pairNumber) || other.pairNumber == pairNumber)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.type, type) || other.type == type)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.building, building) || other.building == building)&&const DeepCollectionEquality().equals(other.teacherIds, teacherIds)&&const DeepCollectionEquality().equals(other.teacherNames, teacherNames)&&const DeepCollectionEquality().equals(other.groupIds, groupIds)&&const DeepCollectionEquality().equals(other.groupNames, groupNames)&&(identical(other.parity, parity) || other.parity == parity)&&(identical(other.isChange, isChange) || other.isChange == isChange)&&(identical(other.isEvent, isEvent) || other.isEvent == isEvent)&&(identical(other.subgroup, subgroup) || other.subgroup == subgroup)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,pairNumber,startTime,endTime,subject,type,classroom,building,const DeepCollectionEquality().hash(teacherIds),const DeepCollectionEquality().hash(teacherNames),const DeepCollectionEquality().hash(groupIds),const DeepCollectionEquality().hash(groupNames),parity,isChange,isEvent,subgroup,note);

@override
String toString() {
  return 'Lesson(id: $id, date: $date, pairNumber: $pairNumber, startTime: $startTime, endTime: $endTime, subject: $subject, type: $type, classroom: $classroom, building: $building, teacherIds: $teacherIds, teacherNames: $teacherNames, groupIds: $groupIds, groupNames: $groupNames, parity: $parity, isChange: $isChange, isEvent: $isEvent, subgroup: $subgroup, note: $note)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, int pairNumber, DateTime startTime, DateTime endTime, String subject, LessonType type, String classroom, String building, List<String> teacherIds, List<String> teacherNames, List<String> groupIds, List<String> groupNames, WeekParity parity, bool isChange, bool isEvent, String? subgroup, String? note
});




}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? pairNumber = null,Object? startTime = null,Object? endTime = null,Object? subject = null,Object? type = null,Object? classroom = null,Object? building = null,Object? teacherIds = null,Object? teacherNames = null,Object? groupIds = null,Object? groupNames = null,Object? parity = null,Object? isChange = null,Object? isEvent = null,Object? subgroup = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,pairNumber: null == pairNumber ? _self.pairNumber : pairNumber // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LessonType,classroom: null == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,teacherIds: null == teacherIds ? _self.teacherIds : teacherIds // ignore: cast_nullable_to_non_nullable
as List<String>,teacherNames: null == teacherNames ? _self.teacherNames : teacherNames // ignore: cast_nullable_to_non_nullable
as List<String>,groupIds: null == groupIds ? _self.groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,groupNames: null == groupNames ? _self.groupNames : groupNames // ignore: cast_nullable_to_non_nullable
as List<String>,parity: null == parity ? _self.parity : parity // ignore: cast_nullable_to_non_nullable
as WeekParity,isChange: null == isChange ? _self.isChange : isChange // ignore: cast_nullable_to_non_nullable
as bool,isEvent: null == isEvent ? _self.isEvent : isEvent // ignore: cast_nullable_to_non_nullable
as bool,subgroup: freezed == subgroup ? _self.subgroup : subgroup // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  int pairNumber,  DateTime startTime,  DateTime endTime,  String subject,  LessonType type,  String classroom,  String building,  List<String> teacherIds,  List<String> teacherNames,  List<String> groupIds,  List<String> groupNames,  WeekParity parity,  bool isChange,  bool isEvent,  String? subgroup,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.date,_that.pairNumber,_that.startTime,_that.endTime,_that.subject,_that.type,_that.classroom,_that.building,_that.teacherIds,_that.teacherNames,_that.groupIds,_that.groupNames,_that.parity,_that.isChange,_that.isEvent,_that.subgroup,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  int pairNumber,  DateTime startTime,  DateTime endTime,  String subject,  LessonType type,  String classroom,  String building,  List<String> teacherIds,  List<String> teacherNames,  List<String> groupIds,  List<String> groupNames,  WeekParity parity,  bool isChange,  bool isEvent,  String? subgroup,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.date,_that.pairNumber,_that.startTime,_that.endTime,_that.subject,_that.type,_that.classroom,_that.building,_that.teacherIds,_that.teacherNames,_that.groupIds,_that.groupNames,_that.parity,_that.isChange,_that.isEvent,_that.subgroup,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  int pairNumber,  DateTime startTime,  DateTime endTime,  String subject,  LessonType type,  String classroom,  String building,  List<String> teacherIds,  List<String> teacherNames,  List<String> groupIds,  List<String> groupNames,  WeekParity parity,  bool isChange,  bool isEvent,  String? subgroup,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.date,_that.pairNumber,_that.startTime,_that.endTime,_that.subject,_that.type,_that.classroom,_that.building,_that.teacherIds,_that.teacherNames,_that.groupIds,_that.groupNames,_that.parity,_that.isChange,_that.isEvent,_that.subgroup,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson extends Lesson {
  const _Lesson({required this.id, required this.date, required this.pairNumber, required this.startTime, required this.endTime, required this.subject, required this.type, required this.classroom, required this.building, required final  List<String> teacherIds, required final  List<String> teacherNames, required final  List<String> groupIds, required final  List<String> groupNames, this.parity = WeekParity.any, this.isChange = false, this.isEvent = false, this.subgroup, this.note}): _teacherIds = teacherIds,_teacherNames = teacherNames,_groupIds = groupIds,_groupNames = groupNames,super._();
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  int pairNumber;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  String subject;
@override final  LessonType type;
@override final  String classroom;
@override final  String building;
 final  List<String> _teacherIds;
@override List<String> get teacherIds {
  if (_teacherIds is EqualUnmodifiableListView) return _teacherIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teacherIds);
}

 final  List<String> _teacherNames;
@override List<String> get teacherNames {
  if (_teacherNames is EqualUnmodifiableListView) return _teacherNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teacherNames);
}

 final  List<String> _groupIds;
@override List<String> get groupIds {
  if (_groupIds is EqualUnmodifiableListView) return _groupIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupIds);
}

 final  List<String> _groupNames;
@override List<String> get groupNames {
  if (_groupNames is EqualUnmodifiableListView) return _groupNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupNames);
}

@override@JsonKey() final  WeekParity parity;
@override@JsonKey() final  bool isChange;
@override@JsonKey() final  bool isEvent;
@override final  String? subgroup;
@override final  String? note;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.pairNumber, pairNumber) || other.pairNumber == pairNumber)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.type, type) || other.type == type)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.building, building) || other.building == building)&&const DeepCollectionEquality().equals(other._teacherIds, _teacherIds)&&const DeepCollectionEquality().equals(other._teacherNames, _teacherNames)&&const DeepCollectionEquality().equals(other._groupIds, _groupIds)&&const DeepCollectionEquality().equals(other._groupNames, _groupNames)&&(identical(other.parity, parity) || other.parity == parity)&&(identical(other.isChange, isChange) || other.isChange == isChange)&&(identical(other.isEvent, isEvent) || other.isEvent == isEvent)&&(identical(other.subgroup, subgroup) || other.subgroup == subgroup)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,pairNumber,startTime,endTime,subject,type,classroom,building,const DeepCollectionEquality().hash(_teacherIds),const DeepCollectionEquality().hash(_teacherNames),const DeepCollectionEquality().hash(_groupIds),const DeepCollectionEquality().hash(_groupNames),parity,isChange,isEvent,subgroup,note);

@override
String toString() {
  return 'Lesson(id: $id, date: $date, pairNumber: $pairNumber, startTime: $startTime, endTime: $endTime, subject: $subject, type: $type, classroom: $classroom, building: $building, teacherIds: $teacherIds, teacherNames: $teacherNames, groupIds: $groupIds, groupNames: $groupNames, parity: $parity, isChange: $isChange, isEvent: $isEvent, subgroup: $subgroup, note: $note)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, int pairNumber, DateTime startTime, DateTime endTime, String subject, LessonType type, String classroom, String building, List<String> teacherIds, List<String> teacherNames, List<String> groupIds, List<String> groupNames, WeekParity parity, bool isChange, bool isEvent, String? subgroup, String? note
});




}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? pairNumber = null,Object? startTime = null,Object? endTime = null,Object? subject = null,Object? type = null,Object? classroom = null,Object? building = null,Object? teacherIds = null,Object? teacherNames = null,Object? groupIds = null,Object? groupNames = null,Object? parity = null,Object? isChange = null,Object? isEvent = null,Object? subgroup = freezed,Object? note = freezed,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,pairNumber: null == pairNumber ? _self.pairNumber : pairNumber // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LessonType,classroom: null == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,teacherIds: null == teacherIds ? _self._teacherIds : teacherIds // ignore: cast_nullable_to_non_nullable
as List<String>,teacherNames: null == teacherNames ? _self._teacherNames : teacherNames // ignore: cast_nullable_to_non_nullable
as List<String>,groupIds: null == groupIds ? _self._groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,groupNames: null == groupNames ? _self._groupNames : groupNames // ignore: cast_nullable_to_non_nullable
as List<String>,parity: null == parity ? _self.parity : parity // ignore: cast_nullable_to_non_nullable
as WeekParity,isChange: null == isChange ? _self.isChange : isChange // ignore: cast_nullable_to_non_nullable
as bool,isEvent: null == isEvent ? _self.isEvent : isEvent // ignore: cast_nullable_to_non_nullable
as bool,subgroup: freezed == subgroup ? _self.subgroup : subgroup // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
