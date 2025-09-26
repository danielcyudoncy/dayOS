// core/utils/ai_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // 👈 IMPORT HTTP CLIENT

// 🔑 IMPORTANT: Replace with your actual OpenAI key
// Get your key from: https://platform.openai.com/api-keys
// In production, use environment variables or secure storage!
const String OPENAI_KEY = 'YOUR_OPENAI_API_KEY_HERE';

class AIService extends GetxService {
  final lastResponse = ''.obs;

  // ✅ Fixed: Real HTTP client
  final http.Client _client = http.Client();

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }

  Future<String> summarizeMeeting(String transcript) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $OPENAI_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a meeting assistant.'},
            {
              'role': 'user',
              'content':
                  'Summarize this meeting and extract action items:\n$transcript',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to summarize meeting: $e');
      rethrow;
    }
  }

  Future<List<String>> generateMealPlan(String dietaryPrefs) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $OPENAI_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a nutritionist. Return a JSON array of 3 meal names (breakfast, lunch, dinner) based on dietary preferences.',
            },
            {
              'role': 'user',
              'content':
                  'Generate a meal plan with these preferences: $dietaryPrefs. Return only a JSON array like ["Meal 1", "Meal 2", "Meal 3"]',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        // Parse JSON array from response
        final start = content.indexOf('[');
        final end = content.indexOf(']', start) + 1;
        if (start != -1 && end != -1) {
          final jsonPart = content.substring(start, end);
          final List<dynamic> meals = jsonDecode(jsonPart);
          return meals.cast<String>();
        }
        // Fallback: split by lines
        return content
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .take(3)
            .toList();
      } else {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate meal plan: $e');
      // Return mock data on error
      return [
        'Avocado Toast with Eggs',
        'Quinoa Bowl with Grilled Veggies',
        'Grilled Salmon with Steamed Broccoli',
      ];
    }
  }

  Future<String> processCommand(String command) async {
    command = command.toLowerCase().trim();

    if (command.contains('summarize') && command.contains('meeting')) {
      // In real app: fetch last meeting transcript
      final mockTranscript =
          "Team discussed Q3 roadmap. Alex to send budget proposal by Friday.";
      return await summarizeMeeting(mockTranscript);
    } else if (command.contains('meal plan') || command.contains('meals')) {
      final mockPrefs = "vegetarian, high-protein";
      final meals = await generateMealPlan(mockPrefs);
      return '🥗 Meal Plan:\n• ${meals[0]}\n• ${meals[1]}\n• ${meals[2]}';
    } else if (command.contains('schedule') || command.contains('today')) {
      return '''
🗓️ Today's Schedule:
• 10:00 AM: Team Sync
• 12:30 PM: Lunch
• 2:00 PM: Client Call
• 6:00 PM: Gym
''';
    } else {
      return '''
🤖 I can help with:
• "Summarize my last meeting"
• "Plan meals for tomorrow"
• "What's on my schedule?"
Try being more specific!
''';
    }
  }
}