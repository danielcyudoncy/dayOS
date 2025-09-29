// routes/app_pages.dart
import 'package:day_os/features/ai_assistant/bindings/ai_binding.dart';
import 'package:day_os/features/auth/bindings/auth_binding.dart';
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
import 'package:day_os/core/widgets/splash_screen.dart';
import 'package:day_os/core/widgets/onboarding_screen.dart';
import 'package:day_os/core/widgets/sign_in_screen.dart';
import 'package:day_os/core/widgets/sign_up_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
   static const splash = '/splash';
   static const onboarding = '/onboarding';
   static const signin = '/signin';
   static const signup = '/signup';
   static const home = '/';
   static const ai_command = '/ai';
   static const calendar = '/calendar';
   static const meals = '/meals';
   static const grocery = '/grocery';
   static const tasks = '/tasks';
   static const recap = '/recap';
   static const morning = '/morning';
   static const settings = '/settings';
 }

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => const SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.ai_command,
      page: () => const AICommandScreen(),
      binding: AIBinding(),
    ),
    GetPage(
      name: AppRoutes.calendar,
      page: () => const CalendarScreen(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.meals,
      page: () => const MealPlannerScreen(),
      binding: MealBinding(),
    ),
    GetPage(
      name: AppRoutes.grocery,
      page: () => const GroceryListScreen(),
      binding: GroceryBinding(),
    ),
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskManagerScreen(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: AppRoutes.recap,
      page: () => const EveningRecapScreen(),
      binding: RecapBinding(),
    ),
    GetPage(
      name: AppRoutes.morning,
      page: () => const MorningBriefingScreen(),
      binding: MorningBinding(), // NEW
    ),
     GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(), // NEW
    ),
  ];
}
