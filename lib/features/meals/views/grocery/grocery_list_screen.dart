// presentation/screens/grocery/grocery_list_screen.dart
import 'package:day_os/data/models/grocery_item.dart';
import 'package:day_os/features/meals/controllers/grocery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroceryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: () => _showAddItemDialog(context, controller),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: controller.exportList,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (controller.groceryItems.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your grocery list is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Plan meals first, and we’ll auto-generate your shopping list!',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/meals'),
                    icon: const Icon(Icons.restaurant),
                    label: const Text('Plan Meals'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.groupedItems.keys.length,
          itemBuilder: (context, index) {
            final category = controller.groupedItems.keys.toList()[index];
            final items = controller.groupedItems[category]!;
            return _buildCategorySection(category, items);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.clearPurchased,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete_sweep, size: 30),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<GroceryItem> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${items.length} item${items.length == 1 ? '' : 's'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ...items.map((item) => _buildGroceryItemTile(item)),
        ],
      ),
    );
  }

  Widget _buildGroceryItemTile(GroceryItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: item.isPurchased,
            onChanged: (value) {
              final controller = Get.find<GroceryController>();
              controller.toggleItem(item.id, value ?? false);
            },
            activeColor: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: item.isPurchased
                        ? TextDecoration.lineThrough
                        : null,
                    color: item.isPurchased ? Colors.grey[600] : null,
                  ),
                ),
                if (item.notes.isNotEmpty)
                  Text(
                    item.notes,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Text(
            item.quantity,
            style: TextStyle(
              fontSize: 14,
              color: item.isPurchased ? Colors.grey[500] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, GroceryController controller) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final notesController = TextEditingController();
    String selectedCategory = 'Pantry';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Grocery Item'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (e.g., 2 lbs, 1 pack)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    [
                      'Produce',
                      'Dairy',
                      'Meat & Seafood',
                      'Pantry',
                      'Frozen',
                      'Bakery',
                      'Beverages',
                      'Other',
                    ].map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                controller.addItem(
                  name: nameController.text.trim(),
                  quantity: quantityController.text,
                  category: selectedCategory,
                  notes: notesController.text,
                );
                Navigator.pop(context);
                Get.snackbar('Added', '${nameController.text} to your list ✅');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Produce':
        return Icons.local_florist;
      case 'Dairy':
        return Icons.icecream;
      case 'Meat & Seafood':
        return Icons.set_meal; // fixed here
      case 'Pantry':
        return Icons.kitchen;
      case 'Frozen':
        return Icons.ac_unit;
      case 'Bakery':
        return Icons.local_pizza;
      case 'Beverages':
        return Icons.local_drink;
      default:
        return Icons.category;
    }
  }


  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Produce':
        return Colors.green;
      case 'Dairy':
        return Colors.blue;
      case 'Meat & Seafood':
        return Colors.red;
      case 'Pantry':
        return Colors.orange;
      case 'Frozen':
        return Colors.cyan;
      case 'Bakery':
        return Colors.brown;
      case 'Beverages':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
