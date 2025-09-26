// presentation/controllers/grocery_controller.dart
import 'package:day_os/data/models/grocery_item.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class GroceryController extends GetxController {
  final isLoading = false.obs;
  final groceryItems = <GroceryItem>[].obs;

  @override
  void onInit() {
    generateFromMealPlan();
    super.onInit();
  }

  Map<String, List<GroceryItem>> get groupedItems {
    final map = <String, List<GroceryItem>>{};
    for (final item in groceryItems) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  Future<void> generateFromMealPlan() async {
    isLoading.value = true;

    try {
      // In real app: listen to MealController and auto-update
      await Future.delayed(const Duration(milliseconds: 800));

      groceryItems.value = [
        // Produce
        GroceryItem(
          id: 1,
          name: 'Spinach',
          quantity: '1 bag',
          category: 'Produce',
        ),
        GroceryItem(
          id: 2,
          name: 'Bell Peppers',
          quantity: '3',
          category: 'Produce',
        ),
        GroceryItem(
          id: 3,
          name: 'Broccoli',
          quantity: '1 head',
          category: 'Produce',
        ),
        GroceryItem(id: 4, name: 'Bananas', quantity: '6', category: 'Produce'),
        GroceryItem(
          id: 5,
          name: 'Berries',
          quantity: '1 pint',
          category: 'Produce',
        ),

        // Dairy
        GroceryItem(
          id: 6,
          name: 'Greek Yogurt',
          quantity: '32 oz',
          category: 'Dairy',
        ),
        GroceryItem(
          id: 7,
          name: 'Almond Milk',
          quantity: '1 carton',
          category: 'Dairy',
          notes: 'Unsweetened',
        ),

        // Pantry
        GroceryItem(
          id: 8,
          name: 'Quinoa',
          quantity: '1 lb',
          category: 'Pantry',
        ),
        GroceryItem(
          id: 9,
          name: 'Black Beans',
          quantity: '2 cans',
          category: 'Pantry',
        ),
        GroceryItem(
          id: 10,
          name: 'Brown Rice',
          quantity: '2 lbs',
          category: 'Pantry',
        ),
        GroceryItem(
          id: 11,
          name: 'Granola',
          quantity: '1 bag',
          category: 'Pantry',
        ),

        // Meat & Seafood
        GroceryItem(
          id: 12,
          name: 'Salmon Fillets',
          quantity: '4',
          category: 'Meat & Seafood',
        ),

        // Other
        GroceryItem(
          id: 13,
          name: 'Chia Seeds',
          quantity: '8 oz',
          category: 'Other',
        ),
        GroceryItem(
          id: 14,
          name: 'Almond Butter',
          quantity: '1 jar',
          category: 'Other',
        ),
        GroceryItem(
          id: 15,
          name: 'fish',
          quantity: '4',
          category: 'Meat & Seafood',
        ),
      ];
    } finally {
      isLoading.value = false;
    }
  }

  void toggleItem(int id, bool isPurchased) {
    final index = groceryItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      groceryItems[index].isPurchased = isPurchased;
      groceryItems.refresh(); // Trigger UI update
    }
  }

  void addItem({
    required String name,
    required String quantity,
    required String category,
    String notes = '',
  }) {
    final newItem = GroceryItem(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      quantity: quantity,
      category: category,
      notes: notes,
      isPurchased: false,
    );
    groceryItems.add(newItem);
  }

  void clearPurchased() {
    groceryItems.removeWhere((item) => item.isPurchased);
    Get.snackbar('Cleared', 'Removed all purchased items 🛒');
  }

  void exportList() {
    String listText = '🛒 MY GROCERY LIST\n\n';
    groupedItems.forEach((category, items) {
      listText += '\n📌 $category\n';
      items.where((item) => !item.isPurchased).forEach((item) {
        listText += '• ${item.name} (${item.quantity})';
        if (item.notes.isNotEmpty) listText += ' - ${item.notes}';
        listText += '\n';
      });
    });

    // Copy to clipboard so it's actually used
    Clipboard.setData(ClipboardData(text: listText));

    Get.snackbar('Exported', 'List copied to clipboard! Paste anywhere.');
  }
}
