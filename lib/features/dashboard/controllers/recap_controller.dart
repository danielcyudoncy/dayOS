// presentation/controllers/recap_controller.dart
import 'package:get/get.dart';

class RecapController extends GetxController {
  final isLoading = false.obs;
  final meetingCount = 0.obs;
  final mealCount = 0.obs;
  final completedCount = 0.obs;
  final totalTasks = 0.obs;

  final meetingSummaries = <String>[].obs;
  final mealLogs = <String>[].obs;
  final completedTasks = <String>[].obs;
  final tomorrowPreview = <String>[].obs;

  @override
  void onInit() {
    loadRecapData();
    super.onInit();
  }

  Future<void> loadRecapData() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // Mock data
      meetingCount.value = 3;
      mealCount.value = 2;
      completedCount.value = 4;
      totalTasks.value = 6;

      meetingSummaries.value = [
        'Team Sync: Decided on Q3 roadmap. Action: Send budget proposal by Friday.',
        'Client Review: Approved design mockups. Next meeting scheduled for July 15.',
        '1:1 with Manager: Discussed career growth. Set goals for next quarter.',
      ];

      mealLogs.value = [
        'Breakfast: Avocado Toast + Coffee (320 kcal)',
        'Lunch: Quinoa Bowl with Grilled Veggies (480 kcal)',
        // Dinner not logged - will show in suggestions tomorrow
      ];

      completedTasks.value = [
        'Send project proposal to client',
        'Review meeting notes from Team Sync',
        'Buy groceries for meal plan',
        'Call dentist for appointment',
      ];

      tomorrowPreview.value = [
        '9:00 AM: Team Standup (Google Meet)',
        '12:30 PM: Lunch Break',
        '2:00 PM: Client Call (Zoom)',
        '5:00 PM: Gym Session',
        '7:00 PM: Dinner: Salmon + Broccoli',
      ];
    } finally {
      isLoading.value = false;
    }
  }
}
