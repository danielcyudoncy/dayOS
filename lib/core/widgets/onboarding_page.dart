// core/widgets/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:day_os/core/theme/font_util.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final String imagePath;
  final Gradient gradient;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.gradient,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration/Image placeholder
          Expanded(
            flex: 3,
            child: Image.asset(
              data.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder when image is not found
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: FontUtil.headlineMedium(
              color: Colors.white,
              fontWeight: FontWeights.bold,
              height: LineHeights.normal,
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: FontUtil.bodyLarge(
              color: Colors.white.withValues(alpha: 0.95),
              height: LineHeights.relaxed,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}