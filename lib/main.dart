// main.dart
import 'package:day_os/routes/app_pages.dart';
import 'package:day_os/core/theme/app_theme.dart';
import 'package:day_os/data/di/di.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 👈 IMPORT DOTENV
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // 👈 IMPORT GetStorage



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Continue without Firebase - app will use fallback data
  }

  // Load environment variables (optional - app works without .env file)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Continue without .env file - app will use fallback values
  }

  await GetStorage.init(); // Initialize GetStorage
  await initDependencies(); // Initialize all dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DailyOS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme, // Ensure no dark mode
      themeMode: ThemeMode.light, // Force light mode
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
