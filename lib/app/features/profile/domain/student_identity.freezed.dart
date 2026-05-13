// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_identity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentIdentity {

 String get actorId; String get displayName; ActorType get actorType; String get departmentName; String? get groupName; int? get departmentId; String? get fullName;
/// Create a copy of StudentIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentIdentityCopyWith<StudentIdentity> get copyWith => _$StudentIdentityCopyWithImpl<StudentIdentity>(this as StudentIdentity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentIdentity&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}


@override
int get hashCode => Object.hash(runtimeType,actorId,displayName,actorType,departmentName,groupName,departmentId,fullName);

@override
String toString() {
  return 'StudentIdentity(actorId: $actorId, displayName: $displayName, actorType: $actorType, departmentName: $departmentName, groupName: $groupName, departmentId: $departmentId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class $StudentIdentityCopyWith<$Res>  {
  factory $StudentIdentityCopyWith(StudentIdentity value, $Res Function(StudentIdentity) _then) = _$StudentIdentityCopyWithImpl;
@useResult
$Res call({
 String actorId, String displayName, ActorType actorType, String departmentName, String? groupName, int? departmentId, String? fullName
});




}
/// @nodoc
class _$StudentIdentityCopyWithImpl<$Res>
    implements $StudentIdentityCopyWith<$Res> {
  _$StudentIdentityCopyWithImpl(this._self, this._then);

  final StudentIdentity _self;
  final $Res Function(StudentIdentity) _then;

/// Create a copy of StudentIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actorId = null,Object? displayName = null,Object? actorType = null,Object? departmentName = null,Object? groupName = freezed,Object? departmentId = freezed,Object? fullName = freezed,}) {
  return _then(_self.copyWith(
actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as ActorType,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentIdentity].
extension StudentIdentityPatterns on StudentIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentIdentity value)  $default,){
final _that = this;
switch (_that) {
case _StudentIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _StudentIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actorId,  String displayName,  ActorType actorType,  String departmentName,  String? groupName,  int? departmentId,  String? fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentIdentity() when $default != null:
return $default(_that.actorId,_that.displayName,_that.actorType,_that.departmentName,_that.groupName,_that.departmentId,_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actorId,  String displayName,  ActorType actorType,  String departmentName,  String? groupName,  int? departmentId,  String? fullName)  $default,) {final _that = this;
switch (_that) {
case _StudentIdentity():
return $default(_that.actorId,_that.displayName,_that.actorType,_that.departmentName,_that.groupName,_that.departmentId,_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actorId,  String displayName,  ActorType actorType,  String departmentName,  String? groupName,  int? departmentId,  String? fullName)?  $default,) {final _that = this;
switch (_that) {
case _StudentIdentity() when $default != null:
return $default(_that.actorId,_that.displayName,_that.actorType,_that.departmentName,_that.groupName,_that.departmentId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc


class _StudentIdentity implements StudentIdentity {
  const _StudentIdentity({required this.actorId, required this.displayName, required this.actorType, required this.departmentName, this.groupName, this.departmentId, this.fullName});
  

@override final  String actorId;
@override final  String displayName;
@override final  ActorType actorType;
@override final  String departmentName;
@override final  String? groupName;
@override final  int? departmentId;
@override final  String? fullName;

/// Create a copy of StudentIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentIdentityCopyWith<_StudentIdentity> get copyWith => __$StudentIdentityCopyWithImpl<_StudentIdentity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentIdentity&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.departmentName, departmentName) || other.departmentName == departmentName)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}


@override
int get hashCode => Object.hash(runtimeType,actorId,displayName,actorType,departmentName,groupName,departmentId,fullName);

@override
String toString() {
  return 'StudentIdentity(actorId: $actorId, displayName: $displayName, actorType: $actorType, departmentName: $departmentName, groupName: $groupName, departmentId: $departmentId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$StudentIdentityCopyWith<$Res> implements $StudentIdentityCopyWith<$Res> {
  factory _$StudentIdentityCopyWith(_StudentIdentity value, $Res Function(_StudentIdentity) _then) = __$StudentIdentityCopyWithImpl;
@override @useResult
$Res call({
 String actorId, String displayName, ActorType actorType, String departmentName, String? groupName, int? departmentId, String? fullName
});




}
/// @nodoc
class __$StudentIdentityCopyWithImpl<$Res>
    implements _$StudentIdentityCopyWith<$Res> {
  __$StudentIdentityCopyWithImpl(this._self, this._then);

  final _StudentIdentity _self;
  final $Res Function(_StudentIdentity) _then;

/// Create a copy of StudentIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actorId = null,Object? displayName = null,Object? actorType = null,Object? departmentName = null,Object? groupName = freezed,Object? departmentId = freezed,Object? fullName = freezed,}) {
  return _then(_StudentIdentity(
actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as ActorType,departmentName: null == departmentName ? _self.departmentName : departmentName // ignore: cast_nullable_to_non_nullable
as String,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as int?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
