import 'package:avena/model/recipe.dart';
import 'package:avena/provider/api.dart';
import 'package:avena/provider/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe.g.dart';

@riverpod
Future<List<Recipe>> recipes(Ref ref) async {
  final api = ref.watch(backendApiProvider);

  final authenticatedUser = await ref.watch(authenticatedUserProvider.future);
  if (authenticatedUser == null) throw Exception();

  return await api.suggestRecipes(true);
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
