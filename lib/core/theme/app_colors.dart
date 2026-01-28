import 'package:flutter/material.dart';

// Bihar Cultural Theme Colors
// Inspired by: Madhubani art, Buddhist architecture, earthy tones
class AppColors {
  AppColors._();

  // Primary Colors - Deep Saffron (Spiritual Bihar)
  static const Color primary = Color(0xFFD4451A);
  static const Color primaryLight = Color(0xFFFF7043);
  static const Color primaryDark = Color(0xFFB33A14);

  // Secondary Colors - Royal Blue (Buddhist heritage)
  static const Color secondary = Color(0xFF1A5276);
  static const Color secondaryLight = Color(0xFF2980B9);
  static const Color secondaryDark = Color(0xFF154360);

  // Accent Colors - Golden (Temple gold)
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFE9C46A);
  static const Color accentDark = Color(0xFFB8860B);

  // Earthy Tones - Bihar Villages
  static const Color terracotta = Color(0xFFBC6C25);
  static const Color clay = Color(0xFFA0522D);
  static const Color wheat = Color(0xFFF5DEB3);
  static const Color olive = Color(0xFF606C38);

  // Background Colors
  static const Color background = Color(0xFFFAF8F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A2A2A);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Category Colors
  static const Color spiritual = Color(0xFFFF6B35);
  static const Color heritage = Color(0xFF8B4513);
  static const Color food = Color(0xFFE67E22);
  static const Color nature = Color(0xFF27AE60);
  static const Color adventure = Color(0xFF9B59B6);
  static const Color cultural = Color(0xFF3498DB);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x40000000), Color(0xCC000000)],
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFD4451A), Color(0xFFB33A14)],
  );

  static const LinearGradient heritageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B4513), Color(0xFFA0522D), Color(0xFFBC6C25)],
  );

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);

  // Category Color Map
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'spiritual':
        return spiritual;
      case 'heritage':
        return heritage;
      case 'food':
        return food;
      case 'nature':
        return nature;
      case 'adventure':
        return adventure;
      case 'cultural':
        return cultural;
      default:
        return primary;
    }
  }

  // Theme-aware color getters
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : background;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surfaceDark
        : surface;
  }

  static Color getCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardDark
        : cardLight;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textLight
        : textPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textMuted
        : textSecondary;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? borderDark
        : border;
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
