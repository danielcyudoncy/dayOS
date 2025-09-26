// presentation/widgets/meeting_tile.dart
import 'package:day_os/data/models/meeting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MeetingTile extends StatelessWidget {
  final Meeting meeting;

  const MeetingTile({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    final time =
        '${meeting.startTime.hour}:${meeting.startTime.minute.toString().padLeft(2, '0')}';

    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.videocam, color: Colors.blue, size: 24),
        ),
        title: Text(
          meeting.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$time • ${meeting.platform} • ${meeting.durationMinutes}m',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.join_inner, color: Colors.indigo),
          onPressed: () {
            Get.snackbar(
              'Auto-Joining',
              'Joining "${meeting.title}" in background...',
              icon: const Icon(Icons.cloud_queue, color: Colors.indigo),
            );
          },
        ),
      ),
    );
  }
}
