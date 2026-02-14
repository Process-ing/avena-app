import 'package:avena/model/recipe.dart';
import 'package:avena/provider/category.dart';
import 'package:avena/provider/cook_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CookBookScreen extends ConsumerWidget {
  const CookBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    final category = ref.watch(cookBookCategoryProvider);
    final categoryNotifier = ref.watch(cookBookCategoryProvider.notifier);

    final pantry = ref.watch(cookBookPantryProvider);
    final pantryNotifier = ref.watch(cookBookPantryProvider.notifier);

    final recipes = ref.watch(cookBookRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cook Book'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final current = categories[index];

                      return ChoiceChip(
                        label: Text(current),
                        selected: current == category,
                        onSelected: (v) => categoryNotifier.toggle(current),
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(width: 4),
                    itemCount: categories.length,
                  ),
                ),
              ),
              SizedBox(height: 40, child: VerticalDivider(width: 1)),
              SizedBox(width: 4),
              ChoiceChip(
                label: Text('Pantry'),
                selected: pantry,
                onSelected: (_) => pantryNotifier.toggle(),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: recipes.map(
        data: (recipes) => CookBookRecipeList(recipes.value),
        error: (error) => Text('Error loading recipes'),
        loading: (_) => CircularProgressIndicator(),
      ),
    );
  }
}

class CookBookRecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  const CookBookRecipeList(this.recipes, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Positioned.fill(
              child: Image.network(
                "https://picsum.photos/800/450",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(32),
              child: Text(
                recipes[index].name,
                style: Theme.of(context).primaryTextTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemCount: recipes.length,
    );
  }
}
