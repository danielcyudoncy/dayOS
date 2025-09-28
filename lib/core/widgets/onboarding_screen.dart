// core/widgets/onboarding_screen.dart
import 'package:day_os/core/widgets/onboarding_page.dart';
import 'package:day_os/core/theme/font_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

export 'package:day_os/core/widgets/onboarding_page.dart' show OnboardingPageData;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1a1a2e), // Dark background
      Color(0xFF8B5CF6), // Purple
    ],
  );

  final List<OnboardingPageData> _pages = [
    const OnboardingPageData(
      title: "Your Day, Perfectly Orchestrated",
      description: "Meet your AI-powered daily assistant that seamlessly blends work productivity with personal wellness — so you can thrive, not just survive",
      imagePath: "assets/images/onboarding1.png",
      gradient: _defaultGradient,
    ),
    const OnboardingPageData(
      title: "Work Smarter, Not Harder",
      description: "Auto-join meetings, get AI-powered summaries with action items, and turn discussions into tasks — all while you focus on what matters most",
      imagePath: "assets/images/onboarding2.png",
      gradient: _defaultGradient,
    ),
    const OnboardingPageData(
      title: "Nourish Your Body, Fuel Your Mind",
      description: "Get balanced meal suggestions, auto-generated grocery lists, and smart reminders that adapt to your schedule — because peak performance starts with wellness",
      imagePath: "assets/images/onboarding3.png",
      gradient: _defaultGradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _pages[_currentPage].gradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      "Skip",
                      style: FontUtil.bodyLarge(
                        color: Colors.white,
                        fontWeight: FontWeights.medium,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      data: _pages[index],
                    );
                  },
                ),
              ),

              // Page indicators and next button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicators
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                               ? Colors.white
                               : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Next/Get Started button
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1a1a2e),
                        elevation: 2,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                        style: FontUtil.bodyLarge(
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    final storage = GetStorage();
    storage.write('hasSeenOnboarding', true);

    // Check if user is authenticated
    final isAuthenticated = storage.read('is_authenticated') ?? false;

    if (isAuthenticated) {
      // User is authenticated, go to home
      Get.offAllNamed('/');
    } else {
      // User is not authenticated, show sign in screen
      Get.offAllNamed('/signin');
    }
  }
}
