// binding/settings_binding.dart
import 'package:day_os/features/dashboard/controllers/settings_controller.dart';
import 'package:get/get.dart';


class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
