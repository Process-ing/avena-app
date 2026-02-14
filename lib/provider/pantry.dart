import 'dart:math';

import 'package:avena/model/pantry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pantry.g.dart';

// TODO: Backend styff
@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  Future<List<InventoryItem>> build() async => [
    InventoryItem(name: 'Flour', quantity: 2000, unit: Unit.gram),
    InventoryItem(name: 'Sugar', quantity: 1000, unit: Unit.gram),
    InventoryItem(name: 'Rice', quantity: 5000, unit: Unit.gram),
    InventoryItem(name: 'Pasta', quantity: 500, unit: Unit.gram),
    InventoryItem(name: 'Olive Oil', quantity: 1000, unit: Unit.milliliter),
    InventoryItem(name: 'Salt', quantity: 500, unit: Unit.gram),
    InventoryItem(name: 'Black Pepper', quantity: 100, unit: Unit.gram),
    InventoryItem(name: 'Garlic', quantity: 200, unit: Unit.gram),
    InventoryItem(name: 'Onions', quantity: 1000, unit: Unit.gram),
    InventoryItem(name: 'Tomatoes', quantity: 500, unit: Unit.gram),
    InventoryItem(name: 'Eggs', quantity: 12, unit: Unit.parcel),
    InventoryItem(name: 'Milk', quantity: 2000, unit: Unit.milliliter),
    InventoryItem(name: 'Butter', quantity: 250, unit: Unit.gram),
    InventoryItem(name: 'Cheese', quantity: 400, unit: Unit.gram),
    InventoryItem(name: 'Chicken Breast', quantity: 1000, unit: Unit.gram),
    InventoryItem(name: 'Almond Butter', quantity: 1, unit: Unit.parcel),
  ];

  void addItem(InventoryItem item) async {
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
