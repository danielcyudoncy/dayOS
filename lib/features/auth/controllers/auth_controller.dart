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
      // Check if user exists first
      final userExists = await _authService.userExists(email);

      if (!userExists) {
        _showCreateAccountDialog();
        return false;
      }

      // Attempt to sign in with Firebase
      final success = await _authService.signInWithEmail(email, password);

      if (success) {
        // Get user info from auth service
        final currentUser = _authService.getCurrentUser();
        final userEmail = currentUser?.email ?? email;
        final userName = userEmail.split('@')[0];

        // Store user data
        _storage.write('user_email', userEmail);
        _storage.write('user_name', userName);
        _storage.write('is_authenticated', true);
        _storage.write('auth_method', 'email');

        // Update reactive variables
        _isAuthenticated.value = true;
        _userEmail.value = userEmail;
        _userName.value = userName;
        _authMethod.value = 'email';

        return true;
      } else {
        Get.snackbar(
          'Sign In Failed',
          'Please check your credentials and try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
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
      // Use actual Firebase authentication
      final success = await _authService.signUpWithEmail(email, password);

      if (success) {
        // Get user info from auth service
        final currentUser = _authService.getCurrentUser();
        final userEmail = currentUser?.email ?? email;

        // Store user data
        _storage.write('user_email', userEmail);
        _storage.write('user_name', name);
        _storage.write('is_authenticated', true);
        _storage.write('auth_method', 'email');

        // Update reactive variables
        _isAuthenticated.value = true;
        _userEmail.value = userEmail;
        _userName.value = name;
        _authMethod.value = 'email';

        Get.snackbar(
          'Success',
          'Account created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          'Sign Up Failed',
          'Please try again or check if the email is already registered',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
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

  /// Show dialog for users who don't have an account
  void _showCreateAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Account Not Found',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          'You don\'t have an account with us. Please create an account to continue.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.toNamed('/signup'); // Navigate to sign up
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B7CFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
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

    try {
      final success = await _authService.sendPasswordResetEmail(email);

      if (success) {
        Get.snackbar(
          'Email Sent',
          'Password reset instructions have been sent to your email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Reset Failed',
          'Unable to send reset email. Please check your email address and try again. Note: This feature requires proper Firebase configuration.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return false;
      }
    } catch (e) {
      print('Password reset error: $e');
      Get.snackbar(
        'Reset Failed',
        'Unable to send reset email. Please check your email address and try again. Note: This feature requires proper Firebase configuration.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return false;
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