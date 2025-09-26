// features/dashboard/bindings/home_binding.dart
import 'package:day_os/data/repositories/calendar_repository.dart';
import 'package:day_os/data/repositories/meal_repository.dart';
import 'package:day_os/data/repositories/task_repository.dart';
import 'package:day_os/features/dashboard/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Inject controller (per screen) - repositories will be injected via constructor
    Get.lazyPut(() => HomeController(
      Get.find<CalendarRepository>(),
      Get.find<MealRepository>(),
      Get.find<TaskRepository>(),
    ));
  }
}