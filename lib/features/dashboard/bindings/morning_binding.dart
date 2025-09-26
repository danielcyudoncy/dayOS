// binding/morning_binding.dart
import 'package:day_os/features/dashboard/controllers/morning_controller.dart';
import 'package:get/get.dart';


class MorningBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MorningController());
  }
}
