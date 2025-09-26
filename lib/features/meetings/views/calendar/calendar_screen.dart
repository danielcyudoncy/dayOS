// presentation/screens/calendar/calendar_screen.dart
import 'package:day_os/features/meetings/controllers/calendar_controller.dart';
import 'package:day_os/core/widgets/meeting_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalendarController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
        actions: [
          IconButton(
            onPressed: controller.syncCalendars,
            icon: const Icon(Icons.sync),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(controller.error.value),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.syncCalendars,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Sync'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildCalendarHeader(controller),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.meetings.length,
                itemBuilder: (context, index) {
                  return MeetingTile(meeting: controller.meetings[index]);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCalendarHeader(CalendarController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        border: Border(bottom: BorderSide(color: Colors.indigo[100]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connected Accounts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildAccountChip('Google Calendar', true, Colors.red),
              _buildAccountChip('Outlook', true, Colors.blue),
              _buildAccountChip('Zoom', true, Colors.green),
              _buildAccountChip('Teams', false, Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.indigo,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Notify me 5 min before meetings',
                style: TextStyle(fontSize: 14),
              ),
              Switch(
                value: controller.notifyBeforeMeeting.value,
                onChanged: controller.toggleNotification,
                activeThumbColor: Colors.indigo,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.join_inner, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              const Text('Auto-join meetings', style: TextStyle(fontSize: 14)),
              Switch(
                value: controller.autoJoin.value,
                onChanged: controller.toggleAutoJoin,
                activeThumbColor: Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountChip(String label, bool connected, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: connected ? color.withValues(alpha:0.1) : Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: connected ? color : Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            connected ? Icons.check_circle : Icons.error,
            color: connected ? color : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: connected ? color : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
