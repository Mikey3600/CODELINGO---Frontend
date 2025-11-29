// filename: lib/utils/ui_helpers.dart
import 'package:flutter/material.dart';

/// UI helper utilities for consistent spacing, shadows, and layout
class UIHelpers {
  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 999.0;
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ];
  
  static List<BoxShadow> innerShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];
  
  // Screen dimensions helper
  static double screenWidth(BuildContext context) => 
      MediaQuery.of(context).size.width;
  
  static double screenHeight(BuildContext context) => 
      MediaQuery.of(context).size.height;
  
  // Responsive sizing
  static double responsiveSize(BuildContext context, double size) {
    final width = screenWidth(context);
    // Base width is 375 (iPhone standard)
    return size * (width / 375.0);
  }
  
  // Safe padding helper
  static EdgeInsets safePadding(BuildContext context) =>
      MediaQuery.of(context).padding;
}
