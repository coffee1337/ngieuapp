// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassroomAvailability {

 String get classroom; String get building; DateTime get freeFrom; DateTime get freeUntil; Duration get freeDuration;
/// Create a copy of ClassroomAvailability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomAvailabilityCopyWith<ClassroomAvailability> get copyWith => _$ClassroomAvailabilityCopyWithImpl<ClassroomAvailability>(this as ClassroomAvailability, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassroomAvailability&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.building, building) || other.building == building)&&(identical(other.freeFrom, freeFrom) || other.freeFrom == freeFrom)&&(identical(other.freeUntil, freeUntil) || other.freeUntil == freeUntil)&&(identical(other.freeDuration, freeDuration) || other.freeDuration == freeDuration));
}


@override
int get hashCode => Object.hash(runtimeType,classroom,building,freeFrom,freeUntil,freeDuration);

@override
String toString() {
  return 'ClassroomAvailability(classroom: $classroom, building: $building, freeFrom: $freeFrom, freeUntil: $freeUntil, freeDuration: $freeDuration)';
}


}

/// @nodoc
abstract mixin class $ClassroomAvailabilityCopyWith<$Res>  {
  factory $ClassroomAvailabilityCopyWith(ClassroomAvailability value, $Res Function(ClassroomAvailability) _then) = _$ClassroomAvailabilityCopyWithImpl;
@useResult
$Res call({
 String classroom, String building, DateTime freeFrom, DateTime freeUntil, Duration freeDuration
});




}
/// @nodoc
class _$ClassroomAvailabilityCopyWithImpl<$Res>
    implements $ClassroomAvailabilityCopyWith<$Res> {
  _$ClassroomAvailabilityCopyWithImpl(this._self, this._then);

  final ClassroomAvailability _self;
  final $Res Function(ClassroomAvailability) _then;

/// Create a copy of ClassroomAvailability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classroom = null,Object? building = null,Object? freeFrom = null,Object? freeUntil = null,Object? freeDuration = null,}) {
  return _then(_self.copyWith(
classroom: null == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,freeFrom: null == freeFrom ? _self.freeFrom : freeFrom // ignore: cast_nullable_to_non_nullable
as DateTime,freeUntil: null == freeUntil ? _self.freeUntil : freeUntil // ignore: cast_nullable_to_non_nullable
as DateTime,freeDuration: null == freeDuration ? _self.freeDuration : freeDuration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassroomAvailability].
extension ClassroomAvailabilityPatterns on ClassroomAvailability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassroomAvailability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassroomAvailability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassroomAvailability value)  $default,){
final _that = this;
switch (_that) {
case _ClassroomAvailability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassroomAvailability value)?  $default,){
final _that = this;
switch (_that) {
case _ClassroomAvailability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classroom,  String building,  DateTime freeFrom,  DateTime freeUntil,  Duration freeDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassroomAvailability() when $default != null:
return $default(_that.classroom,_that.building,_that.freeFrom,_that.freeUntil,_that.freeDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classroom,  String building,  DateTime freeFrom,  DateTime freeUntil,  Duration freeDuration)  $default,) {final _that = this;
switch (_that) {
case _ClassroomAvailability():
return $default(_that.classroom,_that.building,_that.freeFrom,_that.freeUntil,_that.freeDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classroom,  String building,  DateTime freeFrom,  DateTime freeUntil,  Duration freeDuration)?  $default,) {final _that = this;
switch (_that) {
case _ClassroomAvailability() when $default != null:
return $default(_that.classroom,_that.building,_that.freeFrom,_that.freeUntil,_that.freeDuration);case _:
  return null;

}
}

}

/// @nodoc


class _ClassroomAvailability implements ClassroomAvailability {
  const _ClassroomAvailability({required this.classroom, required this.building, required this.freeFrom, required this.freeUntil, required this.freeDuration});
  

@override final  String classroom;
@override final  String building;
@override final  DateTime freeFrom;
@override final  DateTime freeUntil;
@override final  Duration freeDuration;

/// Create a copy of ClassroomAvailability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomAvailabilityCopyWith<_ClassroomAvailability> get copyWith => __$ClassroomAvailabilityCopyWithImpl<_ClassroomAvailability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassroomAvailability&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.building, building) || other.building == building)&&(identical(other.freeFrom, freeFrom) || other.freeFrom == freeFrom)&&(identical(other.freeUntil, freeUntil) || other.freeUntil == freeUntil)&&(identical(other.freeDuration, freeDuration) || other.freeDuration == freeDuration));
}


@override
int get hashCode => Object.hash(runtimeType,classroom,building,freeFrom,freeUntil,freeDuration);

@override
String toString() {
  return 'ClassroomAvailability(classroom: $classroom, building: $building, freeFrom: $freeFrom, freeUntil: $freeUntil, freeDuration: $freeDuration)';
}


}

/// @nodoc
abstract mixin class _$ClassroomAvailabilityCopyWith<$Res> implements $ClassroomAvailabilityCopyWith<$Res> {
  factory _$ClassroomAvailabilityCopyWith(_ClassroomAvailability value, $Res Function(_ClassroomAvailability) _then) = __$ClassroomAvailabilityCopyWithImpl;
@override @useResult
$Res call({
 String classroom, String building, DateTime freeFrom, DateTime freeUntil, Duration freeDuration
});




}
/// @nodoc
class __$ClassroomAvailabilityCopyWithImpl<$Res>
    implements _$ClassroomAvailabilityCopyWith<$Res> {
  __$ClassroomAvailabilityCopyWithImpl(this._self, this._then);

  final _ClassroomAvailability _self;
  final $Res Function(_ClassroomAvailability) _then;

/// Create a copy of ClassroomAvailability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroom = null,Object? building = null,Object? freeFrom = null,Object? freeUntil = null,Object? freeDuration = null,}) {
  return _then(_ClassroomAvailability(
classroom: null == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as String,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,freeFrom: null == freeFrom ? _self.freeFrom : freeFrom // ignore: cast_nullable_to_non_nullable
as DateTime,freeUntil: null == freeUntil ? _self.freeUntil : freeUntil // ignore: cast_nullable_to_non_nullable
as DateTime,freeDuration: null == freeDuration ? _self.freeDuration : freeDuration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
