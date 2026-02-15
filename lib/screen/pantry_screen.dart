import 'package:avena/model/ingredient.dart';
import 'package:avena/model/week.dart';
import 'package:avena/provider/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key, required void Function() onProfilePressed});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  WeekDay selectedDay = WeekDay.monday;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removeRecipe(WeekDay day, int index) {
    setState(() {
      // recipesByDay[day]?.removeAt(index);
    });
  }

  // Check if an ingredient is available in inventory
  bool _checkIngredientInInventory(String ingredientText) {
    // Extract ingredient name from text (remove quantities and units)
    final cleanName = _extractIngredientName(ingredientText).toLowerCase();

    // Check if any inventory item matches
    // for (var invItem in _inventoryItems) {
    //   final invName = (invItem['name'] as String).toLowerCase();

    //   // Use word boundary matching to avoid false matches
    //   // "butter" should not match "almond butter"
    //   // Split both into words and check for exact word matches
    //   final cleanWords = cleanName.split(RegExp(r'\s+'));
    //   final invWords = invName.split(RegExp(r'\s+'));

    //   // Check if all inventory words are present in the ingredient
    //   bool allWordsMatch = true;
    //   for (var invWord in invWords) {
    //     if (!cleanWords.contains(invWord)) {
    //       allWordsMatch = false;
    //       break;
    //     }
    //   }

    //   if (allWordsMatch && invWords.isNotEmpty) {
    //     final quantity = invItem['quantity'] as double;
    //     // Item exists and has stock
    //     if (quantity > 0) {
    //       return true;
    //     }
    //   }
    // }

    return false;
  }

  // Extract ingredient name by removing quantities and common units
  String _extractIngredientName(String ingredientText) {
    // Remove leading numbers and units
    String cleaned = ingredientText
        .replaceAll(RegExp(r'^\d+\.?\d*\s*'), '') // Remove numbers at start
        .replaceAll(
          RegExp(
            r'^(cup|cups|tablespoon|tablespoons|tbsp|teaspoon|teaspoons|tsp|g|kg|ml|l|oz|lb|pcs|piece|pieces|slices?|frozen|fresh|ripe|whole|grain|all-purpose|dairy-free)\s+',
            caseSensitive: false,
          ),
          '',
        );

    return cleaned.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600], size: 20),
          ),
        ),
        title: const Text(
          'Pantry',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Inventory'),
            Tab(text: 'Shopping List'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [Inventory(), _buildShoppingList()],
      ),
    );
  }

  Widget _buildShoppingList() {
    final currentRecipes = /* recipesByDay[selectedDay] ?? */ [];

    return Column(
      children: [
        // Day of week filters
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: WeekDay.values.map((day) {
                final isSelected = day == selectedDay;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        day.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Recipe list
        Expanded(
          child: currentRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'No recipes for this day',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: currentRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = currentRecipes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RecipeCard(
                        key: ValueKey('${selectedDay}_$index'),
                        title: recipe['title'],
                        subtitle: recipe['subtitle'],
                        imageUrl: recipe['imageUrl'],
                        ingredients: List<Map<String, dynamic>>.from(
                          recipe['ingredients'],
                        ),
                        onRemove: () => _removeRecipe(selectedDay, index),
                        checkInventory: _checkIngredientInInventory,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class RecipeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<Map<String, dynamic>> ingredients;
  final VoidCallback onRemove;
  final bool Function(String) checkInventory;

  const RecipeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.ingredients,
    required this.onRemove,
    required this.checkInventory,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  int portions = 1;
  late List<bool> manuallyPurchased; // Only track manual toggles

  @override
  void initState() {
    super.initState();
    _initializeManualPurchases();
  }

  @override
  void didUpdateWidget(RecipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize if ingredients list changed
    if (widget.ingredients.length != oldWidget.ingredients.length) {
      _initializeManualPurchases();
    }
  }

  void _initializeManualPurchases() {
    // Only track manually purchased items (not inventory-based)
    manuallyPurchased = widget.ingredients
        .map((ingredient) => ingredient['purchased'] as bool? ?? false)
        .toList();
  }

  /// Check if ingredient should be marked as purchased (either manually or in inventory)
  bool _isIngredientPurchased(int index) {
    if (index >= widget.ingredients.length) return false;

    final ingredientText = widget.ingredients[index]['text'] as String;
    final inInventory = widget.checkInventory(ingredientText);
    final manuallyChecked =
        index < manuallyPurchased.length && manuallyPurchased[index];

    return inInventory || manuallyChecked;
  }

  /// Scales ingredient amounts based on portions
  String _scaleIngredient(String ingredientText, int portions) {
    // Use regex to find numbers (including decimals) at the start of the ingredient
    final regex = RegExp(r'^(\d+\.?\d*)\s*');
    final match = regex.firstMatch(ingredientText);

    if (match != null) {
      final originalAmount = double.parse(match.group(1)!);
      final scaledAmount = originalAmount * portions;

      // Format the number nicely (remove unnecessary decimals)
      final formattedAmount = scaledAmount % 1 == 0
          ? scaledAmount.toInt().toString()
          : scaledAmount.toStringAsFixed(1);

      return ingredientText.replaceFirst(regex, '$formattedAmount ');
    }

    return ingredientText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with title overlay and error handling
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withValues(alpha: 0.3),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Portions control
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Portions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _buildPortionButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (portions > 1) {
                          setState(() {
                            portions--;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$portions',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildPortionButton(
                      icon: Icons.add,
                      onPressed: () {
                        setState(() {
                          portions++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Ingredients list - automatically crossed if in inventory
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.ingredients.length, (index) {
                final originalText =
                    widget.ingredients[index]['text'] as String;
                final scaledText = _scaleIngredient(originalText, portions);
                final isPurchased = _isIngredientPurchased(index);

                return GestureDetector(
                  onTap: () {
                    // Toggle manual purchase status
                    if (index >= 0 && index < manuallyPurchased.length) {
                      setState(() {
                        manuallyPurchased[index] = !manuallyPurchased[index];
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          isPurchased
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            scaledText,
                            style: TextStyle(
                              fontSize: 15,
                              color: isPurchased ? Colors.grey : Colors.black87,
                              decoration: isPurchased
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Remove button with functionality
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Remove Recipe'),
                      content: Text(
                        'Are you sure you want to remove "${widget.title.replaceAll('\n', ' ')}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onRemove();
                          },
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        color: Colors.black87,
      ),
    );
  }
}

class Inventory extends ConsumerWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryItems = ref.watch(inventoryProvider);
    final inventoryNotifier = ref.watch(inventoryProvider.notifier);

    return Scaffold(
      body: inventoryItems.map(
        data: (inventoryItems) => ListView.builder(
          padding: const EdgeInsets.all(16).copyWith(bottom: 80),
          itemCount: inventoryItems.value.length,
          itemBuilder: (context, index) {
            final item = inventoryItems.value[index];
            return InventoryItemCard(
              item: item,
              onIncrement: () =>
                  inventoryNotifier.incrementItemQuantity(index, 1),
              onDecrement: () =>
                  inventoryNotifier.incrementItemQuantity(index, -1),
              onDelete: () => _deleteInventoryItem(
                context,
                item,
                () => inventoryNotifier.removeItem(index),
              ),
            );
          },
        ),
        error: (error) => Text(error.error.toString()),
        loading: (_) => CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addInventoryItem(context, inventoryNotifier.addItem),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _deleteInventoryItem(
    BuildContext context,
    Ingredient item,
    VoidCallback onDelete,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Remove ${item.name} from inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addInventoryItem(
    BuildContext context,
    void Function(Ingredient) onAdd,
  ) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    Unit selectedUnit = Unit.gram;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Inventory Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<Unit>(
                        initialValue: selectedUnit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                        items: Unit.values
                            .map(
                              (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedUnit = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Navigator.pop(context);
                  onAdd(
                    Ingredient(
                      name: nameController.text,
                      quantity: int.tryParse(quantityController.text) ?? 1,
                      unit: selectedUnit,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryItemCard extends StatelessWidget {
  final Ingredient item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          // Item info
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: onDecrement,
                color: Colors.grey[700],
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(minWidth: 60),
                child: Text(
                  '${item.quantity} ${item.unit.name}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onIncrement,
                color: Colors.grey[700],
                iconSize: 24,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            color: Colors.red[400],
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
