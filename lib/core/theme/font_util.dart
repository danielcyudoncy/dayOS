// core/theme/font_util.dart
import 'package:flutter/material.dart';

// Font weight mappings for Raleway variants
class FontWeights {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

// Typography sizes
class FontSizes {
  // Display styles
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;

  // Headline styles
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;

  // Title styles
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;

  // Body styles
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  // Label styles
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;

  // Caption
  static const double caption = 12.0;
}

// Line heights for different text sizes
class LineHeights {
  static const double tight = 1.0;
  static const double normal = 1.2;
  static const double relaxed = 1.4;
  static const double loose = 1.6;
  static const double extraLoose = 1.8;
}

class FontUtil {
  // Base font family
  static const String fontFamily = 'Raleway';

  // Get font weight by name
  static FontWeight getFontWeight(String weight) {
    switch (weight.toLowerCase()) {
      case 'thin':
        return FontWeights.thin;
      case 'extralight':
        return FontWeights.extraLight;
      case 'light':
        return FontWeights.light;
      case 'regular':
        return FontWeights.regular;
      case 'medium':
        return FontWeights.medium;
      case 'semibold':
        return FontWeights.semiBold;
      case 'bold':
        return FontWeights.bold;
      case 'extrabold':
        return FontWeights.extraBold;
      case 'black':
        return FontWeights.black;
      default:
        return FontWeights.regular;
    }
  }

  // Display text styles
  static TextStyle displayLarge({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.displayLarge,
      fontWeight: fontWeight ?? FontWeights.bold,
      color: color,
      height: height ?? LineHeights.tight,
      decoration: decoration,
    );
  }

  static TextStyle displayMedium({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.displayMedium,
      fontWeight: fontWeight ?? FontWeights.bold,
      color: color,
      height: height ?? LineHeights.tight,
      decoration: decoration,
    );
  }

  static TextStyle displaySmall({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.displaySmall,
      fontWeight: fontWeight ?? FontWeights.bold,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  // Headline text styles
  static TextStyle headlineLarge({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.headlineLarge,
      fontWeight: fontWeight ?? FontWeights.bold,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  static TextStyle headlineMedium({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.headlineMedium,
      fontWeight: fontWeight ?? FontWeights.semiBold,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  static TextStyle headlineSmall({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.headlineSmall,
      fontWeight: fontWeight ?? FontWeights.semiBold,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  // Title text styles
  static TextStyle titleLarge({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.titleLarge,
      fontWeight: fontWeight ?? FontWeights.medium,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  static TextStyle titleMedium({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.titleMedium,
      fontWeight: fontWeight ?? FontWeights.medium,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  static TextStyle titleSmall({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.titleSmall,
      fontWeight: fontWeight ?? FontWeights.medium,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  // Body text styles
  static TextStyle bodyLarge({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.bodyLarge,
      fontWeight: fontWeight ?? FontWeights.regular,
      color: color,
      height: height ?? LineHeights.relaxed,
      decoration: decoration,
    );
  }

  static TextStyle bodyMedium({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.bodyMedium,
      fontWeight: fontWeight ?? FontWeights.regular,
      color: color,
      height: height ?? LineHeights.relaxed,
      decoration: decoration,
    );
  }

  static TextStyle bodySmall({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.bodySmall,
      fontWeight: fontWeight ?? FontWeights.regular,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  // Label text styles
  static TextStyle labelLarge({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.labelLarge,
      fontWeight: fontWeight ?? FontWeights.medium,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  static TextStyle labelMedium({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.labelMedium,
      fontWeight: fontWeight ?? FontWeights.medium,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  static TextStyle labelSmall({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.labelSmall,
      fontWeight: fontWeight ?? FontWeights.medium,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  // Caption text style
  static TextStyle caption({
    Color? color,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: FontSizes.caption,
      fontWeight: fontWeight ?? FontWeights.regular,
      color: color,
      height: height ?? LineHeights.normal,
      decoration: decoration,
    );
  }

  // Custom text style builder
  static TextStyle custom({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    String? fontFamilyOverride,
  }) {
    return TextStyle(
      fontFamily: fontFamilyOverride ?? fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeights.regular,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Get text theme for ThemeData
  static TextTheme getTextTheme({Color? color}) {
    return TextTheme(
      displayLarge: displayLarge(color: color, fontWeight: FontWeights.light),
      displayMedium: displayMedium(color: color, fontWeight: FontWeights.light),
      displaySmall: displaySmall(color: color, fontWeight: FontWeights.regular),
      headlineLarge: headlineLarge(color: color, fontWeight: FontWeights.regular),
      headlineMedium: headlineMedium(color: color, fontWeight: FontWeights.regular),
      headlineSmall: headlineSmall(color: color, fontWeight: FontWeights.regular),
      titleLarge: titleLarge(color: color, fontWeight: FontWeights.medium),
      titleMedium: titleMedium(color: color, fontWeight: FontWeights.medium),
      titleSmall: titleSmall(color: color, fontWeight: FontWeights.medium),
      bodyLarge: bodyLarge(color: color, fontWeight: FontWeights.regular),
      bodyMedium: bodyMedium(color: color, fontWeight: FontWeights.regular),
      bodySmall: bodySmall(color: color, fontWeight: FontWeights.regular),
      labelLarge: labelLarge(color: color, fontWeight: FontWeights.medium),
      labelMedium: labelMedium(color: color, fontWeight: FontWeights.medium),
      labelSmall: labelSmall(color: color, fontWeight: FontWeights.medium),
    );
  }
}