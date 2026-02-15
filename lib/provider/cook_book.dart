import 'package:avena/model/recipe.dart';
import 'package:avena/provider/recipe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cook_book.g.dart';

@riverpod
class CookBookCategoryNotifier extends _$CookBookCategoryNotifier {
  @override
  String? build() => null;

  void toggle(String category) {
    state = category == state ? null : category;
  }
}

@riverpod
class CookBookPantryNotifier extends _$CookBookPantryNotifier {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }
}

@riverpod
Future<List<Recipe>> cookBookRecipes(Ref ref) {
  final category = ref.watch(cookBookCategoryProvider);
  final pantry = ref.watch(cookBookPantryProvider);

  return ref.watch(
    filteredRecipesProvider(category: category, pantry: pantry).future,
  );
}
