import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Color
  static const Color primary = Color(0xFFE8713C);
  static const Color primaryDark = Color(0xFFD85A30);
  static const Color primaryOrange = primary;

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Accent Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFAC775);
  static const Color error = Color(0xFFE24B4A);

  // UI Colors
  static const Color border = Color(0xFFE5E5E5);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color rating = Color(0xFFFAC775);
  // Logo / Auth headings
  static const Color navy = Color(0xFF1A2744);
  // Gradient (for budget card)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
