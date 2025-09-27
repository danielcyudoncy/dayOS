// features/meetings/controllers/calendar_controller.dart
import 'package:day_os/data/models/meeting.dart';
import 'package:day_os/data/repositories/calendar_repository.dart';
import 'package:day_os/data/datasources/remote/calendar_firebase_datasource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarController extends GetxController {
  final CalendarRepository _repository = Get.find<CalendarRepository>();

  final isLoading = false.obs;
  final error = ''.obs;
  final meetings = <Meeting>[].obs;
  final notifyBeforeMeeting = true.obs;
  final autoJoin = true.obs;
  final isSignedInToGoogle = false.obs;

  @override
  void onInit() {
    loadMeetings();
    checkGoogleSignInStatus();
    super.onInit();
  }

  Future<void> loadMeetings() async {
    isLoading.value = true;
    error.value = '';

    try {
      final todaysMeetings = await _repository.getTodaysMeetings();
      meetings.value = todaysMeetings;
    } catch (e) {
      error.value = 'Failed to load meetings. Please check your connection.';
      print('Error loading meetings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncCalendars() async {
    isLoading.value = true;
    error.value = '';

    try {
      await _repository.syncCalendar();
      await loadMeetings(); // Reload meetings after sync
      Get.snackbar(
        'Synced!',
        'Calendar updated successfully ✅',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } catch (e) {
      error.value = 'Sync failed. Please try again.';
      print('Error syncing calendars: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInToGoogle() async {
    try {
      final signedIn = await Get.find<CalendarFirebaseDatasource>().signInToGoogle();
      isSignedInToGoogle.value = signedIn;
      if (signedIn) {
        Get.snackbar(
          'Success!',
          'Signed in to Google Calendar',
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        await loadMeetings(); // Reload meetings after sign in
      } else {
        Get.snackbar(
          'Failed',
          'Failed to sign in to Google Calendar',
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      print('Error signing in to Google: $e');
      Get.snackbar(
        'Error',
        'Failed to sign in to Google Calendar',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  Future<void> signOutFromGoogle() async {
    try {
      final signedOut = await Get.find<CalendarFirebaseDatasource>().signOutFromGoogle();
      isSignedInToGoogle.value = !signedOut;
      if (signedOut) {
        Get.snackbar(
          'Success!',
          'Signed out from Google Calendar',
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        await loadMeetings(); // Reload meetings after sign out
      }
    } catch (e) {
      print('Error signing out from Google: $e');
    }
  }

  void checkGoogleSignInStatus() {
    isSignedInToGoogle.value = Get.find<CalendarFirebaseDatasource>().isSignedInToGoogle;
  }

  void toggleNotification(bool value) => notifyBeforeMeeting.value = value;
  void toggleAutoJoin(bool value) => autoJoin.value = value;
}
