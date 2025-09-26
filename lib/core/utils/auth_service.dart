// services/auth_service.dart
import 'package:get/get.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async {
    // Initialize Firebase Auth here
    return this;
  }

  Future<bool> signInWithGoogle() async {
    // Mock Google Sign In
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<void> signOut() async {
    // Mock sign out
    await Future.delayed(const Duration(milliseconds: 200));
  }

  String getCurrentUserEmail() {
    return 'user@example.com'; // Mock email
  }
}
