import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../models/models.dart';

/// Local data source for loading JSON data from assets
class LocalDataSource {
  LocalDataSource._();
  static final LocalDataSource instance = LocalDataSource._();

  // Cached data
  List<Hero>? _heroes;
  List<Era>? _eras;
  List<Category>? _categories;
  List<GlobalEvent>? _events;
  List<Location>? _locations;
  List<TimelineEvent>? _timelineEvents;
  List<TimelineEvent>? _travelerEvents;

  /// Load all data from assets
  Future<void> loadAllData() async {
    await Future.wait([
      loadHeroes(),
      loadEras(),
      loadCategories(),
      loadEvents(),
      loadLocations(),
      loadTimelineEvents(),
      loadTravelers(),
    ]);
  }

  /// Load heroes from JSON
  Future<List<Hero>> loadHeroes() async {
    if (_heroes != null) return _heroes!;

    try {
      final String jsonString =
          await rootBundle.loadString(AppConstants.heroesDataFile);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _heroes = jsonList
          .map((e) => Hero.fromJson(e as Map<String, dynamic>))
          .toList();
      return _heroes!;
    } catch (e) {
      // Error loading heroes
      return [];
    }
  }

  /// Load eras from JSON
  Future<List<Era>> loadEras() async {
    if (_eras != null) return _eras!;

    try {
      final String jsonString =
          await rootBundle.loadString(AppConstants.erasDataFile);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _eras =
          jsonList.map((e) => Era.fromJson(e as Map<String, dynamic>)).toList();
      _eras!.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return _eras!;
    } catch (e) {
      // Error loading eras
      return [];
    }
  }

  /// Load categories from JSON
  Future<List<Category>> loadCategories() async {
    if (_categories != null) return _categories!;

    try {
      final String jsonString =
          await rootBundle.loadString(AppConstants.categoriesDataFile);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _categories = jsonList
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      return _categories!;
    } catch (e) {
      // Error loading categories
      return [];
    }
  }

  /// Load events from JSON
  Future<List<GlobalEvent>> loadEvents() async {
    if (_events != null) return _events!;

    try {
      final String jsonString =
          await rootBundle.loadString(AppConstants.eventsDataFile);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _events = jsonList
          .map((e) => GlobalEvent.fromJson(e as Map<String, dynamic>))
          .toList();
      return _events!;
    } catch (e) {
      // Error loading events
      return [];
    }
  }

  /// Load locations from JSON
  Future<List<Location>> loadLocations() async {
    if (_locations != null) return _locations!;

    try {
      final String jsonString =
          await rootBundle.loadString(AppConstants.locationsDataFile);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _locations = jsonList
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList();
      return _locations!;
    } catch (e) {
      // Error loading locations
      return [];
    }
  }

  /// Get hero by ID
  Future<Hero?> getHeroById(String id) async {
    final heroes = await loadHeroes();
    try {
      return heroes.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get hero by slug
  Future<Hero?> getHeroBySlug(String slug) async {
    final heroes = await loadHeroes();
    try {
      return heroes.firstWhere((h) => h.slug == slug);
    } catch (_) {
      return null;
    }
  }

  /// Get era by ID
  Future<Era?> getEraById(String id) async {
    final eras = await loadEras();
    try {
      return eras.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get category by ID
  Future<Category?> getCategoryById(String id) async {
    final categories = await loadCategories();
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get heroes by era ID
  Future<List<Hero>> getHeroesByEra(String eraId) async {
    final heroes = await loadHeroes();
    return heroes.where((h) => h.eraId == eraId).toList();
  }

  /// Get heroes by category ID
  Future<List<Hero>> getHeroesByCategory(String categoryId) async {
    final heroes = await loadHeroes();
    return heroes.where((h) => h.categoryIds.contains(categoryId)).toList();
  }

  /// Get heroes matching a specific date (for "On This Day")
  Future<List<Hero>> getHeroesOnDate(int month, int day) async {
    final heroes = await loadHeroes();
    return heroes.where((h) => h.matchesDate(month, day)).toList();
  }

  /// Get events matching a specific date
  Future<List<GlobalEvent>> getEventsOnDate(int month, int day) async {
    final events = await loadEvents();
    return events.where((e) => e.matchesDate(month, day)).toList();
  }

  /// Load timeline events from JSON
  Future<List<TimelineEvent>> loadTimelineEvents() async {
    if (_timelineEvents != null) return _timelineEvents!;

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/timeline.json');
      final Map<String, dynamic> jsonMap =
          json.decode(jsonString) as Map<String, dynamic>;
      final List<dynamic> events =
          jsonMap['timeline_events'] as List<dynamic>;
      _timelineEvents = events
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList();
      return _timelineEvents!;
    } catch (e) {
      // Error loading timeline events
      return [];
    }
  }

  /// Get all timeline events
  Future<List<TimelineEvent>> getTimelineEvents() async {
    return loadTimelineEvents();
  }

  /// Load travelers from JSON
  Future<List<TimelineEvent>> loadTravelers() async {
    if (_travelerEvents != null) return _travelerEvents!;

    try {
      final String jsonString =
          await rootBundle.loadString(AppConstants.travelersDataFile);
      final Map<String, dynamic> jsonMap =
          json.decode(jsonString) as Map<String, dynamic>;
      final List<dynamic> events =
          jsonMap['timeline_events'] as List<dynamic>;
      _travelerEvents = events
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList();
      return _travelerEvents!;
    } catch (e) {
      // Error loading traveler events
      return [];
    }
  }

  /// Get all traveler events
  Future<List<TimelineEvent>> getTravelers() async {
    return loadTravelers();
  }

  /// Clear cache (for refresh)
  void clearCache() {
    _heroes = null;
    _eras = null;
    _categories = null;
    _events = null;
    _locations = null;
    _timelineEvents = null;
    _travelerEvents = null;
  }
}

