// features/tasks/controllers/task_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:day_os/data/models/task.dart';

class TaskController extends GetxController {
  final isLoading = false.obs;
  final allTasks = <Task>[].obs;

  List<Task> get workTasks => allTasks
      .where((task) => task.category == 'Work' && !task.isCompleted)
      .toList();
  List<Task> get personalTasks => allTasks
      .where((task) => task.category == 'Personal' && !task.isCompleted)
      .toList();
  List<Task> get completedTasks =>
      allTasks.where((task) => task.isCompleted).toList();

  @override
  void onInit() {
    // Load mock tasks
    allTasks.value = [
      Task(
        id: 1,
        title: 'Send project proposal to client',
        category: 'Work',
        priority: 2,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
      ),
      Task(
        id: 2,
        title: 'Review meeting notes from Team Sync',
        category: 'Work',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(hours: 4)),
        isCompleted: true,
      ),
      Task(
        id: 3,
        title: 'Buy groceries for meal plan',
        category: 'Personal',
        priority: 3,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
      ),
      Task(
        id: 4,
        title: 'Call dentist for appointment',
        category: 'Personal',
        priority: 1,
        dueDate: null,
        isCompleted: false,
      ),
    ];
    super.onInit();
  }

  Future<void> refreshTasks() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    isLoading.value = false;
  }

  void addTask({
    required String title,
    String notes = '',
    required String category,
    required int priority,
    DateTime? dueDate,
  }) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      notes: notes,
      category: category,
      priority: priority,
      dueDate: dueDate,
      isCompleted: false,
    );
    allTasks.add(newTask);
  }

  void toggleTask(int id) {
    final index = allTasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      allTasks[index].isCompleted = !allTasks[index].isCompleted;
      if (allTasks[index].isCompleted) {
        Get.snackbar(
          'Completed!',
          allTasks[index].title,
          icon: const Icon(Icons.check, color: Colors.black),
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      }
      allTasks.refresh();
    }
  }

  void deleteTask(int id) {
    allTasks.removeWhere((task) => task.id == id);
    Get.snackbar(
      'Deleted',
      'Task removed 🗑️',
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }

  void generateFromMeeting() {
    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 800), () {
      final newTasks = [
        Task(
          id: DateTime.now().millisecondsSinceEpoch,
          title: 'Follow up with Alex on budget proposal',
          category: 'Work',
          priority: 2,
          dueDate: DateTime.now().add(const Duration(days: 2)),
          notes: 'From "Project Kickoff" meeting',
          isCompleted: false,
        ),
        Task(
          id: DateTime.now().millisecondsSinceEpoch + 1,
          title: 'Schedule design review with team',
          category: 'Work',
          priority: 1,
          dueDate: DateTime.now().add(const Duration(days: 3)),
          notes: 'From "Design Workshop" meeting',
          isCompleted: false,
        ),
      ];

      allTasks.addAll(newTasks);
      isLoading.value = false;
      Get.snackbar(
        'Generated!',
        '2 tasks created from meetings 🎯',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    });
  }

  void editTask(Task task) {
    // In real app: show edit dialog
    Get.snackbar(
      'Feature',
      'Edit task functionality coming soon...',
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }
}
