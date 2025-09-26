// domain/entities/meal.dart
class Meal {
  final String name;
  final DateTime time;
  final int calories;
   bool isLogged;

  Meal({
    required this.name,
    required this.time,
    required this.calories,
    required this.isLogged,
  });
}
