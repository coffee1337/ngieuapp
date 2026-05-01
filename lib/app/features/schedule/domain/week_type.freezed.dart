// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeekType {

 DateTime get date; bool get isUpperWeek;
/// Create a copy of WeekType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekTypeCopyWith<WeekType> get copyWith => _$WeekTypeCopyWithImpl<WeekType>(this as WeekType, _$identity);

  /// Serializes this WeekType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekType&&(identical(other.date, date) || other.date == date)&&(identical(other.isUpperWeek, isUpperWeek) || other.isUpperWeek == isUpperWeek));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,isUpperWeek);

@override
String toString() {
  return 'WeekType(date: $date, isUpperWeek: $isUpperWeek)';
}


}

/// @nodoc
abstract mixin class $WeekTypeCopyWith<$Res>  {
  factory $WeekTypeCopyWith(WeekType value, $Res Function(WeekType) _then) = _$WeekTypeCopyWithImpl;
@useResult
$Res call({
 DateTime date, bool isUpperWeek
});




}
/// @nodoc
class _$WeekTypeCopyWithImpl<$Res>
    implements $WeekTypeCopyWith<$Res> {
  _$WeekTypeCopyWithImpl(this._self, this._then);

  final WeekType _self;
  final $Res Function(WeekType) _then;

/// Create a copy of WeekType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? isUpperWeek = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isUpperWeek: null == isUpperWeek ? _self.isUpperWeek : isUpperWeek // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekType].
extension WeekTypePatterns on WeekType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekType value)  $default,){
final _that = this;
switch (_that) {
case _WeekType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekType value)?  $default,){
final _that = this;
switch (_that) {
case _WeekType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  bool isUpperWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekType() when $default != null:
return $default(_that.date,_that.isUpperWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  bool isUpperWeek)  $default,) {final _that = this;
switch (_that) {
case _WeekType():
return $default(_that.date,_that.isUpperWeek);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  bool isUpperWeek)?  $default,) {final _that = this;
switch (_that) {
case _WeekType() when $default != null:
return $default(_that.date,_that.isUpperWeek);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekType extends WeekType {
  const _WeekType({required this.date, required this.isUpperWeek}): super._();
  factory _WeekType.fromJson(Map<String, dynamic> json) => _$WeekTypeFromJson(json);

@override final  DateTime date;
@override final  bool isUpperWeek;

/// Create a copy of WeekType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekTypeCopyWith<_WeekType> get copyWith => __$WeekTypeCopyWithImpl<_WeekType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekType&&(identical(other.date, date) || other.date == date)&&(identical(other.isUpperWeek, isUpperWeek) || other.isUpperWeek == isUpperWeek));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,isUpperWeek);

@override
String toString() {
  return 'WeekType(date: $date, isUpperWeek: $isUpperWeek)';
}


}

/// @nodoc
abstract mixin class _$WeekTypeCopyWith<$Res> implements $WeekTypeCopyWith<$Res> {
  factory _$WeekTypeCopyWith(_WeekType value, $Res Function(_WeekType) _then) = __$WeekTypeCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, bool isUpperWeek
});




}
/// @nodoc
class __$WeekTypeCopyWithImpl<$Res>
    implements _$WeekTypeCopyWith<$Res> {
  __$WeekTypeCopyWithImpl(this._self, this._then);

  final _WeekType _self;
  final $Res Function(_WeekType) _then;

/// Create a copy of WeekType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? isUpperWeek = null,}) {
  return _then(_WeekType(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isUpperWeek: null == isUpperWeek ? _self.isUpperWeek : isUpperWeek // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
