// binding/calendar_binding.dart
import 'package:day_os/features/meetings/controllers/calendar_controller.dart';
import 'package:get/get.dart';


class CalendarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CalendarController());
  }
}
