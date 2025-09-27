// features/dashboard/views/home/home_screen.dart
import 'package:day_os/features/dashboard/controllers/home_controller.dart';
import 'package:day_os/core/widgets/meal_tile.dart';
import 'package:day_os/core/widgets/meeting_tile.dart';
import 'package:day_os/core/widgets/morning_briefing_card.dart';
import 'package:day_os/core/widgets/section_title.dart';
import 'package:day_os/core/widgets/task_tile.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DailyOS',
          style: FontUtil.headlineSmall(
            color: Colors.white,
            fontWeight: FontWeights.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
       actions: [
          IconButton(
            onPressed: () => Get.toNamed('/calendar'),
            icon: const Icon(Icons.calendar_today, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/meals'),
            icon: const Icon(Icons.restaurant, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/tasks'),
            icon: const Icon(Icons.checklist, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/recap'),
            icon: const Icon(Icons.nightlight_round, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/settings'),
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading indicator - only this widget needs to be reactive
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading your day...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Raleway',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Empty widget when not loading
              }),

              // Debug info - only reactive to loading state
              Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.yellow[100],
                    child: Text(
                      'DEBUG: Loading: ${controller.isLoading.value}, '
                      'Meetings: ${controller.todayMeetings.length}, '
                      'Meals: ${controller.todayMeals.length}, '
                      'Tasks: ${controller.todayTasks.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Main content - separate widgets for better performance
              const MorningBriefingCard(),

              const SizedBox(height: 32),

              const SectionTitle(title: 'Upcoming Meetings'),
              const SizedBox(height: 8),
              Obx(() => controller.todayMeetings.isEmpty
                  ? Center(child: Text('No meetings today', style: FontUtil.bodyLarge(color: Colors.white.withValues(alpha: 0.7))))
                  : Column(
                      children: controller.todayMeetings
                          .map((meeting) => MeetingTile(meeting: meeting))
                          .toList(),
                    )),

              const SizedBox(height: 32),

              const SectionTitle(title: 'Meals Today'),
              const SizedBox(height: 8),
              Obx(() => controller.todayMeals.isEmpty
                  ? Center(child: Text('No meals planned', style: FontUtil.bodyLarge(color: Colors.white.withValues(alpha: 0.7))))
                  : Column(
                      children: controller.todayMeals
                          .map((meal) => MealTile(meal: meal))
                          .toList(),
                    )),

              const SizedBox(height: 32),

              const SectionTitle(title: 'Today\'s Tasks'),
              const SizedBox(height: 8),
              Obx(() => controller.todayTasks.isEmpty
                  ? Center(child: Text('No tasks today', style: FontUtil.bodyLarge(color: Colors.white.withValues(alpha: 0.7))))
                  : Column(
                      children: controller.todayTasks
                          .map((task) => TaskTile(task: task))
                          .toList(),
                    )),

              const SizedBox(height: 60), // for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Check if it's morning (before 12 PM)
          if (DateTime.now().hour < 12) {
            Get.toNamed('/morning');
          } else {
            Get.toNamed('/ai');
          }
        },
        backgroundColor: DateTime.now().hour < 12
            ? Colors.orange
            : Colors.indigo,
        child: Icon(
          DateTime.now().hour < 12 ? Icons.wb_sunny : Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
