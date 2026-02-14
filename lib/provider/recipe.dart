import 'package:avena/model/recipe.dart';
import 'package:avena/provider/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe.g.dart';

@riverpod
Future<List<Recipe>> recipes(Ref ref) async {
  final categories = ref.watch(categoriesProvider);

  return List.generate(
    10000,
    (i) => Recipe(
      id: i.toString(),
      name: "Recipe name $i",
      description: "Test",
      category: categories[i % categories.length],
      cuisine: "Test",
      difficulty: "Test",
      ingredients: "Test",
      instructions: "Test",
      meta: "Test",
      dietary: "Test",
      nutrition: "Test",
      storage: "Test",
      equipment: "Test",
      troubleshooting: "Test",
      chefNotes: "Test",
      culturalContext: "Test",
      tags: [],
    ),
    growable: false,
  );
}

// TODO
// @riverpod
// Future<List<Recipe>> recipes(Ref ref) async {
//   final api = ref.watch(backendApiProvider);

//   return await api.recipes();
// }

@riverpod
Future<List<Recipe>> filteredRecipes(
  Ref ref, {
  String? category,
  bool pantry = false,
}) async {
  final recipes = await ref.watch(recipesProvider.future);

  // TODO: Filter by pantry
  return recipes
      .where((recipe) => category == null || recipe.category == category)
      .toList(growable: false);
}
