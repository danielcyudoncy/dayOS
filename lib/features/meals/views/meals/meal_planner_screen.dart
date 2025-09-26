// presentation/screens/meals/meal_planner_screen.dart
import 'package:day_os/features/meals/controllers/meal_controller.dart';
import 'package:day_os/core/widgets/meal_day_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MealController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            onPressed: () => _showDietaryPreferencesDialog(context, controller),
            icon: const Icon(Icons.restaurant_menu),
          ),
          IconButton(
            onPressed: controller.generateMealPlan,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(controller.error.value),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.generateMealPlan,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildHeader(controller),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.weeklyPlan.length,
                itemBuilder: (context, index) {
                  return MealDayCard(dayPlan: controller.weeklyPlan[index]);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/grocery'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.shopping_cart, size: 30),
      ),
    );
  }

  Widget _buildHeader(MealController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border(bottom: BorderSide(color: Colors.orange[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dietary Preferences',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                controller.dietaryPrefs.join(', '),
                style: const TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () =>
                _showDietaryPreferencesDialog(Get.context!, controller),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[200],
              foregroundColor: Colors.orange[900],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDietaryPreferencesDialog(
    BuildContext context,
    MealController controller,
  ) {
    List<String> allPrefs = [
      'Vegetarian',
      'Vegan',
      'Gluten-Free',
      'Dairy-Free',
      'Keto',
      'Low-Carb',
      'High-Protein',
    ];
    List<String> selected = List.from(controller.dietaryPrefs);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dietary Preferences'),
        content: SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allPrefs.map((pref) {
              bool isSelected = selected.contains(pref);
              return FilterChip(
                label: Text(pref),
                selected: isSelected,
                onSelected: (value) {
                  if (value) {
                    selected.add(pref);
                  } else {
                    selected.remove(pref);
                  }
                },
                backgroundColor: isSelected
                    ? Colors.orange[100]
                    : Colors.grey[200],
                selectedColor: Colors.orange[200],
                checkmarkColor: Colors.orange,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateDietaryPreferences(selected);
              Navigator.pop(context);
              Get.snackbar('Updated', 'Preferences saved ✅');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
