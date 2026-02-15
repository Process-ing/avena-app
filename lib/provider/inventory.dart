import 'dart:math';

import 'package:avena/model/ingredient.dart';
import 'package:avena/provider/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory.g.dart';

@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  Future<List<Ingredient>> build() async {
    final api = ref.watch(backendApiProvider);

    return await api.getInventory();
  }

  void addItem(Ingredient item) {
    final api = ref.watch(backendApiProvider);
    api.addInventoryItem(item);

    state.value!.add(item);
    ref.notifyListeners();
  }

  void removeItem(int index) {
    final api = ref.watch(backendApiProvider);
    api.removeInventoryItem(state.value![index].name);

    state.value!.removeAt(index);
    ref.notifyListeners();
  }

  void incrementItemQuantity(int index, int quantity) {
    final api = ref.watch(backendApiProvider);
    final newQuantity = max(0, state.value![index].quantity + quantity);

    state.value![index] = state.value![index].copyWith(quantity: newQuantity);
    ref.notifyListeners();
    api.updateInventoryItem(state.value![index].name, state.value![index]);
  }
}
