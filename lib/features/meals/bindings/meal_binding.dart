// binding/meal_binding.dart
import 'package:day_os/features/meals/controllers/meal_controller.dart';
import 'package:get/get.dart';


class MealBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MealController());
  }
}
