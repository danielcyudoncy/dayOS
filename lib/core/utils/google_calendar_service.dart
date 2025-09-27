// core/utils/google_calendar_service.dart

import 'package:day_os/data/models/meeting.dart';

class GoogleCalendarService {
  // Temporarily simplified to avoid Google Sign-In API compatibility issues
  // TODO: Update to use newer Google Sign-In API when ready

  Future<bool> signIn() async {
    print('Google Calendar sign-in temporarily disabled');
    return false;
  }

  Future<bool> signOut() async {
    print('Google Calendar sign-out temporarily disabled');
    return true;
  }

  bool get isSignedIn => false;

  Future<List<Meeting>> getTodaysEvents() async {
    print('Google Calendar events temporarily disabled');
    return [];
  }

  Future<String?> createEvent(Meeting meeting) async {
    print('Google Calendar event creation temporarily disabled');
    return null;
  }

  Future<bool> updateEvent(String eventId, Meeting meeting) async {
    print('Google Calendar event update temporarily disabled');
    return false;
  }

  Future<bool> deleteEvent(String eventId) async {
    print('Google Calendar event deletion temporarily disabled');
    return false;
  }
}