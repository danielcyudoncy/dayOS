// data/repositories/task_repository.dart
import 'package:day_os/data/models/task.dart';
import 'package:day_os/data/datasources/remote/task_firestore_datasource.dart';

abstract class TaskRepository {
  Future<List<Task>> getTodaysTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskFirestoreDatasource _datasource;

  TaskRepositoryImpl(this._datasource);

  @override
  Future<List<Task>> getTodaysTasks() async {
    return await _datasource.getTodaysTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    return await _datasource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    return await _datasource.updateTask(task);
  }
}
