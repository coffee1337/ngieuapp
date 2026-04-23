// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsArticle {

 int get id; String get title; String get url; String get excerpt; String? get imageUrl; DateTime? get publishedAt; String? get author;
/// Create a copy of NewsArticle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsArticleCopyWith<NewsArticle> get copyWith => _$NewsArticleCopyWithImpl<NewsArticle>(this as NewsArticle, _$identity);

  /// Serializes this NewsArticle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,url,excerpt,imageUrl,publishedAt,author);

@override
String toString() {
  return 'NewsArticle(id: $id, title: $title, url: $url, excerpt: $excerpt, imageUrl: $imageUrl, publishedAt: $publishedAt, author: $author)';
}


}

/// @nodoc
abstract mixin class $NewsArticleCopyWith<$Res>  {
  factory $NewsArticleCopyWith(NewsArticle value, $Res Function(NewsArticle) _then) = _$NewsArticleCopyWithImpl;
@useResult
$Res call({
 int id, String title, String url, String excerpt, String? imageUrl, DateTime? publishedAt, String? author
});




}
/// @nodoc
class _$NewsArticleCopyWithImpl<$Res>
    implements $NewsArticleCopyWith<$Res> {
  _$NewsArticleCopyWithImpl(this._self, this._then);

  final NewsArticle _self;
  final $Res Function(NewsArticle) _then;

/// Create a copy of NewsArticle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? url = null,Object? excerpt = null,Object? imageUrl = freezed,Object? publishedAt = freezed,Object? author = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsArticle].
extension NewsArticlePatterns on NewsArticle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsArticle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsArticle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsArticle value)  $default,){
final _that = this;
switch (_that) {
case _NewsArticle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsArticle value)?  $default,){
final _that = this;
switch (_that) {
case _NewsArticle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String url,  String excerpt,  String? imageUrl,  DateTime? publishedAt,  String? author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsArticle() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.excerpt,_that.imageUrl,_that.publishedAt,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String url,  String excerpt,  String? imageUrl,  DateTime? publishedAt,  String? author)  $default,) {final _that = this;
switch (_that) {
case _NewsArticle():
return $default(_that.id,_that.title,_that.url,_that.excerpt,_that.imageUrl,_that.publishedAt,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String url,  String excerpt,  String? imageUrl,  DateTime? publishedAt,  String? author)?  $default,) {final _that = this;
switch (_that) {
case _NewsArticle() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.excerpt,_that.imageUrl,_that.publishedAt,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsArticle implements NewsArticle {
  const _NewsArticle({required this.id, required this.title, required this.url, required this.excerpt, this.imageUrl, this.publishedAt, this.author});
  factory _NewsArticle.fromJson(Map<String, dynamic> json) => _$NewsArticleFromJson(json);

@override final  int id;
@override final  String title;
@override final  String url;
@override final  String excerpt;
@override final  String? imageUrl;
@override final  DateTime? publishedAt;
@override final  String? author;

/// Create a copy of NewsArticle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsArticleCopyWith<_NewsArticle> get copyWith => __$NewsArticleCopyWithImpl<_NewsArticle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsArticleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,url,excerpt,imageUrl,publishedAt,author);

@override
String toString() {
  return 'NewsArticle(id: $id, title: $title, url: $url, excerpt: $excerpt, imageUrl: $imageUrl, publishedAt: $publishedAt, author: $author)';
}


}

/// @nodoc
abstract mixin class _$NewsArticleCopyWith<$Res> implements $NewsArticleCopyWith<$Res> {
  factory _$NewsArticleCopyWith(_NewsArticle value, $Res Function(_NewsArticle) _then) = __$NewsArticleCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String url, String excerpt, String? imageUrl, DateTime? publishedAt, String? author
});




}
/// @nodoc
class __$NewsArticleCopyWithImpl<$Res>
    implements _$NewsArticleCopyWith<$Res> {
  __$NewsArticleCopyWithImpl(this._self, this._then);

  final _NewsArticle _self;
  final $Res Function(_NewsArticle) _then;

/// Create a copy of NewsArticle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? url = null,Object? excerpt = null,Object? imageUrl = freezed,Object? publishedAt = freezed,Object? author = freezed,}) {
  return _then(_NewsArticle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$NewsArticleFull {

 NewsArticle get preview; String get contentHtml; List<String> get gallery;
/// Create a copy of NewsArticleFull
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsArticleFullCopyWith<NewsArticleFull> get copyWith => _$NewsArticleFullCopyWithImpl<NewsArticleFull>(this as NewsArticleFull, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsArticleFull&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.contentHtml, contentHtml) || other.contentHtml == contentHtml)&&const DeepCollectionEquality().equals(other.gallery, gallery));
}


@override
int get hashCode => Object.hash(runtimeType,preview,contentHtml,const DeepCollectionEquality().hash(gallery));

@override
String toString() {
  return 'NewsArticleFull(preview: $preview, contentHtml: $contentHtml, gallery: $gallery)';
}


}

