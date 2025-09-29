// data/di/di.dart
import 'package:day_os/data/datasources/remote/calendar_firebase_datasource.dart';
import 'package:day_os/data/repositories/calendar_repository.dart';
import 'package:day_os/data/datasources/remote/meal_api_datasource.dart';
import 'package:day_os/data/repositories/meal_repository.dart';
import 'package:day_os/data/datasources/remote/task_firestore_datasource.dart';
import 'package:day_os/data/repositories/task_repository.dart';
import 'package:day_os/core/utils/ai_service.dart';
import 'package:day_os/core/utils/auth_service.dart';
import 'package:day_os/features/auth/bindings/auth_binding.dart';
import 'package:get/get.dart';

Future<void> initDependencies() async {
  // Datasources
  Get.put(CalendarFirebaseDatasource());
  Get.put(MealAPIDatasource());
  Get.put(TaskFirestoreDatasource());

  // Repositories - using the correct implementation classes
  Get.put<CalendarRepository>(CalendarRepositoryImpl(Get.find<CalendarFirebaseDatasource>()));
  Get.put<MealRepository>(MealRepositoryImpl(Get.find<MealAPIDatasource>()));
  Get.put<TaskRepository>(TaskRepositoryImpl(Get.find<TaskFirestoreDatasource>()));

  // Services (e.g., AI, Auth)
  Get.put(AIService());
  Get.put(AuthService());

  // Bindings
  AuthBinding().dependencies();
}