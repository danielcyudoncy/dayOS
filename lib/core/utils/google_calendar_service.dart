// services/google_calendar_service.dart

import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:day_os/data/models/meeting.dart';

class GoogleCalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  GoogleSignInAccount? _currentUser;
  calendar.CalendarApi? _calendarApi;

  Future<bool> signIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        _currentUser = user;
        final client = await _googleSignIn.authenticatedClient();
        if (client != null) {
          _calendarApi = calendar.CalendarApi(client);
          return true;
        }
      }
      return false;
    } catch (error) {
      print('Error signing in to Google: $error');
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _calendarApi = null;
      return true;
    } catch (error) {
      print('Error signing out from Google: $error');
      return false;
    }
  }

  bool get isSignedIn => _currentUser != null && _calendarApi != null;

  Future<List<Meeting>> getTodaysEvents() async {
    if (!isSignedIn || _calendarApi == null) {
      print('Google Calendar sync failed: User not signed in');
      throw Exception('User not signed in to Google Calendar');
    }

    try {
      print('Fetching Google Calendar events for today...');
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final events = await _calendarApi!.events.list(
        'primary',
        timeMin: startOfDay.toUtc(),
        timeMax: endOfDay.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      final meetings = events.items?.map((event) {
        final start = event.start?.dateTime ?? event.start?.date;
        final end = event.end?.dateTime ?? event.end?.date;

        DateTime startTime;
        int durationMinutes = 30; // default

        if (start != null) {
          startTime = start.toLocal();
          if (end != null) {
            durationMinutes = end.difference(startTime).inMinutes;
            if (durationMinutes <= 0) {
              durationMinutes = 30; // fallback for invalid durations
            }
          }
        } else {
          startTime = now; // fallback
        }

        return Meeting(
          title: event.summary ?? 'Untitled Event',
          startTime: startTime,
          platform: 'Google Calendar',
          durationMinutes: durationMinutes,
          description: event.description,
          location: event.location,
          organizer: event.organizer?.displayName ?? event.organizer?.email,
          isAllDay: event.start?.date != null && event.end?.date != null,
          googleEventId: event.id,
        );
      }).toList() ?? [];

      print('Successfully fetched ${meetings.length} events from Google Calendar');
      return meetings;
    } catch (error) {
      print('Error fetching Google Calendar events: $error');
      throw Exception('Failed to fetch calendar events: $error');
    }
  }

  Future<String?> createEvent(Meeting meeting) async {
    if (!isSignedIn || _calendarApi == null) {
      throw Exception('User not signed in to Google Calendar');
    }

    try {
      final endTime = meeting.startTime.add(Duration(minutes: meeting.durationMinutes));

      final event = calendar.Event()
        ..summary = meeting.title
        ..start = calendar.EventDateTime(dateTime: meeting.startTime.toUtc())
        ..end = calendar.EventDateTime(dateTime: endTime.toUtc());

      final createdEvent = await _calendarApi!.events.insert(event, 'primary');
      return createdEvent.id;
    } catch (error) {
      print('Error creating Google Calendar event: $error');
      throw Exception('Failed to create calendar event: $error');
    }
  }

  Future<bool> updateEvent(String eventId, Meeting meeting) async {
    if (!isSignedIn || _calendarApi == null) {
      throw Exception('User not signed in to Google Calendar');
    }

    try {
      final endTime = meeting.startTime.add(Duration(minutes: meeting.durationMinutes));

      final event = calendar.Event()
        ..summary = meeting.title
        ..start = calendar.EventDateTime(dateTime: meeting.startTime.toUtc())
        ..end = calendar.EventDateTime(dateTime: endTime.toUtc());

      await _calendarApi!.events.update(event, 'primary', eventId);
      return true;
    } catch (error) {
      print('Error updating Google Calendar event: $error');
      throw Exception('Failed to update calendar event: $error');
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    if (!isSignedIn || _calendarApi == null) {
      throw Exception('User not signed in to Google Calendar');
    }

    try {
      await _calendarApi!.events.delete('primary', eventId);
      return true;
    } catch (error) {
      print('Error deleting Google Calendar event: $error');
      throw Exception('Failed to delete calendar event: $error');
    }
  }
}