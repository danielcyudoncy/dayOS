// domain/entities/meal_day_plan.dart
import 'package:day_os/data/models/meal.dart';


class MealDayPlan {
  final DateTime date;
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  MealDayPlan({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}
