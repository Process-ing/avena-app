import 'package:freezed_annotation/freezed_annotation.dart';

part 'pantry.freezed.dart';

enum Unit {
  gram('g'),
  milliliter('ml'),
  parcel('pcs');

  const Unit(this.name);
  final String name;
}

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String name,
    required int quantity,
    required Unit unit,
  }) = _PantryItem;
}
