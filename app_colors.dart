import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Sankar Group Corporate Palette)
  static const Color primary = Color(0xFF0F3B66); // Deep Sankar Industrial Navy
  static const Color primaryDark = Color(0xFF08223B);
  static const Color primaryLight = Color(0xFF1E568F);
  static const Color accent = Color(0xFF00A3E0); // Precision Engineering Cyan
  static const Color accentDark = Color(0xFF007AAB);

  // Secondary & Accents
  static const Color secondary = Color(0xFF2B3A42);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Neutral Light
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // Neutral Dark
  static const Color backgroundDark = Color(0xFF0B1320);
  static const Color surfaceDark = Color(0xFF152238);
  static const Color cardDark = Color(0xFF1A2A44);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF263956);
  static const Color dividerDark = Color(0xFF1E2F48);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F3B66), Color(0xFF1E568F)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00A3E0), Color(0xFF0F3B66)],
  );
}
