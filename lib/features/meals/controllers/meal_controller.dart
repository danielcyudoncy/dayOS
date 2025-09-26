// presentation/controllers/meal_controller.dart
import 'package:day_os/data/models/meal.dart';
import 'package:day_os/data/models/meal_day_plan.dart';
import 'package:get/get.dart';


class MealController extends GetxController {
  final isLoading = false.obs;
  final error = ''.obs;
  final weeklyPlan = <MealDayPlan>[].obs;
  final dietaryPrefs = <String>[].obs;

  @override
  void onInit() {
    dietaryPrefs.value = ['Vegetarian', 'High-Protein'];
    generateMealPlan();
    super.onInit();
  }

  Future<void> generateMealPlan() async {
    isLoading.value = true;
    error.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      weeklyPlan.value = List.generate(7, (index) {
        final day = DateTime.now().add(Duration(days: index));
        return MealDayPlan(
          date: day,
          breakfast: _generateMeal('Breakfast', index, dietaryPrefs),
          lunch: _generateMeal('Lunch', index, dietaryPrefs),
          dinner: _generateMeal('Dinner', index, dietaryPrefs),
        );
      });
    } catch (e) {
      error.value = 'Failed to generate meal plan. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void updateDietaryPreferences(List<String> prefs) {
    dietaryPrefs.value = prefs;
    generateMealPlan(); // Regenerate based on new prefs
  }

  Meal _generateMeal(String mealType, int dayOffset, List<String> prefs) {
    final random = (dayOffset * 7) % 5; // deterministic "random"
    final baseOptions = {
      'Breakfast': [
        'Greek Yogurt + Berries + Granola',
        'Avocado Toast + Poached Egg',
        'Oatmeal + Banana + Almond Butter',
        'Smoothie Bowl + Chia Seeds',
        'Tofu Scramble + Whole Wheat Toast',
      ],
      'Lunch': [
        'Quinoa Bowl + Grilled Veggies',
        'Chickpea Salad Wrap',
        'Lentil Soup + Whole Grain Bread',
        'Brown Rice + Black Beans + Salsa',
        'Kale Salad + Roasted Sweet Potatoes',
      ],
      'Dinner': [
        'Grilled Salmon + Quinoa + Asparagus',
        'Stir-Fried Tofu + Brown Rice + Broccoli',
        'Chickpea Curry + Basmati Rice',
        'Stuffed Bell Peppers + Side Salad',
        'Lentil Bolognese + Zucchini Noodles',
      ],
    };

    final options = baseOptions[mealType]!;
    String mealName = options[random];

    // Adjust based on dietary prefs
    if (prefs.contains('Vegan') && mealName.contains('Egg')) {
      mealName = mealName.replaceAll('Poached Egg', 'Tofu');
    }
    if (prefs.contains('Gluten-Free') && mealName.contains('Toast')) {
      mealName = mealName.replaceAll('Toast', 'Gluten-Free Toast');
    }
    if (prefs.contains('Keto')) {
      if (mealType == 'Breakfast') {
        mealName = 'Scrambled Eggs + Avocado + Bacon';
      }
      if (mealType == 'Lunch') {
        mealName = 'Grilled Chicken + Caesar Salad (no croutons)';
      }
      if (mealType == 'Dinner') {
        mealName = 'Ribeye Steak + Garlic Butter Asparagus';
      }
    }

    return Meal(
      name: mealName,
      time: DateTime.now().add(Duration(days: dayOffset)),
      calories: _estimateCalories(mealType, prefs),
      isLogged: false,
    );
  }

  int _estimateCalories(String mealType, List<String> prefs) {
    if (prefs.contains('Keto')) {
      return {'Breakfast': 450, 'Lunch': 600, 'Dinner': 750}[mealType] ?? 500;
    } else if (prefs.contains('Low-Carb')) {
      return {'Breakfast': 300, 'Lunch': 400, 'Dinner': 500}[mealType] ?? 400;
    } else {
      return {'Breakfast': 350, 'Lunch': 500, 'Dinner': 600}[mealType] ?? 450;
    }
  }
}
