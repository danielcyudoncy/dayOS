// features/dashboard/controllers/home_controller.dart
import 'package:day_os/data/models/meal.dart';
import 'package:day_os/data/models/meeting.dart';
import 'package:day_os/data/models/task.dart';
import 'package:day_os/data/repositories/calendar_repository.dart';
import 'package:day_os/data/repositories/meal_repository.dart';
import 'package:day_os/data/repositories/task_repository.dart';
import 'package:get/get.dart';
import 'dart:async';

class HomeController extends GetxController {
  final CalendarRepository _calendarRepo;
  final MealRepository _mealRepo;
  final TaskRepository _taskRepo;

  HomeController(this._calendarRepo, this._mealRepo, this._taskRepo);

  var isLoading = true.obs;

  var todayMeetings = <Meeting>[].obs;
  var todayMeals = <Meal>[].obs;
  var todayTasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Load fallback data immediately to prevent any hanging
    _loadFallbackData();

    // Then try to load real data with timeout protection
    Future.delayed(Duration.zero, () {
      loadData().timeout(const Duration(seconds: 10)).catchError((error) {
        // Fallback data already loaded above
      }).whenComplete(() {
        // Ensure loading state is always cleared
        if (isLoading.value) {
          isLoading.value = false;
        }
      });
    });
  }

  void _loadFallbackData() {
    todayMeetings.value = [
      Meeting(
        title: 'Team Sync',
        startTime: DateTime.now().add(const Duration(minutes: 15)),
        platform: 'Google Meet',
        durationMinutes: 30,
      ),
      Meeting(
        title: 'Client Pitch',
        startTime: DateTime.now().add(const Duration(hours: 3)),
        platform: 'Zoom',
        durationMinutes: 45,
      ),
    ];

    todayMeals.value = [
      Meal(
        name: 'Avocado Toast + Coffee',
        calories: 350,
        time: DateTime.now().add(const Duration(hours: 1)),
        isLogged: false,
      ),
      Meal(
        name: 'Grilled Chicken Salad',
        calories: 450,
        time: DateTime.now().add(const Duration(hours: 5)),
        isLogged: false,
      ),
    ];

    todayTasks.value = [
      Task(
        id: 1,
        title: 'Review Q4 Reports',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(hours: 2)),
        isCompleted: false,
      ),
      Task(
        id: 2,
        title: 'Update Project Roadmap',
        priority: 2,
        dueDate: DateTime.now().add(const Duration(hours: 4)),
        isCompleted: true,
      ),
    ];

    isLoading.value = false;
  }

  Future<void> loadData() async {
    isLoading.value = true;

    // Add overall timeout to prevent hanging
    try {
      await _loadDataWithTimeout().timeout(const Duration(seconds: 15));
    } catch (e) {
      _loadFallbackData();
    } finally {
      if (isLoading.value) {
        isLoading.value = false;
      }
    }
  }

  Future<void> _loadDataWithTimeout() async {

    try {

      // Add timeout to prevent hanging
      final meetings = await _calendarRepo.getTodaysMeetings().timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );
      final meals = await _mealRepo.getTodaysMeals().timeout(
        const Duration(seconds: 5),
        onTimeout: () => [],
      );
      final tasks = await _taskRepo.getTodaysTasks().timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );

      // If repos return empty, use fallback mock data
      todayMeetings.value = meetings.isNotEmpty
          ? meetings
          : [
              Meeting(
                title: 'Team Sync',
                startTime: DateTime.now().add(const Duration(minutes: 15)),
                platform: 'Google Meet',
                durationMinutes: 30,
              ),
              Meeting(
                title: 'Client Pitch',
                startTime: DateTime.now().add(const Duration(hours: 3)),
                platform: 'Zoom',
                durationMinutes: 45,
              ),
            ];

      todayMeals.value = meals.isNotEmpty
          ? meals
          : [
              Meal(
                name: 'Avocado Toast + Coffee',
                calories: 350,
                time: DateTime.now().add(const Duration(hours: 1)),
                isLogged: false,
              ),
              Meal(
                name: 'Grilled Chicken Salad',
                calories: 450,
                time: DateTime.now().add(const Duration(hours: 5)),
                isLogged: false,
              ),
            ];

      todayTasks.value = tasks.isNotEmpty
          ? tasks
          : [
              Task(
                id: 1,
                title: 'Review Q4 Reports',
                priority: 1,
                dueDate: DateTime.now().add(const Duration(hours: 2)),
                isCompleted: false,
              ),
              Task(
                id: 2,
                title: 'Update Project Roadmap',
                priority: 2,
                dueDate: DateTime.now().add(const Duration(hours: 4)),
                isCompleted: true,
              ),
            ];
    } catch (e) {
      // If repositories fail, use mock data
      todayMeetings.value = [
        Meeting(
          title: 'Team Sync',
          startTime: DateTime.now().add(const Duration(minutes: 15)),
          platform: 'Google Meet',
          durationMinutes: 30,
        ),
        Meeting(
          title: 'Client Pitch',
          startTime: DateTime.now().add(const Duration(hours: 3)),
          platform: 'Zoom',
          durationMinutes: 45,
        ),
      ];

      todayMeals.value = [
        Meal(
          name: 'Avocado Toast + Coffee',
          calories: 350,
          time: DateTime.now().add(const Duration(hours: 1)),
          isLogged: false,
        ),
        Meal(
          name: 'Grilled Chicken Salad',
          calories: 450,
          time: DateTime.now().add(const Duration(hours: 5)),
          isLogged: false,
        ),
      ];

      todayTasks.value = [
        Task(
          id: 1,
          title: 'Review Q4 Reports',
          priority: 1,
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          isCompleted: false,
        ),
        Task(
          id: 2,
          title: 'Update Project Roadmap',
          priority: 2,
          dueDate: DateTime.now().add(const Duration(hours: 4)),
          isCompleted: true,
        ),
      ];
    } finally {
      isLoading.value = false; // ✅ Ensure loading always stops
    }
  }
}
