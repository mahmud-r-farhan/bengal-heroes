import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for theme mode
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(AppConstants.keyThemeMode);
      if (themeModeIndex != null) {
        state = ThemeMode.values[themeModeIndex];
      }
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyThemeMode, mode.index);
    } catch (_) {}
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}

/// Provider for first launch state
final isFirstLaunchProvider = StateNotifierProvider<IsFirstLaunchNotifier, bool>((ref) {
  return IsFirstLaunchNotifier();
});

/// First launch state notifier
class IsFirstLaunchNotifier extends StateNotifier<bool> {
  IsFirstLaunchNotifier() : super(true) {
    _loadFirstLaunchState();
  }

  Future<void> _loadFirstLaunchState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;
      state = isFirstLaunch;
    } catch (_) {}
  }

  Future<void> setFirstLaunchComplete() async {
    state = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsFirstLaunch, false);
    } catch (_) {}
  }
}

/// Provider for selected locale
final selectedLocaleProvider =
    StateNotifierProvider<SelectedLocaleNotifier, Locale>((ref) {
  return SelectedLocaleNotifier();
});

/// Selected locale state notifier
class SelectedLocaleNotifier extends StateNotifier<Locale> {
  SelectedLocaleNotifier() : super(AppConstants.defaultLocale) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(AppConstants.keySelectedLocale);
      if (localeCode != null) {
        state = Locale(localeCode);
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keySelectedLocale, locale.languageCode);
    } catch (_) {}
  }
}

/// Provider for favorite heroes
final favoriteHeroesProvider =
    StateNotifierProvider<FavoriteHeroesNotifier, Set<String>>((ref) {
  return FavoriteHeroesNotifier();
});

/// Favorite heroes state notifier
class FavoriteHeroesNotifier extends StateNotifier<Set<String>> {
  FavoriteHeroesNotifier() : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList(AppConstants.keyFavoriteHeroes);
      if (favorites != null) {
        state = favorites.toSet();
      }
    } catch (_) {}
  }

  Future<void> toggleFavorite(String heroId) async {
    final newFavorites = Set<String>.from(state);
    if (newFavorites.contains(heroId)) {
      newFavorites.remove(heroId);
    } else {
      newFavorites.add(heroId);
    }
    state = newFavorites;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(AppConstants.keyFavoriteHeroes, newFavorites.toList());
    } catch (_) {}
  }

  bool isFavorite(String heroId) => state.contains(heroId);
}
