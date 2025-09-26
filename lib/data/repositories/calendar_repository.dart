// data/repositories/calendar_repository.dart
import 'package:day_os/data/models/meeting.dart';
import 'package:day_os/data/datasources/remote/calendar_firebase_datasource.dart';

abstract class CalendarRepository {
  Future<List<Meeting>> getTodaysMeetings();
  Future<void> syncCalendar();
}

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarFirebaseDatasource _datasource;

  CalendarRepositoryImpl(this._datasource);

  @override
  Future<List<Meeting>> getTodaysMeetings() async {
    final now = DateTime.now();
    return await _datasource.getTodaysMeetings(now);
  }

  @override
  Future<void> syncCalendar() async {
    return await _datasource.syncWithGoogleCalendar();
  }
}
