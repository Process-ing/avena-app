import 'package:avena/model/ingredient.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String name,
    required String description,
    required String category,
    required String cuisine,
    required String difficulty,
    required int calories,
    required String totalTime,
    required String activeTime,
    required String yields,
    required int proteinG,
    required int fatG,
    required int carbsG,
    required int fiberG,
    required bool isVegetarian,
    required bool isVegan,
    required bool isGlutenFree,
    required List<String> tags,
    required List<Ingredient> ingredients,
    required int coverageScore,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
