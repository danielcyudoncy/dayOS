// features/dashboard/views/home/home_screen.dart
import 'package:day_os/features/dashboard/controllers/home_controller.dart';
import 'package:day_os/core/widgets/meal_tile.dart';
import 'package:day_os/core/widgets/meeting_tile.dart';
import 'package:day_os/core/widgets/morning_briefing_card.dart';
import 'package:day_os/core/widgets/section_title.dart';
import 'package:day_os/core/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DailyOS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
       actions: [
          IconButton(
            onPressed: () => Get.toNamed('/calendar'),
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/meals'),
            icon: const Icon(Icons.restaurant),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/tasks'),
            icon: const Icon(Icons.checklist),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/recap'),
            icon: const Icon(Icons.nightlight_round),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/settings'),
            icon: const Icon(Icons.settings),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.indigo[100],
            child: const Icon(Icons.person, color: Colors.indigo, size: 18),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        color: Colors.grey[50], // Ensure light background
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
                          CircularProgressIndicator.adaptive(),
                          SizedBox(height: 16),
                          Text('Loading your day...'),
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
                  ? const Center(child: Text('No meetings today'))
                  : Column(
                      children: controller.todayMeetings
                          .map((meeting) => MeetingTile(meeting: meeting))
                          .toList(),
                    )),

              const SizedBox(height: 32),

              const SectionTitle(title: 'Meals Today'),
              const SizedBox(height: 8),
              Obx(() => controller.todayMeals.isEmpty
                  ? const Center(child: Text('No meals planned'))
                  : Column(
                      children: controller.todayMeals
                          .map((meal) => MealTile(meal: meal))
                          .toList(),
                    )),

              const SizedBox(height: 32),

              const SectionTitle(title: 'Today\'s Tasks'),
              const SizedBox(height: 8),
              Obx(() => controller.todayTasks.isEmpty
                  ? const Center(child: Text('No tasks today'))
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
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}