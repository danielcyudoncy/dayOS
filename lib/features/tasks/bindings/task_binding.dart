// binding/task_binding.dart
import 'package:day_os/features/tasks/controllers/task_controller.dart';
import 'package:get/get.dart';


class TaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController());
  }
}
