// features/meetings/views/calendar/calendar_screen.dart
import 'package:day_os/features/meetings/controllers/calendar_controller.dart';
import 'package:day_os/core/widgets/app_drawer.dart';
import 'package:day_os/core/widgets/meeting_tile.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalendarController>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('My Calendar', style: FontUtil.headlineSmall(color: Colors.white, fontWeight: FontWeights.semiBold)),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.syncCalendars,
            icon: const Icon(Icons.sync, color: Colors.white),
          ),
          const SizedBox(width: 8),
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

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    controller.error.value,
                    style: FontUtil.bodyLarge(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.syncCalendars,
                    icon: const Icon(Icons.refresh, color: Color(0xFF1a1a2e)),
                    label: Text('Retry Sync', style: FontUtil.bodyMedium(color: const Color(0xFF1a1a2e))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1a1a2e),
                    ),
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
      ),
    );
  }

  Widget _buildCalendarHeader(CalendarController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connected Accounts',
            style: FontUtil.titleLarge(color: Colors.white, fontWeight: FontWeights.semiBold),
          ),
          const SizedBox(height: 8),
          Center(
            child: Wrap(
              spacing: 18,
              children: [
                _buildAccountChip('Google Calendar', true, Colors.red),
                _buildAccountChip('Outlook', true, Colors.blue),
                _buildAccountChip('Zoom', true, Colors.green),
                _buildAccountChip('Teams', false, Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.indigo,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Notify me 5 min before meetings',
                style: FontUtil.bodyMedium(color: Colors.white),
              ),
              Switch(
                value: controller.notifyBeforeMeeting.value,
                onChanged: controller.toggleNotification,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withValues(alpha: 0.5),
              ),
            ],
           ),
           const SizedBox(height: 8),
           Row(
             children: [
               const Icon(Icons.join_inner, color: Colors.white, size: 20),
               const SizedBox(width: 8),
               Text('Auto-join meetings', style: FontUtil.bodyMedium(color: Colors.white)),
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
