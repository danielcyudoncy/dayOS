// presentation/controllers/morning_controller.dart
import 'package:get/get.dart';

class MorningController extends GetxController {
  final isLoading = false.obs;
  late String greeting;
  late String location;
  late int temperature;
  late String weatherDescription;
  late String firstMeetingTime;
  late String firstMeetingTitle;
  late String lunchTime;
  late String lunchMeal;
  late String topTask;
  late String personalTime;
  late String personalActivity;
  late String focusTip;

  @override
  void onInit() {
    loadMorningData();
    super.onInit();
  }

  Future<void> loadMorningData() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Time-based greeting
      final hour = DateTime.now().hour;
      if (hour < 12) {
        greeting = 'Good Morning!';
      } else if (hour < 17) {
        greeting = 'Good Afternoon!';
      } else {
        greeting = 'Good Evening!';
      }

      // Mock data
      location = 'San Francisco, CA';
      temperature = 72;
      weatherDescription = 'Sunny with clear skies';

      firstMeetingTime = '10:00 AM';
      firstMeetingTitle = 'Team Standup (Google Meet)';

      lunchTime = '12:30 PM';
      lunchMeal = 'Quinoa Bowl with Grilled Veggies';

      topTask = 'Send project proposal to client';

      personalTime = '6:00 PM';
      personalActivity = 'Evening walk + meditation';

      focusTip =
          'Start with your most important task before noon when your focus is highest. Take a 5-minute break every hour to maintain energy throughout the day.';
    } finally {
      isLoading.value = false;
    }
  }
}
