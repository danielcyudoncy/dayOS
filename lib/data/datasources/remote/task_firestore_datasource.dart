// data/datasources/remote/task_firestore_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_os/data/models/task.dart';

class TaskFirestoreDatasource {
  FirebaseFirestore? _firestore;

  TaskFirestoreDatasource() {
    try {
      _firestore = FirebaseFirestore.instance;
      print('TaskFirestoreDatasource initialized with Firestore');
    } catch (e) {
      print('Firebase not available for TaskFirestoreDatasource: $e');
      _firestore = null;
    }
  }

  Future<List<Task>> getTodaysTasks() async {
    try {
      if (_firestore == null) {
        print('Firestore not available');
        return [];
      }

      final snapshot = await _firestore!
          .collection('tasks')
          .where(
            'dueDate',
            isGreaterThanOrEqualTo: DateTime.now().toIso8601String().substring(
              0,
              10,
            ), // Simplified filter
          )
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          id: data['id'],
          title: data['title'] ?? '',
          category: data['category'] ?? 'General',
          priority: data['priority'] ?? 1,
          dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error fetching tasks from Firestore: $e');
      // Return empty list on error - controller will use fallback data
      return [];
    }
  }

  Future<void> addTask(Task task) async {
    try {
      if (_firestore == null) {
        print('Firestore not available');
        return;
      }

      await _firestore!.collection('tasks').doc(task.id.toString()).set({
        'id': task.id,
        'title': task.title,
        'category': task.category,
        'priority': task.priority,
        'dueDate': task.dueDate?.toIso8601String(),
        'isCompleted': task.isCompleted,
      });
    } catch (e) {
      print('Error adding task to Firestore: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      if (_firestore == null) {
        print('Firestore not available');
        return;
      }

      await _firestore!.collection('tasks').doc(task.id.toString()).update({
        'title': task.title,
        'category': task.category,
        'priority': task.priority,
        'dueDate': task.dueDate?.toIso8601String(),
        'isCompleted': task.isCompleted,
      });
    } catch (e) {
      print('Error updating task in Firestore: $e');
    }
  }
}
