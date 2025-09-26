// domain/entities/meeting.dart
class Meeting {
  final String id;
  final String title;
  final DateTime startTime;
  final String platform;
  final int durationMinutes;
  final String? description;
  final String? location;
  final String? organizer;
  final bool isAllDay;
  final String? googleEventId; // For Google Calendar sync

  Meeting({
    this.id = '',
    required this.title,
    required this.startTime,
    required this.platform,
    required this.durationMinutes,
    this.description,
    this.location,
    this.organizer,
    this.isAllDay = false,
    this.googleEventId,
  });

  Meeting copyWith({
    String? id,
    String? title,
    DateTime? startTime,
    String? platform,
    int? durationMinutes,
    String? description,
    String? location,
    String? organizer,
    bool? isAllDay,
    String? googleEventId,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      platform: platform ?? this.platform,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      description: description ?? this.description,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      isAllDay: isAllDay ?? this.isAllDay,
      googleEventId: googleEventId ?? this.googleEventId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'platform': platform,
      'durationMinutes': durationMinutes,
      'description': description,
      'location': location,
      'organizer': organizer,
      'isAllDay': isAllDay,
      'googleEventId': googleEventId,
    };
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      platform: map['platform'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 30,
      description: map['description'],
      location: map['location'],
      organizer: map['organizer'],
      isAllDay: map['isAllDay'] ?? false,
      googleEventId: map['googleEventId'],
    );
  }
}
