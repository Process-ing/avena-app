import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

enum Unit {
  gram('g'),
  milliliter('ml'),
  parcel('pcs');

  const Unit(this.name);
  final String name;
}

@freezed
abstract class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    required int quantity,
    required Unit unit,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}
