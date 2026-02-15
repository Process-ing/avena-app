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
mixin _$Recipe {

 String get id; String get name; String get description; String get category; String get cuisine; String get difficulty; int get calories; String get totalTime; String get activeTime; String get yields; int get proteinG; int get fatG; int get carbsG; int get fiberG; bool get isVegetarian; bool get isVegan; bool get isGlutenFree; List<String> get tags; List<Ingredient> get ingredients; int get coverageScore;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.cuisine, cuisine) || other.cuisine == cuisine)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&(identical(other.activeTime, activeTime) || other.activeTime == activeTime)&&(identical(other.yields, yields) || other.yields == yields)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.fiberG, fiberG) || other.fiberG == fiberG)&&(identical(other.isVegetarian, isVegetarian) || other.isVegetarian == isVegetarian)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&(identical(other.isGlutenFree, isGlutenFree) || other.isGlutenFree == isGlutenFree)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.coverageScore, coverageScore) || other.coverageScore == coverageScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,category,cuisine,difficulty,calories,totalTime,activeTime,yields,proteinG,fatG,carbsG,fiberG,isVegetarian,isVegan,isGlutenFree,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(ingredients),coverageScore]);

@override
String toString() {
  return 'Recipe(id: $id, name: $name, description: $description, category: $category, cuisine: $cuisine, difficulty: $difficulty, calories: $calories, totalTime: $totalTime, activeTime: $activeTime, yields: $yields, proteinG: $proteinG, fatG: $fatG, carbsG: $carbsG, fiberG: $fiberG, isVegetarian: $isVegetarian, isVegan: $isVegan, isGlutenFree: $isGlutenFree, tags: $tags, ingredients: $ingredients, coverageScore: $coverageScore)';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String category, String cuisine, String difficulty, int calories, String totalTime, String activeTime, String yields, int proteinG, int fatG, int carbsG, int fiberG, bool isVegetarian, bool isVegan, bool isGlutenFree, List<String> tags, List<Ingredient> ingredients, int coverageScore
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? cuisine = null,Object? difficulty = null,Object? calories = null,Object? totalTime = null,Object? activeTime = null,Object? yields = null,Object? proteinG = null,Object? fatG = null,Object? carbsG = null,Object? fiberG = null,Object? isVegetarian = null,Object? isVegan = null,Object? isGlutenFree = null,Object? tags = null,Object? ingredients = null,Object? coverageScore = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,cuisine: null == cuisine ? _self.cuisine : cuisine // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,totalTime: null == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as String,activeTime: null == activeTime ? _self.activeTime : activeTime // ignore: cast_nullable_to_non_nullable
as String,yields: null == yields ? _self.yields : yields // ignore: cast_nullable_to_non_nullable
as String,proteinG: null == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as int,fatG: null == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as int,carbsG: null == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as int,fiberG: null == fiberG ? _self.fiberG : fiberG // ignore: cast_nullable_to_non_nullable
as int,isVegetarian: null == isVegetarian ? _self.isVegetarian : isVegetarian // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,isGlutenFree: null == isGlutenFree ? _self.isGlutenFree : isGlutenFree // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,coverageScore: null == coverageScore ? _self.coverageScore : coverageScore // ignore: cast_nullable_to_non_nullable
as int,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String category,  String cuisine,  String difficulty,  int calories,  String totalTime,  String activeTime,  String yields,  int proteinG,  int fatG,  int carbsG,  int fiberG,  bool isVegetarian,  bool isVegan,  bool isGlutenFree,  List<String> tags,  List<Ingredient> ingredients,  int coverageScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.cuisine,_that.difficulty,_that.calories,_that.totalTime,_that.activeTime,_that.yields,_that.proteinG,_that.fatG,_that.carbsG,_that.fiberG,_that.isVegetarian,_that.isVegan,_that.isGlutenFree,_that.tags,_that.ingredients,_that.coverageScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String category,  String cuisine,  String difficulty,  int calories,  String totalTime,  String activeTime,  String yields,  int proteinG,  int fatG,  int carbsG,  int fiberG,  bool isVegetarian,  bool isVegan,  bool isGlutenFree,  List<String> tags,  List<Ingredient> ingredients,  int coverageScore)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.name,_that.description,_that.category,_that.cuisine,_that.difficulty,_that.calories,_that.totalTime,_that.activeTime,_that.yields,_that.proteinG,_that.fatG,_that.carbsG,_that.fiberG,_that.isVegetarian,_that.isVegan,_that.isGlutenFree,_that.tags,_that.ingredients,_that.coverageScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String category,  String cuisine,  String difficulty,  int calories,  String totalTime,  String activeTime,  String yields,  int proteinG,  int fatG,  int carbsG,  int fiberG,  bool isVegetarian,  bool isVegan,  bool isGlutenFree,  List<String> tags,  List<Ingredient> ingredients,  int coverageScore)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.cuisine,_that.difficulty,_that.calories,_that.totalTime,_that.activeTime,_that.yields,_that.proteinG,_that.fatG,_that.carbsG,_that.fiberG,_that.isVegetarian,_that.isVegan,_that.isGlutenFree,_that.tags,_that.ingredients,_that.coverageScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recipe implements Recipe {
  const _Recipe({required this.id, required this.name, required this.description, required this.category, required this.cuisine, required this.difficulty, required this.calories, required this.totalTime, required this.activeTime, required this.yields, required this.proteinG, required this.fatG, required this.carbsG, required this.fiberG, required this.isVegetarian, required this.isVegan, required this.isGlutenFree, required final  List<String> tags, required final  List<Ingredient> ingredients, required this.coverageScore}): _tags = tags,_ingredients = ingredients;
  factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String category;
@override final  String cuisine;
@override final  String difficulty;
@override final  int calories;
@override final  String totalTime;
@override final  String activeTime;
@override final  String yields;
@override final  int proteinG;
@override final  int fatG;
@override final  int carbsG;
@override final  int fiberG;
@override final  bool isVegetarian;
@override final  bool isVegan;
@override final  bool isGlutenFree;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<Ingredient> _ingredients;
@override List<Ingredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override final  int coverageScore;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.cuisine, cuisine) || other.cuisine == cuisine)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&(identical(other.activeTime, activeTime) || other.activeTime == activeTime)&&(identical(other.yields, yields) || other.yields == yields)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.fiberG, fiberG) || other.fiberG == fiberG)&&(identical(other.isVegetarian, isVegetarian) || other.isVegetarian == isVegetarian)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&(identical(other.isGlutenFree, isGlutenFree) || other.isGlutenFree == isGlutenFree)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.coverageScore, coverageScore) || other.coverageScore == coverageScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,category,cuisine,difficulty,calories,totalTime,activeTime,yields,proteinG,fatG,carbsG,fiberG,isVegetarian,isVegan,isGlutenFree,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_ingredients),coverageScore]);

