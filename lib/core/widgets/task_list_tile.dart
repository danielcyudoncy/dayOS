// core/widgets/task_list_tile.dart
import 'package:day_os/features/tasks/controllers/task_controller.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:day_os/data/models/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final TaskController controller;

  const TaskListTile({super.key, required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: Key(task.id.toString()),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          controller.deleteTask(task.id);
        },
        child: CheckboxListTile(
          value: task.isCompleted,
          onChanged: (value) => controller.toggleTask(task.id),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: FontUtil.fontFamily,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey[600] : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!task.isCompleted) _buildPriorityBadge(task.priority),
                ],
              ),
              if (task.notes.isNotEmpty)
                Text(
                  task.notes,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontFamily: FontUtil.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          subtitle: _buildSubtitle(task),
          secondary: IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => controller.editTask(task),
            color: Colors.grey,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(int priority) {
    Color color;
    switch (priority) {
      case 1:
        color = Colors.red;
        break;
      case 2:
        color = Colors.orange;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        'P$priority',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: FontUtil.fontFamily,
        ),
      ),
    );
  }

  Widget? _buildSubtitle(Task task) {
    if (task.dueDate == null && task.category.isEmpty) return null;

    return Row(
      children: [
        if (task.dueDate != null)
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${task.dueDate!.month}/${task.dueDate!.day}',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: FontUtil.fontFamily),
              ),
            ],
          ),
        if (task.dueDate != null && task.category.isNotEmpty)
          const SizedBox(width: 8),
        if (task.category.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: task.category == 'Work'
                  ? Colors.blue[100]
                  : Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              task.category,
              style: TextStyle(
                fontSize: 10,
                color: task.category == 'Work'
                    ? Colors.blue[800]
                    : Colors.green[800],
                fontWeight: FontWeight.bold,
                fontFamily: FontUtil.fontFamily,
              ),
            ),
          ),
      ],
    );
  }
}
