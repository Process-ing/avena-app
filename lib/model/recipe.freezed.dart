// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Tag {

 int get id; String get name;
/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagCopyWith<Tag> get copyWith => _$TagCopyWithImpl<Tag>(this as Tag, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Tag(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $TagCopyWith<$Res>  {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$TagCopyWithImpl<$Res>
    implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Tag].
extension TagPatterns on Tag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tag value)  $default,){
final _that = this;
switch (_that) {
case _Tag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tag value)?  $default,){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _Tag():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _Tag implements Tag {
  const _Tag({required this.id, required this.name});
  

@override final  int id;
@override final  String name;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagCopyWith<_Tag> get copyWith => __$TagCopyWithImpl<_Tag>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'Tag(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) = __$TagCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$TagCopyWithImpl<$Res>
    implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Recipe {

 String get id; String get name; String get description; String get category; String get cuisine; String get difficulty; String get ingredients; String get instructions; String get meta; String get dietary; String get nutrition; String get storage; String get equipment; String get troubleshooting; String get chefNotes; String get culturalContext; List<Tag> get tags;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.cuisine, cuisine) || other.cuisine == cuisine)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.ingredients, ingredients) || other.ingredients == ingredients)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.dietary, dietary) || other.dietary == dietary)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.troubleshooting, troubleshooting) || other.troubleshooting == troubleshooting)&&(identical(other.chefNotes, chefNotes) || other.chefNotes == chefNotes)&&(identical(other.culturalContext, culturalContext) || other.culturalContext == culturalContext)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,cuisine,difficulty,ingredients,instructions,meta,dietary,nutrition,storage,equipment,troubleshooting,chefNotes,culturalContext,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'Recipe(id: $id, name: $name, description: $description, category: $category, cuisine: $cuisine, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions, meta: $meta, dietary: $dietary, nutrition: $nutrition, storage: $storage, equipment: $equipment, troubleshooting: $troubleshooting, chefNotes: $chefNotes, culturalContext: $culturalContext, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String category, String cuisine, String difficulty, String ingredients, String instructions, String meta, String dietary, String nutrition, String storage, String equipment, String troubleshooting, String chefNotes, String culturalContext, List<Tag> tags
});




}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? cuisine = null,Object? difficulty = null,Object? ingredients = null,Object? instructions = null,Object? meta = null,Object? dietary = null,Object? nutrition = null,Object? storage = null,Object? equipment = null,Object? troubleshooting = null,Object? chefNotes = null,Object? culturalContext = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,cuisine: null == cuisine ? _self.cuisine : cuisine // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String,dietary: null == dietary ? _self.dietary : dietary // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as String,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as String,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String,troubleshooting: null == troubleshooting ? _self.troubleshooting : troubleshooting // ignore: cast_nullable_to_non_nullable
as String,chefNotes: null == chefNotes ? _self.chefNotes : chefNotes // ignore: cast_nullable_to_non_nullable
as String,culturalContext: null == culturalContext ? _self.culturalContext : culturalContext // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,
  ));
}

}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String category,  String cuisine,  String difficulty,  String ingredients,  String instructions,  String meta,  String dietary,  String nutrition,  String storage,  String equipment,  String troubleshooting,  String chefNotes,  String culturalContext,  List<Tag> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.cuisine,_that.difficulty,_that.ingredients,_that.instructions,_that.meta,_that.dietary,_that.nutrition,_that.storage,_that.equipment,_that.troubleshooting,_that.chefNotes,_that.culturalContext,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String category,  String cuisine,  String difficulty,  String ingredients,  String instructions,  String meta,  String dietary,  String nutrition,  String storage,  String equipment,  String troubleshooting,  String chefNotes,  String culturalContext,  List<Tag> tags)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.name,_that.description,_that.category,_that.cuisine,_that.difficulty,_that.ingredients,_that.instructions,_that.meta,_that.dietary,_that.nutrition,_that.storage,_that.equipment,_that.troubleshooting,_that.chefNotes,_that.culturalContext,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String category,  String cuisine,  String difficulty,  String ingredients,  String instructions,  String meta,  String dietary,  String nutrition,  String storage,  String equipment,  String troubleshooting,  String chefNotes,  String culturalContext,  List<Tag> tags)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.cuisine,_that.difficulty,_that.ingredients,_that.instructions,_that.meta,_that.dietary,_that.nutrition,_that.storage,_that.equipment,_that.troubleshooting,_that.chefNotes,_that.culturalContext,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _Recipe implements Recipe {
  const _Recipe({required this.id, required this.name, required this.description, required this.category, required this.cuisine, required this.difficulty, required this.ingredients, required this.instructions, required this.meta, required this.dietary, required this.nutrition, required this.storage, required this.equipment, required this.troubleshooting, required this.chefNotes, required this.culturalContext, required final  List<Tag> tags}): _tags = tags;
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String category;
@override final  String cuisine;
@override final  String difficulty;
@override final  String ingredients;
@override final  String instructions;
@override final  String meta;
@override final  String dietary;
@override final  String nutrition;
@override final  String storage;
@override final  String equipment;
@override final  String troubleshooting;
@override final  String chefNotes;
@override final  String culturalContext;
 final  List<Tag> _tags;
@override List<Tag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.cuisine, cuisine) || other.cuisine == cuisine)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.ingredients, ingredients) || other.ingredients == ingredients)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.dietary, dietary) || other.dietary == dietary)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.troubleshooting, troubleshooting) || other.troubleshooting == troubleshooting)&&(identical(other.chefNotes, chefNotes) || other.chefNotes == chefNotes)&&(identical(other.culturalContext, culturalContext) || other.culturalContext == culturalContext)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,cuisine,difficulty,ingredients,instructions,meta,dietary,nutrition,storage,equipment,troubleshooting,chefNotes,culturalContext,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'Recipe(id: $id, name: $name, description: $description, category: $category, cuisine: $cuisine, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions, meta: $meta, dietary: $dietary, nutrition: $nutrition, storage: $storage, equipment: $equipment, troubleshooting: $troubleshooting, chefNotes: $chefNotes, culturalContext: $culturalContext, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String category, String cuisine, String difficulty, String ingredients, String instructions, String meta, String dietary, String nutrition, String storage, String equipment, String troubleshooting, String chefNotes, String culturalContext, List<Tag> tags
});




}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? cuisine = null,Object? difficulty = null,Object? ingredients = null,Object? instructions = null,Object? meta = null,Object? dietary = null,Object? nutrition = null,Object? storage = null,Object? equipment = null,Object? troubleshooting = null,Object? chefNotes = null,Object? culturalContext = null,Object? tags = null,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,cuisine: null == cuisine ? _self.cuisine : cuisine // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String,dietary: null == dietary ? _self.dietary : dietary // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as String,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as String,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as String,troubleshooting: null == troubleshooting ? _self.troubleshooting : troubleshooting // ignore: cast_nullable_to_non_nullable
as String,chefNotes: null == chefNotes ? _self.chefNotes : chefNotes // ignore: cast_nullable_to_non_nullable
as String,culturalContext: null == culturalContext ? _self.culturalContext : culturalContext // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,
  ));
}


}

// dart format on