/// @nodoc
abstract mixin class $NewsArticleFullCopyWith<$Res>  {
  factory $NewsArticleFullCopyWith(NewsArticleFull value, $Res Function(NewsArticleFull) _then) = _$NewsArticleFullCopyWithImpl;
@useResult
$Res call({
 NewsArticle preview, String contentHtml, List<String> gallery
});


$NewsArticleCopyWith<$Res> get preview;

}
/// @nodoc
class _$NewsArticleFullCopyWithImpl<$Res>
    implements $NewsArticleFullCopyWith<$Res> {
  _$NewsArticleFullCopyWithImpl(this._self, this._then);

  final NewsArticleFull _self;
  final $Res Function(NewsArticleFull) _then;

/// Create a copy of NewsArticleFull
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preview = null,Object? contentHtml = null,Object? gallery = null,}) {
  return _then(_self.copyWith(
preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as NewsArticle,contentHtml: null == contentHtml ? _self.contentHtml : contentHtml // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of NewsArticleFull
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewsArticleCopyWith<$Res> get preview {
  
  return $NewsArticleCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewsArticleFull].
extension NewsArticleFullPatterns on NewsArticleFull {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsArticleFull value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsArticleFull() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsArticleFull value)  $default,){
final _that = this;
switch (_that) {
case _NewsArticleFull():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsArticleFull value)?  $default,){
final _that = this;
switch (_that) {
case _NewsArticleFull() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NewsArticle preview,  String contentHtml,  List<String> gallery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsArticleFull() when $default != null:
return $default(_that.preview,_that.contentHtml,_that.gallery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NewsArticle preview,  String contentHtml,  List<String> gallery)  $default,) {final _that = this;
switch (_that) {
case _NewsArticleFull():
return $default(_that.preview,_that.contentHtml,_that.gallery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NewsArticle preview,  String contentHtml,  List<String> gallery)?  $default,) {final _that = this;
switch (_that) {
case _NewsArticleFull() when $default != null:
return $default(_that.preview,_that.contentHtml,_that.gallery);case _:
  return null;

}
}

}

/// @nodoc


class _NewsArticleFull implements NewsArticleFull {
  const _NewsArticleFull({required this.preview, required this.contentHtml, required final  List<String> gallery}): _gallery = gallery;
  

@override final  NewsArticle preview;
@override final  String contentHtml;
 final  List<String> _gallery;
@override List<String> get gallery {
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gallery);
}


/// Create a copy of NewsArticleFull
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsArticleFullCopyWith<_NewsArticleFull> get copyWith => __$NewsArticleFullCopyWithImpl<_NewsArticleFull>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsArticleFull&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.contentHtml, contentHtml) || other.contentHtml == contentHtml)&&const DeepCollectionEquality().equals(other._gallery, _gallery));
}


@override
int get hashCode => Object.hash(runtimeType,preview,contentHtml,const DeepCollectionEquality().hash(_gallery));

@override
String toString() {
  return 'NewsArticleFull(preview: $preview, contentHtml: $contentHtml, gallery: $gallery)';
}


}

/// @nodoc
abstract mixin class _$NewsArticleFullCopyWith<$Res> implements $NewsArticleFullCopyWith<$Res> {
  factory _$NewsArticleFullCopyWith(_NewsArticleFull value, $Res Function(_NewsArticleFull) _then) = __$NewsArticleFullCopyWithImpl;
@override @useResult
$Res call({
 NewsArticle preview, String contentHtml, List<String> gallery
});


@override $NewsArticleCopyWith<$Res> get preview;

}
/// @nodoc
class __$NewsArticleFullCopyWithImpl<$Res>
    implements _$NewsArticleFullCopyWith<$Res> {
  __$NewsArticleFullCopyWithImpl(this._self, this._then);

  final _NewsArticleFull _self;
  final $Res Function(_NewsArticleFull) _then;

/// Create a copy of NewsArticleFull
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preview = null,Object? contentHtml = null,Object? gallery = null,}) {
  return _then(_NewsArticleFull(
preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as NewsArticle,contentHtml: null == contentHtml ? _self.contentHtml : contentHtml // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of NewsArticleFull
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewsArticleCopyWith<$Res> get preview {
  
  return $NewsArticleCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

// dart format on
