// core/widgets/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations (faster since no native splash delay)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Start animation
    _animationController.forward();

    // Navigate to next screen after 1 second (reduced for testing)
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() async {
    // Show splash for at least 1 second for branding
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    try {
      final storage = GetStorage();

      // Debug: Print current storage values
      print('=== SPLASH SCREEN DEBUG ===');
      print('hasSeenOnboarding: ${storage.read('hasSeenOnboarding')}');
      print('is_authenticated: ${storage.read('is_authenticated')}');
      print('user_email: ${storage.read('user_email')}');
      print('===========================');

      // Force navigation to sign in screen for testing
      // TODO: Remove this after testing
      print('🔐 TEST MODE: Navigating to sign in screen');
      Get.offNamed('/signin');

      /* Original logic - uncomment after testing
      final hasSeenOnboarding = storage.read('hasSeenOnboarding') ?? false;
      final isAuthenticated = storage.read('is_authenticated') ?? false;

      if (!hasSeenOnboarding) {
        print('🔄 Navigating to onboarding (first time user)');
        Get.offNamed('/onboarding');
      } else if (!isAuthenticated) {
        print('🔐 Navigating to sign in (not authenticated)');
        Get.offNamed('/signin');
      } else {
        print('🏠 Navigating to home (authenticated user)');
        Get.offNamed('/');
      }
      */
    } catch (e) {
      print('❌ Error in splash navigation: $e');
      // Fallback to sign in screen if there's an error
      Get.offNamed('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          children: [
            // Background Gradient (fallback if image doesn't exist)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A00E0), // Purple
                    Color(0xFF8E2DE2), // Pink/Purple
                    Color(0xFF000000), // Black
                  ],
                ),
              ),
            ),
            // Optional overlay gradient for better text readability if needed
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            // Animated logo or text in center
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Optional: Add a subtle logo or app name on top of the background
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'DailyOS',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withValues(alpha:0.9),
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )],
          
        ),
      ),
    );
  }
}