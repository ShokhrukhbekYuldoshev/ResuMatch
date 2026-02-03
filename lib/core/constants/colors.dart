import 'package:flutter/material.dart';

class BrandColors {
  // Brand Identity
  static const Color primaryBlue = Color(0xFF2D62ED);
  static const Color accentPurple = Color(0xFF7B61FF);
  static const List<Color> primaryGradient = [primaryBlue, accentPurple];

  // Light Mode Palette
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Dark Mode Palette
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}
