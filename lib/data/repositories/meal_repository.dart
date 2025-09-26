// data/repositories/meal_repository.dart
import 'package:day_os/data/models/meal.dart';
import 'package:day_os/data/datasources/remote/meal_api_datasource.dart';

abstract class MealRepository {
  Future<List<Meal>> getTodaysMeals();
  Future<void> generateMealPlan(List<String> preferences);
}

class MealRepositoryImpl implements MealRepository {
  final MealAPIDatasource _datasource;

  MealRepositoryImpl(this._datasource);

  @override
  Future<List<Meal>> getTodaysMeals() async {
    return await _datasource.getTodaysMeals();
  }

  @override
  Future<void> generateMealPlan(List<String> preferences) async {
    return await _datasource.fetchMealPlan(preferences);
  }
}
