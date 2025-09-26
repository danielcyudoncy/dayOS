// binding/ai_binding.dart
import 'package:day_os/features/ai_assistant/controllers/ai_controller.dart';
import 'package:get/get.dart';


class AIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AIController());
  }
}
