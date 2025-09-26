// presentation/widgets/morning_briefing_card.dart
import 'package:flutter/material.dart';

class MorningBriefingCard extends StatelessWidget {
  const MorningBriefingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = hour < 12
        ? 'Good Morning!'
        : hour < 17
        ? 'Good Afternoon!'
        : 'Good Evening!';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'You have ',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '2 meetings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ', ',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '3 meals planned',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ', and ',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '4 tasks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Start day routine
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Day started! Notifications enabled.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Start My Day'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    // AI Morning Brief Audio
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🔊 Playing audio briefing...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.volume_up_outlined),
                  color: Colors.indigo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
