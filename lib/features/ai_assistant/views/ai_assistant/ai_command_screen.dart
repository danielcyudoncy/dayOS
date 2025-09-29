// features/ai_assistant/views/ai_assistant/ai_command_screen.dart

import 'package:day_os/features/ai_assistant/controllers/ai_controller.dart';
import 'package:day_os/core/widgets/app_drawer.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class AICommandScreen extends StatelessWidget {
  const AICommandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIController()); // We'll create this next

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Your AI Assistant', style: FontUtil.headlineSmall(color: Colors.white, fontWeight: FontWeights.semiBold)),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
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
        child: SafeArea(
        child: Column(
          children: [
            // Input Area
            _buildInputArea(controller),
            const Divider(height: 1, color: Colors.grey),
            // Response Area
            Expanded(
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
                          style: FontUtil.bodyLarge(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: controller.clearError,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.commandHistory.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildHistoryList(controller);
              }),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildInputArea(AIController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.9),
                hintText: 'Ask anything...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              style: FontUtil.bodyLarge(color: Colors.black),
              onSubmitted: (value) => controller.processCommand(),
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: controller.processCommand,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1a1a2e),
            child: const Icon(Icons.send, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 64, color: Colors.white.withValues(alpha: 0.8)),
            const SizedBox(height: 24),
            Text(
              'How can I help you today?',
              style: FontUtil.headlineMedium(color: Colors.white, fontWeight: FontWeights.semiBold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try: "Summarize my last meeting" or "Plan meals for tomorrow"',
              style: FontUtil.bodyMedium(color: Colors.white.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionChip('Summarize my last meeting'),
                _buildSuggestionChip('What’s on my schedule?'),
                _buildSuggestionChip('Plan meals for tomorrow'),
                _buildSuggestionChip('Add task: Call mom'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return FilterChip(
      label: Text(label, style: FontUtil.bodySmall(color: Colors.indigo)),
      onSelected: (value) {
        final controller = Get.find<AIController>();
        controller.textController.text = label;
        controller.processCommand();
      },
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      labelStyle: FontUtil.bodySmall(color: Colors.indigo),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildHistoryList(AIController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      reverse: true, // Newest on top
      itemCount: controller.commandHistory.length,
      itemBuilder: (context, index) {
        final item = controller.commandHistory[index];
        return _buildHistoryItem(item);
      },
    );
  }

  Widget _buildHistoryItem(AICommandHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Query
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item.query,
              style: FontUtil.bodyLarge(color: Colors.white, fontWeight: FontWeights.medium),
            ),
          ),
          const SizedBox(height: 8),
          // AI Response
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item.response,
              style: FontUtil.bodyMedium(color: Colors.white.withValues(alpha: 0.9)),
            ),
          ),
        ],
      ),
    );
  }
}
