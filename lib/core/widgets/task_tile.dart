// core/widgets/task_tile.dart
import 'package:day_os/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:day_os/core/theme/font_util.dart';


class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
 Widget build(BuildContext context) {
   return Card(
     child: CheckboxListTile(
       value: task.isCompleted,
       onChanged: (value) {
         task.isCompleted = value!;
         if (value) {
           Get.snackbar(
             'Task Completed',
             task.title,
             icon: const Icon(Icons.check, color: Colors.black),
             backgroundColor: Colors.white,
             colorText: Colors.black,
           );
         }
       },
       title: Text(
         task.title,
         style: FontUtil.bodyLarge(
           decoration: task.isCompleted ? TextDecoration.lineThrough : null,
           fontWeight: FontWeights.medium,
         ),
       ),
       secondary: const Icon(Icons.task, color: Colors.indigo),
       controlAffinity: ListTileControlAffinity.leading,
       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
     ),
   );
 }
}
