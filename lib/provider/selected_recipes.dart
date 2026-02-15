import 'package:avena/model/recipe.dart';
import 'package:avena/model/week.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_recipes.g.dart';

@riverpod
class SelectedRecipesNotifier extends _$SelectedRecipesNotifier {
  @override
  Future<Map<WeekDay, List<Recipe>>> build() async => {};
}
