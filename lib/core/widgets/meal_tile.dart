// presentation/widgets/meal_tile.dart
import 'package:day_os/data/models/meal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MealTile extends StatelessWidget {
  final Meal meal;

  const MealTile({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final time =
        '${meal.time.hour}:${meal.time.minute.toString().padLeft(2, '0')}';
    final isUpcoming = meal.time.isAfter(DateTime.now());

    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.restaurant, color: Colors.orange, size: 24),
        ),
        title: Text(
          meal.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('$time • ${meal.calories} kcal'),
        trailing: meal.isLogged
            ? const Icon(Icons.check_circle, color: Colors.green)
            : isUpcoming
            ? ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Logged',
                    'Enjoy your meal!',
                    icon: const Icon(Icons.restaurant),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200],
                  foregroundColor: Colors.orange[900],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Log', style: TextStyle(fontSize: 12)),
              )
            : const Icon(Icons.access_time, color: Colors.grey),
      ),
    );
  }
}
