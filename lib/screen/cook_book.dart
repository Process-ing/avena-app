import 'package:avena/model/recipe.dart';
import 'package:avena/provider/category.dart';
import 'package:avena/provider/cook_book.dart';
import 'package:avena/screen/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CookBookScreen extends ConsumerWidget {
  final void Function() onProfilePressed;

  const CookBookScreen({super.key, required this.onProfilePressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    final category = ref.watch(cookBookCategoryProvider);
    final categoryNotifier = ref.watch(cookBookCategoryProvider.notifier);

    final pantry = ref.watch(cookBookPantryProvider);
    final pantryNotifier = ref.watch(cookBookPantryProvider.notifier);

    final recipes = ref.watch(cookBookRecipesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: onProfilePressed,
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600], size: 20),
            ),
          ),
        ),
        title: const Text(
          'Cook Book',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    // Category chips - scrollable from left edge
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final current = categories[index];
                            final isSelected = current == category;

                            return GestureDetector(
                              onTap: () => categoryNotifier.toggle(current),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  current,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemCount: categories.length,
                        ),
                      ),
                    ),
                    // Separator and Pantry chip on the right
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(width: 1),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => pantryNotifier.toggle(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: pantry ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: pantry ? Colors.black : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            'Pantry',
                            style: TextStyle(
                              color: pantry ? Colors.white : Colors.black87,
                              fontWeight: pantry
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Divider line
              Container(height: 1, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
      body: recipes.map(
        data: (recipes) => CookBookRecipeList(recipes.value),
        error: (error) {
          print('Error loading recipes: $error');

          return const Center(child: Text('Error loading recipes'));
        },
        loading: (_) => const Center(child: CircularProgressIndicator()),
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
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(
                recipeName: recipes[index].name,
                recipeImage: "https://picsum.photos/800/450",
                mealType: recipes[index].category,
                calories: recipes[index].calories,
              ),
            ),
          );
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.network(
                  "https://picsum.photos/800/450",
                  fit: BoxFit.cover,
                ),
              ),
              Container(color: Colors.black.withValues(alpha: 0.3)),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  recipes[index].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: recipes.length,
    );
  }
}
