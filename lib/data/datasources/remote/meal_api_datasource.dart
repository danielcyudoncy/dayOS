// data/datasources/remote/meal_api_datasource.dart
import 'package:day_os/data/models/meal.dart';

class MealAPIDatasource {
  Future<List<Meal>> getTodaysMeals() async {
    // TODO: Replace with actual API call
    return [
      Meal(
        name: 'Avocado Toast + Coffee',
        calories: 320,
        time: DateTime.now().add(const Duration(minutes: -60)),
        isLogged: true,
      ),
      Meal(
        name: 'Quinoa Bowl with Grilled Veggies',
        calories: 480,
        time: DateTime.now().add(const Duration(minutes: 90)),
        isLogged: false,
      ),
    ];
  }

  Future<void> fetchMealPlan(List<String> preferences) async {
    // TODO: Replace with real API integration
    await Future.delayed(const Duration(seconds: 1));
  }
}
