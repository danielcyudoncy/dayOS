// presentation/screens/ai_assistant/ai_command_screen.dart

import 'package:day_os/features/ai_assistant/controllers/ai_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AICommandScreen extends StatelessWidget {
  const AICommandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIController()); // We'll create this next

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your AI Assistant'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Input Area
            _buildInputArea(controller),
            const Divider(height: 1, color: Colors.grey),
            // Response Area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
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
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
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
                fillColor: Colors.grey[100],
                hintText: 'Ask anything...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (value) => controller.processCommand(),
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: controller.processCommand,
            backgroundColor: Colors.indigo,
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
            const Icon(Icons.mic, size: 64, color: Colors.indigo),
            const SizedBox(height: 24),
            const Text(
              'How can I help you today?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try: “Summarize my last meeting” or “Plan meals for tomorrow”',
              style: TextStyle(color: Colors.grey, fontSize: 14),
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
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onSelected: (value) {
        final controller = Get.find<AIController>();
        controller.textController.text = label;
        controller.processCommand();
      },
      backgroundColor: Colors.indigo[50],
      labelStyle: TextStyle(color: Colors.indigo[900]),
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
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item.query,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          // AI Response
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(item.response, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
