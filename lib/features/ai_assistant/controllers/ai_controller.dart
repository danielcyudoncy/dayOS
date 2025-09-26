// presentation/controllers/ai_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AICommandHistoryItem {
  final String query;
  final String response;
  final DateTime timestamp;

  AICommandHistoryItem({
    required this.query,
    required this.response,
    required this.timestamp,
  });
}

class AIController extends GetxController {
  final textController = TextEditingController();
  final isLoading = false.obs;
  final error = ''.obs;
  final commandHistory = <AICommandHistoryItem>[].obs;

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void clearError() => error.value = '';

  Future<void> processCommand() async {
    final query = textController.text.trim();
    if (query.isEmpty) return;

    isLoading.value = true;
    error.value = '';

    try {
      final response = await _simulateAIResponse(query);
      commandHistory.insert(
        0,
        AICommandHistoryItem(
          query: query,
          response: response,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      error.value = 'Failed to process your request. Please try again.';
    } finally {
      isLoading.value = false;
      textController.clear();
    }
  }

  Future<String> _simulateAIResponse(String query) async {
    await Future.delayed(
      const Duration(milliseconds: 1200),
    ); // Simulate AI thinking

    query = query.toLowerCase();

    if (query.contains('summarize') && query.contains('meeting')) {
      return '''
📌 Meeting Summary: Project Kickoff
- Decided on Q3 roadmap
- Action: Alex to send budget proposal by Friday
- Action: Team to finalize design mockups by Wednesday
- Next sync: July 12, 3 PM
''';
    }

    if (query.contains('plan') && query.contains('meal')) {
      return '''
🥗 Tomorrow’s Meal Plan:
• Breakfast: Greek Yogurt + Berries + Granola (380 kcal)
• Lunch: Chickpea Salad Wrap + Apple (520 kcal)
• Dinner: Grilled Salmon + Quinoa + Asparagus (620 kcal)
🛒 Grocery List Updated!
''';
    }

    if (query.contains('schedule') ||
        query.contains('what') && query.contains('today')) {
      return '''
🗓️ Today’s Schedule:
• 10:00 AM: Team Sync (Google Meet)
• 12:30 PM: Lunch Break
• 2:00 PM: Client Call (Zoom)
• 5:00 PM: Gym Session
• 7:00 PM: Dinner
''';
    }

    if (query.contains('add task') || query.contains('create task')) {
      final task = query.replaceFirst(
        RegExp(r'(add task|create task)[:\s]*'),
        '',
      );
      if (task.isNotEmpty) {
        return '✅ Task added: "$task". You can view it in your Tasks section.';
      }
    }

    return '''
🤔 I can help with:
• Summarizing meetings
• Planning meals
• Showing your schedule
• Adding tasks
Try being more specific!
''';
  }
}
