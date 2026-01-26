import 'package:flutter/material.dart';

/// Application color palette with historical/elegant aesthetic
class AppColors {
  AppColors._();

  // Primary Colors - Rich Gold & Maroon theme
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color primaryGoldLight = Color(0xFFE8C547);
  static const Color primaryGoldDark = Color(0xFFB8963D);

  static const Color primaryMaroon = Color(0xFF800020);
  static const Color primaryMaroonLight = Color(0xFFA52A2A);
  static const Color primaryMaroonDark = Color(0xFF5C0015);

  // Secondary Colors
  static const Color secondaryOlive = Color(0xFF556B2F);
  static const Color secondaryTeal = Color(0xFF008080);
  static const Color secondaryNavy = Color(0xFF1B365D);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAF8F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFFFFFFF8);
  static const Color surfaceDark = Color(0xFF242424);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF4A4A4A);
  static const Color textTertiaryLight = Color(0xFF7A7A7A);

  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textTertiaryDark = Color(0xFF808080);

  // Era Colors
  static const Color eraSultanate = Color(0xFF2E7D32);          // Deep Green
  static const Color eraMughal = Color(0xFF7B1FA2);             // Purple
  static const Color eraBritishRaj = Color(0xFF1565C0);         // Blue
  static const Color eraBritishResistance = Color(0xFFC62828);  // Red
  static const Color eraLanguageMovement = Color(0xFFFB8C00);   // Orange
  static const Color eraLiberation1971 = Color(0xFF00695C);     // Teal

  // Category Colors
  static const Color categoryMartyr = Color(0xFFD32F2F);
  static const Color categoryRevolutionary = Color(0xFFE64A19);
  static const Color categoryIntellectual = Color(0xFF0288D1);
  static const Color categoryRuler = Color(0xFF7C4DFF);
  static const Color categoryPoet = Color(0xFFE91E63);
  static const Color categoryPhilosopher = Color(0xFF00897B);
  static const Color categorySoldier = Color(0xFF5D4037);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGoldLight, primaryGold, primaryGoldDark],
  );

  static const LinearGradient maroonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryMaroonLight, primaryMaroon, primaryMaroonDark],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black87],
  );

  static const LinearGradient introGradientLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAF8F5),
      Color(0xFFF5EFE6),
      Color(0xFFEDE4D3),
    ],
  );

  static const LinearGradient introGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1A1A),
      Color(0xFF2D2D2D),
      Color(0xFF1A1A1A),
    ],
  );

  /// Get era color by era ID
  static Color getEraColor(String eraId) {
    switch (eraId) {
      case 'sultanate':
        return eraSultanate;
      case 'mughal':
        return eraMughal;
      case 'british_raj':
        return eraBritishRaj;
      case 'british_resistance':
        return eraBritishResistance;
      case 'language_movement':
        return eraLanguageMovement;
      case 'liberation_1971':
        return eraLiberation1971;
      default:
        return primaryMaroon;
    }
  }

  /// Get category color by category ID
  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'martyr':
        return categoryMartyr;
      case 'revolutionary':
        return categoryRevolutionary;
      case 'intellectual':
        return categoryIntellectual;
      case 'ruler':
        return categoryRuler;
      case 'poet':
        return categoryPoet;
      case 'philosopher':
        return categoryPhilosopher;
      case 'soldier':
        return categorySoldier;
      default:
        return primaryGold;
    }
  }
}
