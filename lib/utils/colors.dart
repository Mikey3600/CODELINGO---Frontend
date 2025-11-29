// filename: lib/utils/colors.dart
import 'package:flutter/material.dart';

/// Codelingo color palette - Duolingo-inspired vibrant colors
class AppColors {
  // Primary brand colors
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color primaryGreenDark = Color(0xFF46A302);
  static const Color accentBlue = Color(0xFF1CB0F6);
  static const Color accentBlueDark = Color(0xFF1899D6);
  
  // Status colors
  static const Color correctGreen = Color(0xFF58CC02);
  static const Color incorrectRed = Color(0xFFFF4B4B);
  static const Color warningYellow = Color(0xFFFFC800);
  static const Color lockedGray = Color(0xFFE5E5E5);
  
  // Background and surface colors
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  
  // Text colors
  static const Color textPrimary = Color(0xFF3C3C3C);
  static const Color textSecondary = Color(0xFF777777);
  static const Color textLight = Color(0xFFAFAFAF);
  
  // Progress and XP colors
  static const Color xpGold = Color(0xFFFFC800);
  static const Color streakOrange = Color(0xFFFF9600);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF58CC02), Color(0xFF46A302)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFC800), Color(0xFFFFB000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
