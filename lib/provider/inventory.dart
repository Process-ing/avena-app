import 'dart:math';

import 'package:avena/model/ingredient.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory.g.dart';

// TODO: Backend styff
@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  Future<List<Ingredient>> build() async => [
    Ingredient(name: 'Flour', quantity: 2000, unit: Unit.gram),
    Ingredient(name: 'Sugar', quantity: 1000, unit: Unit.gram),
    Ingredient(name: 'Rice', quantity: 5000, unit: Unit.gram),
    Ingredient(name: 'Pasta', quantity: 500, unit: Unit.gram),
    Ingredient(name: 'Olive Oil', quantity: 1000, unit: Unit.milliliter),
    Ingredient(name: 'Salt', quantity: 500, unit: Unit.gram),
    Ingredient(name: 'Black Pepper', quantity: 100, unit: Unit.gram),
    Ingredient(name: 'Garlic', quantity: 200, unit: Unit.gram),
    Ingredient(name: 'Onions', quantity: 1000, unit: Unit.gram),
    Ingredient(name: 'Tomatoes', quantity: 500, unit: Unit.gram),
    Ingredient(name: 'Eggs', quantity: 12, unit: Unit.parcel),
    Ingredient(name: 'Milk', quantity: 2000, unit: Unit.milliliter),
    Ingredient(name: 'Butter', quantity: 250, unit: Unit.gram),
    Ingredient(name: 'Cheese', quantity: 400, unit: Unit.gram),
    Ingredient(name: 'Chicken Breast', quantity: 1000, unit: Unit.gram),
    Ingredient(name: 'Almond Butter', quantity: 1, unit: Unit.parcel),
  ];

  void addItem(Ingredient item) async {
    state.value!.add(item);
    ref.notifyListeners();
  }

  void removeItem(int index) async {
    state.value!.removeAt(index);
    ref.notifyListeners();
  }

  void incrementItemQuantity(int index, int quantity) async {
    state.value![index] = state.value![index].copyWith(
      quantity: max(0, state.value![index].quantity + quantity),
    );
    ref.notifyListeners();
  }
}
