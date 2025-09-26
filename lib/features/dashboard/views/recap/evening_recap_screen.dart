// presentation/screens/recap/evening_recap_screen.dart
import 'package:day_os/features/dashboard/controllers/recap_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EveningRecapScreen extends StatelessWidget {
  const EveningRecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecapController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evening Recap'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStatsCard(controller),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Today’s Meetings',
                    Icons.videocam,
                    controller.meetingSummaries,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Meals Logged',
                    Icons.restaurant,
                    controller.mealLogs,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Tasks Completed',
                    Icons.check_circle,
                    controller.completedTasks,
                  ),
                  const SizedBox(height: 24),
                  _buildTomorrowPreview(controller),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Evening!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here’s how your day went 👇',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildStatsCard(RecapController controller) {
    return Card(
      color: Colors.white.withValues(alpha: .9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              'Meetings',
              controller.meetingCount.toString(),
              Icons.videocam,
              Colors.blue,
            ),
            const VerticalDivider(width: 1, thickness: 1),
            _buildStatItem(
              'Meals',
              controller.mealCount.toString(),
              Icons.restaurant,
              Colors.orange,
            ),
            const VerticalDivider(width: 1, thickness: 1),
            _buildStatItem(
              'Tasks',
              '${controller.completedCount}/${controller.totalTasks}',
              Icons.check_circle,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<String> items) {
    if (items.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildRecapItem(item)),
      ],
    );
  }

  Widget _buildRecapItem(String text) {
    return Card(
      color: Colors.white.withValues(alpha: .95),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _buildTomorrowPreview(RecapController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.nightlight_round, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Tomorrow Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.white.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📅 Schedule Highlights',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...controller.tomorrowPreview
                    .map(
                      (preview) => Text(
                        '• $preview',
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                    ,
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'AI Suggestion: Start tomorrow by reviewing your top priority task and having a protein-rich breakfast to boost focus!',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () => Get.toNamed('/ai'),
          icon: const Icon(Icons.mic),
          label: const Text('Ask AI Assistant'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Get.toNamed('/tasks'),
          icon: const Icon(Icons.checklist),
          label: const Text('Plan Tomorrow'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[200],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
