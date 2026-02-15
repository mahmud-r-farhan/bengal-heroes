import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'SharedPreferences not initialized - ensure it is provided in main()');
});

/// Provider for theme mode
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    try {
      final themeModeIndex = _prefs.getInt(AppConstants.keyThemeMode);
      if (themeModeIndex != null && 
          themeModeIndex >= 0 && 
          themeModeIndex < ThemeMode.values.length) {
        state = ThemeMode.values[themeModeIndex];
      } else {
        state = ThemeMode.system;
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      await _prefs.setInt(AppConstants.keyThemeMode, mode.index);
    } catch (e) {
      debugPrint('Error setting theme mode: $e');
    }
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
final isFirstLaunchProvider =
    StateNotifierProvider<IsFirstLaunchNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return IsFirstLaunchNotifier(prefs);
});

/// First launch state notifier
class IsFirstLaunchNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  IsFirstLaunchNotifier(this._prefs) : super(true) {
    _loadFirstLaunchState();
  }

  void _loadFirstLaunchState() {
    try {
      final isFirstLaunch = _prefs.getBool(AppConstants.keyIsFirstLaunch);
      if (isFirstLaunch != null) {
        state = isFirstLaunch;
      } else {
        // Default to true on first installation
        state = true;
        debugPrint('First launch state not found, defaulting to true');
      }
    } catch (e) {
      debugPrint('Error loading first launch state: $e');
      state = true; // Default to true on error
    }
  }

  Future<void> setFirstLaunchComplete() async {
    state = false;
    try {
      await _prefs.setBool(AppConstants.keyIsFirstLaunch, false);
    } catch (e) {
      debugPrint('Error setting first launch: $e');
    }
  }
}

/// Provider for selected locale
final selectedLocaleProvider =
    StateNotifierProvider<SelectedLocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SelectedLocaleNotifier(prefs);
});

/// Selected locale state notifier
class SelectedLocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;

  SelectedLocaleNotifier(this._prefs) : super(AppConstants.defaultLocale) {
    _loadLocale();
  }

  void _loadLocale() {
    try {
      final localeCode = _prefs.getString(AppConstants.keySelectedLocale);
      if (localeCode != null && localeCode.isNotEmpty) {
        state = Locale(localeCode);
      } else {
        state = AppConstants.defaultLocale;
      }
    } catch (e) {
      debugPrint('Error loading locale: $e');
      state = AppConstants.defaultLocale;
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      await _prefs.setString(AppConstants.keySelectedLocale, locale.languageCode);
    } catch (e) {
      debugPrint('Error setting locale: $e');
    }
  }
}

/// Provider for favorite heroes
final favoriteHeroesProvider =
    StateNotifierProvider<FavoriteHeroesNotifier, Set<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoriteHeroesNotifier(prefs);
});

/// Favorite heroes state notifier
class FavoriteHeroesNotifier extends StateNotifier<Set<String>> {
  final SharedPreferences _prefs;

  FavoriteHeroesNotifier(this._prefs) : super(<String>{}) {
    _loadFavorites();
  }

  void _loadFavorites() {
    try {
      final favorites = _prefs.getStringList(AppConstants.keyFavoriteHeroes);
      if (favorites != null) {
        state = Set<String>.from(favorites);
      } else {
        state = <String>{};
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      state = <String>{};
    }
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
      await _prefs.setStringList(AppConstants.keyFavoriteHeroes, newFavorites.toList());
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String heroId) => state.contains(heroId);
}

