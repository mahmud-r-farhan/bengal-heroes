import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Bengal Heroes';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A tribute to the legends, freedom fighters, and intellectuals of Bengal';

  // Supported Locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('bn'),
  ];

  static const Locale defaultLocale = Locale('en');
  static const String translationsPath = 'assets/translations';

  // Asset Paths
  static const String imagesPath = 'assets/images';
  static const String dataPath = 'assets/data';
  static const String iconsPath = 'assets/icons';

  // Data Files
  static const String heroesDataFile = 'assets/data/heroes.json';
  static const String erasDataFile = 'assets/data/eras.json';
  static const String categoriesDataFile = 'assets/data/categories.json';
  static const String eventsDataFile = 'assets/data/events.json';
  static const String locationsDataFile = 'assets/data/locations.json';
  static const String travelersDataFile = 'assets/data/travelers.json';

  // Pagination
  static const int pageSize = 20;

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 350);
  static const Duration longDuration = Duration(milliseconds: 500);

  // SharedPreferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyThemeMode = 'theme_mode';
  static const String keySelectedLocale = 'selected_locale';
  static const String keyFavoriteHeroes = 'favorite_heroes';

  // Era IDs
  static const String eraSultanate = 'sultanate';
  static const String eraMughal = 'mughal';
  static const String eraBritishRaj = 'british_raj';
  static const String eraBritishResistance = 'british_resistance';
  static const String eraLanguageMovement = 'language_movement';
  static const String eraLiberation1971 = 'liberation_1971';

  // Category IDs
  static const String categoryMartyr = 'martyr';
  static const String categoryRevolutionary = 'revolutionary';
  static const String categoryIntellectual = 'intellectual';
  static const String categoryRuler = 'ruler';
  static const String categoryPoet = 'poet';
  static const String categoryPhilosopher = 'philosopher';
  static const String categorySoldier = 'soldier';
}
