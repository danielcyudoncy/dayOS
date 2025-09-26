// binding/grocery_binding.dart
import 'package:day_os/features/meals/controllers/grocery_controller.dart';
import 'package:get/get.dart';


class GroceryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroceryController());
  }
}
