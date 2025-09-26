// binding/recap_binding.dart
import 'package:day_os/features/dashboard/controllers/recap_controller.dart';
import 'package:get/get.dart';


class RecapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecapController());
  }
}
