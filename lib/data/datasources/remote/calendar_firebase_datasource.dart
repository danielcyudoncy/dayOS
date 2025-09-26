// data/datasources/remote/calendar_firebase_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_os/data/models/meeting.dart';
import 'package:day_os/core/utils/google_calendar_service.dart';

class CalendarFirebaseDatasource {
  FirebaseFirestore? _firestore;
  final GoogleCalendarService _googleCalendarService = GoogleCalendarService();

  CalendarFirebaseDatasource() {
    try {
      _firestore = FirebaseFirestore.instance;
      print('CalendarFirebaseDatasource initialized with Firestore');
    } catch (e) {
      print('Firebase not available for CalendarFirebaseDatasource: $e');
      _firestore = null;
    }
  }

  Future<List<Meeting>> getTodaysMeetings(DateTime day) async {
    try {
      // Try to get meetings from Google Calendar first
      if (_googleCalendarService.isSignedIn) {
        final googleMeetings = await _googleCalendarService.getTodaysEvents();
        return googleMeetings;
      }
    } catch (e) {
      print('Error fetching from Google Calendar: $e');
    }

    // Fallback to Firestore if Google Calendar is not available
    try {
      if (_firestore == null) {
        print('Firestore not available');
        return [];
      }

      final snapshot = await _firestore!
          .collection('meetings')
          .where('date', isEqualTo: day.toIso8601String().substring(0, 10))
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Meeting(
          id: doc.id,
          title: data['title'] ?? '',
          startTime: DateTime.parse(data['startTime']),
          platform: data['platform'] ?? '',
          durationMinutes: data['durationMinutes'] ?? 30,
          description: data['description'],
          location: data['location'],
          organizer: data['organizer'],
          isAllDay: data['isAllDay'] ?? false,
          googleEventId: data['googleEventId'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching meetings from Firestore: $e');
      // Return empty list on error - controller will use fallback data
      return [];
    }
  }

  Future<void> syncWithGoogleCalendar() async {
    try {
      // Sign in to Google Calendar if not already signed in
      if (!_googleCalendarService.isSignedIn) {
        final signedIn = await _googleCalendarService.signIn();
        if (!signedIn) {
          throw Exception('Failed to sign in to Google Calendar');
        }
      }

      // Get all meetings from Firestore
      if (_firestore == null) {
        print('Firestore not available for sync');
        return;
      }
      final snapshot = await _firestore!.collection('meetings').get();
      final firestoreMeetings = snapshot.docs.map((doc) {
        final data = doc.data();
        return Meeting(
          id: doc.id,
          title: data['title'] ?? '',
          startTime: DateTime.parse(data['startTime']),
          platform: data['platform'] ?? '',
          durationMinutes: data['durationMinutes'] ?? 30,
          description: data['description'],
          location: data['location'],
          organizer: data['organizer'],
          isAllDay: data['isAllDay'] ?? false,
          googleEventId: data['googleEventId'],
        );
      }).toList();

      // Sync each meeting with Google Calendar
      for (final meeting in firestoreMeetings) {
        await _syncMeetingToGoogleCalendar(meeting);
      }

      // Get events from Google Calendar and sync to Firestore
      final googleEvents = await _googleCalendarService.getTodaysEvents();
      for (final event in googleEvents) {
        await _syncGoogleEventToFirestore(event);
      }

      print('Google Calendar sync completed successfully');
    } catch (e) {
      print('Error during Google Calendar sync: $e');
      throw Exception('Failed to sync with Google Calendar: $e');
    }
  }

  Future<void> _syncMeetingToGoogleCalendar(Meeting meeting) async {
    try {
      if (meeting.googleEventId != null && meeting.googleEventId!.isNotEmpty) {
        // Update existing event
        await _googleCalendarService.updateEvent(meeting.googleEventId!, meeting);
      } else {
        // Create new event
        final eventId = await _googleCalendarService.createEvent(meeting);
        if (eventId != null && _firestore != null) {
          // Update Firestore with Google event ID
          await _firestore!.collection('meetings').doc(meeting.id).update({
            'googleEventId': eventId,
          });
        }
      }
    } catch (e) {
      print('Error syncing meeting to Google Calendar: $e');
    }
  }

  Future<void> _syncGoogleEventToFirestore(Meeting event) async {
    try {
      // Check if event already exists in Firestore
      if (_firestore == null) {
        print('Firestore not available for sync check');
        return;
      }
      final existingSnapshot = await _firestore!
          .collection('meetings')
          .where('googleEventId', isEqualTo: event.googleEventId)
          .get();

      if (existingSnapshot.docs.isEmpty && _firestore != null) {
        // Create new meeting in Firestore
        await _firestore!.collection('meetings').add({
          'title': event.title,
          'startTime': event.startTime.toIso8601String(),
          'platform': event.platform,
          'durationMinutes': event.durationMinutes,
          'description': event.description,
          'location': event.location,
          'organizer': event.organizer,
          'isAllDay': event.isAllDay,
          'googleEventId': event.googleEventId,
          'date': event.startTime.toIso8601String().substring(0, 10),
        });
      }
    } catch (e) {
      print('Error syncing Google event to Firestore: $e');
    }
  }

  Future<bool> signInToGoogle() async {
    return await _googleCalendarService.signIn();
  }

  Future<bool> signOutFromGoogle() async {
    return await _googleCalendarService.signOut();
  }

  bool get isSignedInToGoogle => _googleCalendarService.isSignedIn;
}
