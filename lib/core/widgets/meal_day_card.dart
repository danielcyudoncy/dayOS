// core/widgets/meal_day_card.dart
import 'package:day_os/data/models/meal.dart';
import 'package:day_os/data/models/meal_day_plan.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';


class MealDayCard extends StatelessWidget {
  final MealDayPlan dayPlan;

  const MealDayCard({super.key, required this.dayPlan});

  @override
  Widget build(BuildContext context) {
    final isToday =
        DateTime.now().day == dayPlan.date.day &&
        DateTime.now().month == dayPlan.date.month;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isToday ? Colors.orange[100] : Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (isToday)
                  const Icon(Icons.today, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatDay(dayPlan.date),
                  style: FontUtil.titleMedium(
                    fontWeight: FontWeights.bold,
                    color: isToday ? Colors.orange[900] : Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  _getDayName(dayPlan.date),
                  style: FontUtil.bodySmall(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          _buildMealSection('Breakfast', dayPlan.breakfast, Icons.food_bank),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMealSection('Lunch', dayPlan.lunch, Icons.fastfood),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMealSection('Dinner', dayPlan.dinner, Icons.dinner_dining),
        ],
      ),
    );
  }

  Widget _buildMealSection(String label, Meal meal, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FontUtil.bodyLarge(
                    fontWeight: FontWeights.medium,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meal.name,
                  style: FontUtil.bodyMedium(color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${meal.calories} kcal',
                  style: FontUtil.bodySmall(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              meal.isLogged ? Icons.check_circle : Icons.access_time,
              color: meal.isLogged ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              meal.isLogged = !meal.isLogged;
              Get.snackbar(
                meal.isLogged ? 'Logged!' : 'Unlogged',
                meal.isLogged
                    ? '${meal.name} logged as eaten'
                    : '${meal.name} unmarked',
                icon: Icon(
                  meal.isLogged ? Icons.check : Icons.undo,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDay(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _getDayName(DateTime date) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday - 1];
  }
}
