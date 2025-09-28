// clear_storage.dart
// Temporary script to clear GetStorage for testing
import 'dart:io';
import 'package:get_storage/get_storage.dart';

void main() async {
  // Initialize GetStorage
  await GetStorage.init();

  final storage = GetStorage();
  await storage.erase(); // Clear all stored data

  print('✅ GetStorage cleared successfully!');
  print('🚀 App will now show authentication flow on next launch.');
  print('📱 Start the app and you should see:');
  print('   1. Splash Screen (2 seconds)');
  print('   2. Onboarding Screens (if first time user)');
  print('   3. Sign In Screen (if not authenticated)');
  print('   4. Home Screen (after authentication)');
  print('');
  print('🔧 Debug info:');
  print('   - hasSeenOnboarding: ${storage.read('hasSeenOnboarding')}');
  print('   - is_authenticated: ${storage.read('is_authenticated')}');

  exit(0);
}