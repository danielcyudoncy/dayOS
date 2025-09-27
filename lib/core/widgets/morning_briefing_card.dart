// core/widgets/morning_briefing_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:day_os/features/dashboard/controllers/home_controller.dart';

class MorningBriefingCard extends StatelessWidget {
   const MorningBriefingCard({super.key});

   @override
   Widget build(BuildContext context) {
     final HomeController controller = Get.find<HomeController>();
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
             Obx(() => Text.rich(
               TextSpan(
                 children: [
                   const TextSpan(
                     text: 'You have ',
                     style: TextStyle(color: Colors.black87),
                   ),
                   TextSpan(
                     text: '${controller.todayMeetings.length} ${controller.todayMeetings.length == 1 ? 'meeting' : 'meetings'}',
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   ),
                   const TextSpan(
                     text: ', ',
                     style: TextStyle(color: Colors.black87),
                   ),
                   TextSpan(
                     text: '${controller.todayMeals.length} ${controller.todayMeals.length == 1 ? 'meal' : 'meals'} planned',
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   ),
                   const TextSpan(
                     text: ', and ',
                     style: TextStyle(color: Colors.black87),
                   ),
                   TextSpan(
                     text: '${controller.todayTasks.length} ${controller.todayTasks.length == 1 ? 'task' : 'tasks'}',
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   ),
                   const TextSpan(
                     text: '.',
                     style: TextStyle(color: Colors.black87),
                   ),
                 ],
               ),
             )),
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
