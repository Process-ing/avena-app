import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';

@freezed
abstract class Tag with _$Tag {
  const factory Tag({required int id, required String name}) = _Tag;
}

@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String name,
    required String description,
    required String category,
    required String cuisine,
    required String difficulty,
    required String ingredients,
    required String instructions,
    required String meta,
    required String dietary,
    required String nutrition,
    required String storage,
    required String equipment,
    required String troubleshooting,
    required String chefNotes,
    required String culturalContext,
    required List<Tag> tags,
  }) = _Recipe;
}
