// features/meals/views/meals/meal_planner_screen.dart
import 'package:day_os/features/meals/controllers/meal_controller.dart';
import 'package:day_os/core/widgets/app_drawer.dart';
import 'package:day_os/core/widgets/meal_day_card.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MealController>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Meal Planner', style: FontUtil.headlineSmall(color: Colors.white, fontWeight: FontWeights.semiBold)),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showDietaryPreferencesDialog(context, controller),
            icon: const Icon(Icons.restaurant_menu, color: Colors.white),
          ),
          IconButton(
            onPressed: controller.generateMealPlan,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e), // Dark background
              Color(0xFF8B5CF6), // Purple
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    controller.error.value,
                    style: FontUtil.bodyLarge(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.generateMealPlan,
                    icon: const Icon(Icons.refresh, color: Color(0xFF1a1a2e)),
                    label: Text('Retry', style: FontUtil.bodyMedium(color: const Color(0xFF1a1a2e))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1a1a2e),
                    ),
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
      ),
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
        color: Colors.white.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dietary Preferences',
                style: FontUtil.titleLarge(color: Colors.white, fontWeight: FontWeights.semiBold),
              ),
              const SizedBox(height: 4),
              Text(
                controller.dietaryPrefs.join(', '),
                style: FontUtil.bodySmall(color: Colors.grey[100]),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () =>
                _showDietaryPreferencesDialog(Get.context!, controller),
            icon: const Icon(Icons.edit, size: 16, color: Color(0xFF1a1a2e)),
            label: Text('Edit', style: FontUtil.bodySmall(color: const Color(0xFF1a1a2e))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1a1a2e),
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
              Get.snackbar(
                'Updated',
                'Preferences saved ✅',
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
