// features/dashboard/bindings/settings_binding.dart
import 'package:day_os/features/dashboard/controllers/settings_controller.dart';
import 'package:day_os/features/auth/bindings/auth_binding.dart';
import 'package:get/get.dart';


class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies(); // Ensure AuthController is available
    Get.lazyPut(() => SettingsController());
  }
}
