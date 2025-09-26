// presentation/controllers/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Integrations
  final googleConnected = true.obs;
  final outlookConnected = true.obs;
  final zoomConnected = true.obs;
  final teamsConnected = false.obs;

  // Wellness
  final dietaryPrefs = <String>['Vegetarian', 'High-Protein'].obs;
  final mealRemindersEnabled = true.obs;
  final workStart = 9.obs;
  final workEnd = 17.obs;

  // AI Assistant
  final aiPersonality = 'Professional'.obs;
  final meetingSummariesEnabled = true.obs;
  final voiceCommandsEnabled = true.obs;

  // Privacy & Notifications
  final notificationsEnabled = true.obs;
  final meetingRecordingEnabled = false.obs;

  /// Toggle any integration (google/outlook/zoom/teams)
  void toggleIntegration(String service) {
    final map = <String, RxBool>{
      'google': googleConnected,
      'outlook': outlookConnected,
      'zoom': zoomConnected,
      'teams': teamsConnected,
    };

    final target = map[service];
    if (target == null) return;

    target.value = !target.value;

    // Manual capitalization to avoid extension ambiguity
    final label = service.isNotEmpty
        ? '${service[0].toUpperCase()}${service.substring(1)}'
        : service;

    Get.snackbar(
      'Updated',
      '$label ${target.value ? 'connected' : 'disconnected'}',
      icon: Icon(
        target.value ? Icons.check_circle : Icons.cancel,
        color: target.value ? Colors.green : Colors.red,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void updateDietaryPreferences(List<String> preferences) {
    dietaryPrefs.value = preferences;
  }

  void toggleMealReminders() {
    mealRemindersEnabled.value = !mealRemindersEnabled.value;
  }

  void updateWorkHours(int start, int end) {
    workStart.value = start;
    workEnd.value = end;
  }

  void updateAIPersonality(String personality) {
    aiPersonality.value = personality;
  }

  void toggleMeetingSummaries() {
    meetingSummariesEnabled.value = !meetingSummariesEnabled.value;
  }

  void toggleVoiceCommands() {
    voiceCommandsEnabled.value = !voiceCommandsEnabled.value;
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  void toggleMeetingRecording() {
    meetingRecordingEnabled.value = !meetingRecordingEnabled.value;
  }

  void signOut() {
    Get.snackbar('Signed Out', 'You have been signed out successfully');
    // Add real sign-out logic here (Firebase Auth, clearing local state, etc.)
  }
}
