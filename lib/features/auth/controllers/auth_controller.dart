// features/auth/controllers/auth_controller.dart
import 'package:day_os/core/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage();

  // Reactive variables
  final RxBool _isAuthenticated = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _userEmail = ''.obs;
  final RxString _userName = ''.obs;
  final RxString _authMethod = ''.obs;

  // Getters
  bool get isAuthenticated => _isAuthenticated.value;
  bool get isLoading => _isLoading.value;
  String get userEmail => _userEmail.value;
  String get userName => _userName.value;
  String get authMethod => _authMethod.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  /// Check if user is already authenticated on app start
  void _checkAuthStatus() {
    _isAuthenticated.value = _storage.read('is_authenticated') ?? false;
    _userEmail.value = _storage.read('user_email') ?? '';
    _userName.value = _storage.read('user_name') ?? '';
    _authMethod.value = _storage.read('auth_method') ?? '';
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    _isLoading.value = true;
    try {
      // TODO: Implement actual Firebase authentication
      await Future.delayed(const Duration(seconds: 2));

      // Store user data
      _storage.write('user_email', email);
      _storage.write('user_name', email.split('@')[0]);
      _storage.write('is_authenticated', true);
      _storage.write('auth_method', 'email');

      // Update reactive variables
      _isAuthenticated.value = true;
      _userEmail.value = email;
      _userName.value = email.split('@')[0];
      _authMethod.value = 'email';

      Get.snackbar(
        'Success',
        'Signed in successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Sign In Failed',
        'Please check your credentials and try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign up with email, password, and name
  Future<bool> signUpWithEmail(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Basic email validation
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Basic password validation
    if (password.length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters long',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    _isLoading.value = true;
    try {
      // TODO: Implement actual Firebase authentication
      await Future.delayed(const Duration(seconds: 2));

      // Store user data
      _storage.write('user_email', email);
      _storage.write('user_name', name);
      _storage.write('is_authenticated', true);
      _storage.write('auth_method', 'email');

      // Update reactive variables
      _isAuthenticated.value = true;
      _userEmail.value = email;
      _userName.value = name;
      _authMethod.value = 'email';

      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        'Please try again or check if the email is already registered',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading.value = true;
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        // Get user info from auth service
        final email = _authService.getCurrentUserEmail();
        final name = email.split('@')[0];

        // Store user data
        _storage.write('user_email', email);
        _storage.write('user_name', name);
        _storage.write('is_authenticated', true);
        _storage.write('auth_method', 'google');

        // Update reactive variables
        _isAuthenticated.value = true;
        _userEmail.value = email;
        _userName.value = name;
        _authMethod.value = 'google';

        Get.snackbar(
          'Success',
          'Signed in with Google successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          'Google Sign In Failed',
          'Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading.value = true;
    try {
      await _authService.signOut();

      // Clear stored data
      _storage.remove('user_email');
      _storage.remove('user_name');
      _storage.remove('is_authenticated');
      _storage.remove('auth_method');

      // Update reactive variables
      _isAuthenticated.value = false;
      _userEmail.value = '';
      _userName.value = '';
      _authMethod.value = '';

      Get.snackbar(
        'Success',
        'Signed out successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to sign in screen
      Get.offAllNamed('/signin');
    } catch (e) {
      Get.snackbar(
        'Sign Out Failed',
        'Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigate to home if authenticated, otherwise to sign in
  void handleAppStart() {
    if (_isAuthenticated.value) {
      Get.offAllNamed('/');
    } else {
      Get.offAllNamed('/signin');
    }
  }
}