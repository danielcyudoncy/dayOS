// features/dashboard/views/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:day_os/core/theme/font_util.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: FontUtil.headlineSmall(color: Colors.white, fontWeight: FontWeights.semiBold)),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        elevation: 0,
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
        child: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Account & Integrations'),
            _buildIntegrationTile(
              'Google Calendar',
              controller.googleConnected.value ? 'Connected' : 'Not connected',
              controller.googleConnected.value,
              () => controller.toggleIntegration('google'),
              Icons.calendar_today,
              Colors.red,
            ),
            _buildIntegrationTile(
              'Microsoft Outlook',
              controller.outlookConnected.value ? 'Connected' : 'Not connected',
              controller.outlookConnected.value,
              () => controller.toggleIntegration('outlook'),
              Icons.email,
              Colors.blue,
            ),
            _buildIntegrationTile(
              'Zoom',
              controller.zoomConnected.value ? 'Connected' : 'Not connected',
              controller.zoomConnected.value,
              () => controller.toggleIntegration('zoom'),
              Icons.videocam,
              Colors.green,
            ),
            _buildIntegrationTile(
              'Microsoft Teams',
              controller.teamsConnected.value ? 'Connected' : 'Not connected',
              controller.teamsConnected.value,
              () => controller.toggleIntegration('teams'),
              Icons.group,
              Colors.purple,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Wellness Preferences'),
            _buildPreferenceTile(
              'Dietary Preferences',
              controller.dietaryPrefs.isEmpty
                  ? 'Not set'
                  : controller.dietaryPrefs.join(', '),
              () => _showDietaryDialog(context, controller),
              Icons.restaurant_menu,
              Colors.orange,
            ),
            _buildPreferenceTile(
              'Meal Reminders',
              controller.mealRemindersEnabled.value ? 'Enabled' : 'Disabled',
              controller.toggleMealReminders,
              Icons.notifications_active,
              Colors.green,
            ),
            _buildPreferenceTile(
              'Work Hours',
              '${controller.workStart.value}:00 - ${controller.workEnd.value}:00',
              () => _showWorkHoursDialog(context, controller),
              Icons.access_time,
              Colors.blue,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('AI Assistant'),
            _buildPreferenceTile(
              'AI Personality',
              controller.aiPersonality.value,
              () => _showAIPersonalityDialog(context, controller),
              Icons.auto_awesome,
              Colors.indigo,
            ),
            _buildPreferenceTile(
              'Meeting Summaries',
              controller.meetingSummariesEnabled.value ? 'Enabled' : 'Disabled',
              controller.toggleMeetingSummaries,
              Icons.summarize,
              Colors.purple,
            ),
            _buildPreferenceTile(
              'Voice Commands',
              controller.voiceCommandsEnabled.value ? 'Enabled' : 'Disabled',
              controller.toggleVoiceCommands,
              Icons.mic,
              Colors.orange,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Privacy & Notifications'),
            SwitchListTile.adaptive(
              title:  Text('Push Notifications',  style: FontUtil.bodyLarge(color: Colors.white)),
              subtitle:  Text(
                'Meeting reminders, meal alerts, task due dates',
                style: FontUtil.bodySmall(color: Colors.white)
              ),
              value: controller.notificationsEnabled.value,
              onChanged: (_) => controller.toggleNotifications(),
              activeThumbColor: Colors.white,
            ),
            SwitchListTile.adaptive(
              title:  Text('Meeting Recording', style: FontUtil.bodyLarge(color: Colors.white)),
              subtitle:  Text(
                'Record meetings for AI transcription (stored securely)',
                style: FontUtil.bodySmall(color: Colors.white)),
              value: controller.meetingRecordingEnabled.value,
              onChanged: (_) => controller.toggleMeetingRecording(),
              activeThumbColor: Colors.white,
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white),
              title: Text('Privacy Policy', style: FontUtil.bodyLarge(color: Colors.white)),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
              onTap: () {
                Get.snackbar(
                  'Privacy',
                  'Privacy policy will open in browser',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: Text('About DailyOS', style: FontUtil.bodyLarge(color: Colors.white)),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
              onTap: () {
                Get.snackbar(
                  'About',
                  'DailyOS v1.0 • Your Personal Daily Operating System',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: controller.signOut,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: FontUtil.titleLarge(
          color: Colors.white,
          fontWeight: FontWeights.semiBold,
        ),
      ),
    );
  }

  Widget _buildIntegrationTile(
    String title,
    String subtitle,
    bool connected,
    VoidCallback onTap,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: connected ? color.withValues(alpha: 0.1) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: connected ? color : Colors.grey[500],
            size: 24,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: connected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.add_circle_outline, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPreferenceTile(
    String title,
    String value,
    VoidCallback onTap,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // dialogs (unchanged, just used updated controller values)
  void _showDietaryDialog(BuildContext context, SettingsController controller) {
    List<String> allPrefs = [
      'Vegetarian',
      'Vegan',
      'Gluten-Free',
      'Dairy-Free',
      'Keto',
      'Low-Carb',
      'High-Protein',
    ];
    List<String> selected = List.from(controller.dietaryPrefs);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dietary Preferences'),
        content: SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allPrefs.map((pref) {
              bool isSelected = selected.contains(pref);
              return FilterChip(
                label: Text(pref),
                selected: isSelected,
                onSelected: (value) {
                  if (value) {
                    selected.add(pref);
                  } else {
                    selected.remove(pref);
                  }
                },
                backgroundColor: isSelected
                    ? Colors.orange[100]
                    : Colors.grey[200],
                selectedColor: Colors.orange[200],
                checkmarkColor: Colors.orange,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateDietaryPreferences(selected);
              Navigator.pop(context);
              Get.snackbar(
                'Updated',
                'Preferences saved ✅',
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showWorkHoursDialog(
    BuildContext context,
    SettingsController controller,
  ) {
    final startController = TextEditingController(
      text: controller.workStart.value.toString(),
    );
    final endController = TextEditingController(
      text: controller.workEnd.value.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Work Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: startController,
              decoration: const InputDecoration(
                labelText: 'Start Hour (24h format)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: endController,
              decoration: const InputDecoration(
                labelText: 'End Hour (24h format)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final start = int.tryParse(startController.text) ?? 9;
              final end = int.tryParse(endController.text) ?? 17;
              if (start >= 0 &&
                  start <= 23 &&
                  end >= 0 &&
                  end <= 23 &&
                  start < end) {
                controller.updateWorkHours(start, end);
                Navigator.pop(context);
                Get.snackbar(
                  'Updated',
                  'Work hours saved ✅',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Please enter valid hours (0-23)',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAIPersonalityDialog(
    BuildContext context,
    SettingsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Personality'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _customRadioTile(
                title: 'Professional',
                subtitle: 'Concise, business-focused responses',
                isSelected: controller.aiPersonality.value == 'Professional',
                onTap: () {
                  controller.updateAIPersonality('Professional');
                  Navigator.pop(context);
                },
              ),
              _customRadioTile(
                title: 'Friendly',
                subtitle: 'Warm, conversational tone',
                isSelected: controller.aiPersonality.value == 'Friendly',
                onTap: () {
                  controller.updateAIPersonality('Friendly');
                  Navigator.pop(context);
                },
              ),
              _customRadioTile(
                title: 'Minimalist',
                subtitle: 'Short, direct answers only',
                isSelected: controller.aiPersonality.value == 'Minimalist',
                onTap: () {
                  controller.updateAIPersonality('Minimalist');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customRadioTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? Colors.orange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}