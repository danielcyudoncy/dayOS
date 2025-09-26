// domain/entities/task.dart
class Task {
  int id;
  String title;
  String notes;
  String category; // 'Work' or 'Personal'
  int priority; // 1 (high) to 3 (low)
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.notes = '',
    this.category = 'Personal',
    this.priority = 1,
    this.dueDate,
    this.isCompleted = false,
  });
}