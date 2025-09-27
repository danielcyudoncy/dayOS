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

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: "Discover\nReal Benefits",
      description: "Experience the true power of mobile technology. Our solutions give you deep insights about your customers while providing them with exactly what they need from your business.",
      imagePath: "assets/images/onboarding1.png",
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1a1a2e), // Dark background
          Color(0xFF8B5CF6), // Purple
        ],
      ),
    ),
    OnboardingPageData(
      title: "Perfect\nControl",
      description: "Take charge with intuitive mobile controls designed for modern business management. Every feature is crafted to give you complete command over your operations.",
      imagePath: "assets/images/onboarding2.png",
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFf8f9fa), // Light background
          Color(0xFF6f42c1), // Purple
        ],
      ),
    ),
    OnboardingPageData(
      title: "Technology\nat Hand",
      description: "Advanced mobile solutions are now within everyone's reach. Join billions of users who rely on portable technology for daily business and personal productivity.",
      imagePath: "assets/images/onboarding3.png",
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1a1a2e), // Dark background
          Color(0xFFf97316), // Orange
        ],
      ),
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
                               : Colors.white.withValues(alpha: 0.5),
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
                        foregroundColor: const Color(0xFF8B5CF6),
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

    // Navigate to home screen
    Get.offAllNamed('/'); // This will clear all previous routes and go to home
  }
}
