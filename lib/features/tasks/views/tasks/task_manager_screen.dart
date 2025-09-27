// features/tasks/views/tasks/task_manager_screen.dart
import 'package:day_os/features/tasks/controllers/task_controller.dart';
import 'package:day_os/core/widgets/task_list_tile.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks', style: FontUtil.headlineSmall(color: Colors.white, fontWeight: FontWeights.semiBold)),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAddTaskDialog(context, controller),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            onPressed: controller.generateFromMeeting,
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e), // Dark background
              Color(0xFF8B5CF6), // Purple
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          final workTasks = controller.workTasks;
        final personalTasks = controller.personalTasks;
        final completedTasks = controller.completedTasks;

        return RefreshIndicator(
          onRefresh: () => controller.refreshTasks(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (workTasks.isNotEmpty) ...[
                _buildSectionHeader(
                  'Work Tasks',
                  workTasks.length,
                  Colors.blue,
                ),
                ...workTasks
                    .map(
                      (task) =>
                          TaskListTile(task: task, controller: controller),
                    )
                    .toList(),
                const SizedBox(height: 24),
              ],
              if (personalTasks.isNotEmpty) ...[
                _buildSectionHeader(
                  'Personal Tasks',
                  personalTasks.length,
                  Colors.green,
                ),
                ...personalTasks
                    .map(
                      (task) =>
                          TaskListTile(task: task, controller: controller),
                    )
                    .toList(),
                const SizedBox(height: 24),
              ],
              if (completedTasks.isNotEmpty) ...[
                _buildSectionHeader(
                  'Completed',
                  completedTasks.length,
                  Colors.grey,
                ),
                ...completedTasks
                    .map(
                      (task) =>
                          TaskListTile(task: task, controller: controller),
                    )
                    .toList(),
              ],
              if (controller.allTasks.isEmpty) _buildEmptyState(controller),
            ],
          ),
        );
      }),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.label, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
              fontFamily: 'Raleway',
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TaskController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist, size: 64, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(height: 24),
            Text(
              'No tasks yet',
              style: FontUtil.headlineSmall(color: Colors.white, fontWeight: FontWeights.semiBold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add tasks manually or let AI create them from meetings!',
              style: FontUtil.bodyMedium(color: Colors.white.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAddTaskDialog(Get.context!, controller),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Task'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.generateFromMeeting,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('From Meeting'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskController controller) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    DateTime? dueDate;
    String selectedCategory = 'Personal';
    int selectedPriority = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task Title *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Work', 'Personal'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) => selectedCategory = value!,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Priority: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ...List.generate(3, (index) {
                      final priority = index + 1;
                      return GestureDetector(
                        onTap: () => selectedPriority = priority,
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedPriority == priority
                                ? Colors.orange
                                : Colors.grey[300],
                          ),
                          child: Text(
                            '$priority',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Due Date: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      dueDate == null
                          ? 'No date'
                          : '${dueDate!.month}/${dueDate!.day}',
                      style: const TextStyle(color: Colors.indigo),
                    ),
                    IconButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) dueDate = picked;
                      },
                      icon: const Icon(Icons.calendar_today, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                controller.addTask(
                  title: titleController.text.trim(),
                  notes: notesController.text,
                  category: selectedCategory,
                  priority: selectedPriority,
                  dueDate: dueDate,
                );
                Navigator.pop(context);
                Get.snackbar(
                  'Added',
                  'Task created successfully ✅',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
