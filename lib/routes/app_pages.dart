// routes/app_pages.dart
import 'package:day_os/features/ai_assistant/bindings/ai_binding.dart';
import 'package:day_os/features/meetings/bindings/calendar_binding.dart';
import 'package:day_os/features/meals/bindings/grocery_binding.dart';
import 'package:day_os/features/dashboard/bindings/home_binding.dart';
import 'package:day_os/features/meals/bindings/meal_binding.dart';
import 'package:day_os/features/dashboard/bindings/morning_binding.dart';
import 'package:day_os/features/dashboard/bindings/recap_binding.dart';
import 'package:day_os/features/dashboard/bindings/settings_binding.dart';
import 'package:day_os/features/tasks/bindings/task_binding.dart';
import 'package:day_os/features/ai_assistant/views/ai_assistant/ai_command_screen.dart';
import 'package:day_os/features/meetings/views/calendar/calendar_screen.dart';
import 'package:day_os/features/meals/views/grocery/grocery_list_screen.dart';
import 'package:day_os/features/dashboard/views/home/home_screen.dart';
import 'package:day_os/features/meals/views/meals/meal_planner_screen.dart';
import 'package:day_os/features/dashboard/views/morning/morning_briefing_screen.dart';
import 'package:day_os/features/dashboard/views/recap/evening_recap_screen.dart';
import 'package:day_os/features/dashboard/views/settings/settings_screen.dart';
import 'package:day_os/features/tasks/views/tasks/task_manager_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const HOME = '/';
  static const AI_COMMAND = '/ai';
  static const CALENDAR = '/calendar';
  static const MEALS = '/meals';
  static const GROCERY = '/grocery';
  static const TASKS = '/tasks';
  static const RECAP = '/recap';
  static const MORNING = '/morning';
  static const SETTINGS = '/settings';  // NEW
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.AI_COMMAND,
      page: () => const AICommandScreen(),
      binding: AIBinding(),
    ),
    GetPage(
      name: AppRoutes.CALENDAR,
      page: () => const CalendarScreen(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.MEALS,
      page: () => const MealPlannerScreen(),
      binding: MealBinding(),
    ),
    GetPage(
      name: AppRoutes.GROCERY,
      page: () => const GroceryListScreen(),
      binding: GroceryBinding(),
    ),
    GetPage(
      name: AppRoutes.TASKS,
      page: () => const TaskManagerScreen(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: AppRoutes.RECAP,
      page: () => const EveningRecapScreen(),
      binding: RecapBinding(),
    ),
    GetPage(
      name: AppRoutes.MORNING,
      page: () => const MorningBriefingScreen(),
      binding: MorningBinding(), // NEW
    ),
     GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(), // NEW
    ),
  ];
}
