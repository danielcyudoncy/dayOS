// presentation/widgets/task_tile.dart
import 'package:day_os/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Obx(
        () => CheckboxListTile(
          value: task.isCompleted,
          onChanged: (value) {
            task.isCompleted = value!;
            if (value) {
              Get.snackbar(
                'Task Completed',
                task.title,
                icon: const Icon(Icons.check),
              );
            }
          },
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          secondary: const Icon(Icons.task, color: Colors.indigo),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