@override
String toString() {
  return 'Recipe(id: $id, name: $name, description: $description, category: $category, cuisine: $cuisine, difficulty: $difficulty, calories: $calories, totalTime: $totalTime, activeTime: $activeTime, yields: $yields, proteinG: $proteinG, fatG: $fatG, carbsG: $carbsG, fiberG: $fiberG, isVegetarian: $isVegetarian, isVegan: $isVegan, isGlutenFree: $isGlutenFree, tags: $tags, ingredients: $ingredients, coverageScore: $coverageScore)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String category, String cuisine, String difficulty, int calories, String totalTime, String activeTime, String yields, int proteinG, int fatG, int carbsG, int fiberG, bool isVegetarian, bool isVegan, bool isGlutenFree, List<String> tags, List<Ingredient> ingredients, int coverageScore
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? cuisine = null,Object? difficulty = null,Object? calories = null,Object? totalTime = null,Object? activeTime = null,Object? yields = null,Object? proteinG = null,Object? fatG = null,Object? carbsG = null,Object? fiberG = null,Object? isVegetarian = null,Object? isVegan = null,Object? isGlutenFree = null,Object? tags = null,Object? ingredients = null,Object? coverageScore = null,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,cuisine: null == cuisine ? _self.cuisine : cuisine // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,totalTime: null == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as String,activeTime: null == activeTime ? _self.activeTime : activeTime // ignore: cast_nullable_to_non_nullable
as String,yields: null == yields ? _self.yields : yields // ignore: cast_nullable_to_non_nullable
as String,proteinG: null == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as int,fatG: null == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as int,carbsG: null == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as int,fiberG: null == fiberG ? _self.fiberG : fiberG // ignore: cast_nullable_to_non_nullable
as int,isVegetarian: null == isVegetarian ? _self.isVegetarian : isVegetarian // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,isGlutenFree: null == isGlutenFree ? _self.isGlutenFree : isGlutenFree // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,coverageScore: null == coverageScore ? _self.coverageScore : coverageScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
