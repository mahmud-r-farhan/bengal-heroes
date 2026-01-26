import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Application typography system
class AppTypography {
  AppTypography._();

  // Base font families
  static String get _primaryFontFamily => GoogleFonts.playfairDisplay().fontFamily!;
  static String get _secondaryFontFamily => GoogleFonts.lora().fontFamily!;
  static String get _bodyFontFamily => GoogleFonts.sourceSans3().fontFamily!;
  static String get _banglaPrimaryFontFamily => 'Hind Siliguri';

  /// Get text theme based on locale
  static TextTheme getTextTheme(bool isDark, {bool isBangla = false}) {
    final Color textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final Color secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final String displayFont = isBangla ? _banglaPrimaryFontFamily : _primaryFontFamily;
    final String bodyFont = isBangla ? _banglaPrimaryFontFamily : _bodyFontFamily;
    final String titleFont = isBangla ? _banglaPrimaryFontFamily : _secondaryFontFamily;

    return TextTheme(
      // Display styles - for hero names and large headings
      displayLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: 57,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        color: textColor,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: 45,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: textColor,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontFamily: displayFont,
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
        height: 1.22,
      ),

      // Headline styles - for section headings
      headlineLarge: TextStyle(
        fontFamily: titleFont,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: titleFont,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontFamily: titleFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
        height: 1.33,
      ),

      // Title styles - for cards and list items
      titleLarge: TextStyle(
        fontFamily: titleFont,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: textColor,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textColor,
        height: 1.43,
      ),

      // Body styles - for content
      bodyLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.25,
        color: secondaryTextColor,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.4,
        color: secondaryTextColor,
        height: 1.33,
      ),

      // Label styles - for buttons and chips
      labelLarge: TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textColor,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: textColor,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: secondaryTextColor,
        height: 1.45,
      ),
    );
  }

  // Special text styles
  static TextStyle get quoteStyle => TextStyle(
        fontFamily: _secondaryFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.5,
        height: 1.6,
      );

  static TextStyle get dateStyle => TextStyle(
        fontFamily: _bodyFontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        height: 1.4,
      );

  static TextStyle get tagStyle => TextStyle(
        fontFamily: _bodyFontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        height: 1.4,
      );
}
