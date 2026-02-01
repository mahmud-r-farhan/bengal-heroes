import 'package:fuzzy/fuzzy.dart';

import '../datasources/local_data_source.dart';
import '../models/models.dart';

/// Filter options for heroes list
class HeroFilter {
  final List<String>? eraIds;
  final List<String>? categoryIds;
  final String? locationId;

  const HeroFilter({
    this.eraIds,
    this.categoryIds,
    this.locationId,
  });

  bool get isEmpty =>
      (eraIds == null || eraIds!.isEmpty) &&
      (categoryIds == null || categoryIds!.isEmpty) &&
      locationId == null;

  HeroFilter copyWith({
    List<String>? eraIds,
    List<String>? categoryIds,
    String? locationId,
  }) {
    return HeroFilter(
      eraIds: eraIds ?? this.eraIds,
      categoryIds: categoryIds ?? this.categoryIds,
      locationId: locationId ?? this.locationId,
    );
  }
}

/// Search result with score for ranking
class SearchResult {
  final Hero hero;
  final double score;
  final String matchedField;

  const SearchResult({
    required this.hero,
    required this.score,
    required this.matchedField,
  });
}

/// Repository for hero data operations
class HeroRepository {
  final LocalDataSource _dataSource;

  HeroRepository({LocalDataSource? dataSource})
      : _dataSource = dataSource ?? LocalDataSource.instance;

  // ============ HEROES ============

  /// Get all heroes
  Future<List<Hero>> getAllHeroes() async {
    return _dataSource.loadHeroes();
  }

  /// Get heroes with pagination
  Future<List<Hero>> getHeroesPaginated({
    int page = 0,
    int pageSize = 20,
    HeroFilter? filter,
  }) async {
    var heroes = await _dataSource.loadHeroes();

    // Apply filters
    if (filter != null && !filter.isEmpty) {
      heroes = heroes.where((hero) {
        // Filter by era
        if (filter.eraIds != null && filter.eraIds!.isNotEmpty) {
          if (!filter.eraIds!.contains(hero.eraId)) {
            return false;
          }
        }

        // Filter by category
        if (filter.categoryIds != null && filter.categoryIds!.isNotEmpty) {
          if (!hero.categoryIds.any((c) => filter.categoryIds!.contains(c))) {
            return false;
          }
        }

        // Filter by location
        if (filter.locationId != null) {
          if (hero.locationId != filter.locationId) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    // Sort by importance (higher first), then by name
    heroes.sort((a, b) {
      final importanceCompare =
          (b.importance ?? 0).compareTo(a.importance ?? 0);
      if (importanceCompare != 0) return importanceCompare;
      return a.getName('en').compareTo(b.getName('en'));
    });

    // Paginate
    final startIndex = page * pageSize;
    if (startIndex >= heroes.length) return [];

    final endIndex = (startIndex + pageSize).clamp(0, heroes.length);
    return heroes.sublist(startIndex, endIndex);
  }

  /// Get hero by ID
  Future<Hero?> getHeroById(String id) async {
    return _dataSource.getHeroById(id);
  }

  /// Get hero by slug
  Future<Hero?> getHeroBySlug(String slug) async {
    return _dataSource.getHeroBySlug(slug);
  }

  /// Get heroes by era
  Future<List<Hero>> getHeroesByEra(String eraId) async {
    return _dataSource.getHeroesByEra(eraId);
  }

  /// Get heroes by category
  Future<List<Hero>> getHeroesByCategory(String categoryId) async {
    return _dataSource.getHeroesByCategory(categoryId);
  }

  /// Get related heroes for a given hero
  Future<List<Hero>> getRelatedHeroes(Hero hero) async {
    if (hero.relatedHeroIds == null || hero.relatedHeroIds!.isEmpty) {
      // If no explicit relations, get heroes from same era
      final sameEraHeroes = await _dataSource.getHeroesByEra(hero.eraId);
      return sameEraHeroes.where((h) => h.id != hero.id).take(5).toList();
    }

    final relatedHeroes = <Hero>[];
    for (final relatedId in hero.relatedHeroIds!) {
      final relatedHero = await _dataSource.getHeroById(relatedId);
      if (relatedHero != null) {
        relatedHeroes.add(relatedHero);
      }
    }
    return relatedHeroes;
  }

  // ============ SEARCH ============

  /// Fuzzy search heroes - searches in BOTH English and Bengali content
  /// to allow users to search in either language regardless of app language setting
  Future<List<SearchResult>> searchHeroes(
    String query, {
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) return [];

    final heroes = await _dataSource.loadHeroes();
    final results = <SearchResult>[];

    // Create fuzzy matchers for different fields
    final options = FuzzyOptions(
      findAllMatches: true,
      tokenize: true,
      threshold: 0.4,
    );

    // Define locales to search in
    const locales = ['en', 'bn'];

    for (final hero in heroes) {
      double bestScore = 0;
      String matchedField = '';

      // Search in both English and Bengali content
      for (final locale in locales) {
        final content = hero.getContent(locale);

        // Search in name (highest weight)
        final nameFuzzy = Fuzzy([content.name], options: options);
        final nameResults = nameFuzzy.search(query);
        if (nameResults.isNotEmpty) {
          final score = (1 - nameResults.first.score) * 1.0; // Weight: 1.0
          if (score > bestScore) {
            bestScore = score;
            matchedField = 'name';
          }
        }

        // Search in short bio
        final bioFuzzy = Fuzzy([content.shortBio], options: options);
        final bioResults = bioFuzzy.search(query);
        if (bioResults.isNotEmpty) {
          final score = (1 - bioResults.first.score) * 0.6; // Weight: 0.6
          if (score > bestScore) {
            bestScore = score;
            matchedField = 'bio';
          }
        }

        // Search in era name (search both locales for era as well)
        final era = await _dataSource.getEraById(hero.eraId);
        if (era != null) {
          final eraFuzzy = Fuzzy([era.getName(locale)], options: options);
          final eraResults = eraFuzzy.search(query);
          if (eraResults.isNotEmpty) {
            final score = (1 - eraResults.first.score) * 0.5; // Weight: 0.5
            if (score > bestScore) {
              bestScore = score;
              matchedField = 'era';
            }
          }
        }
      }

      // Add to results if score is above threshold
      if (bestScore > 0.3) {
        results.add(SearchResult(
          hero: hero,
          score: bestScore,
          matchedField: matchedField,
        ));
      }
    }

    // Sort by score (descending) and limit
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(limit).toList();
  }

  // ============ ON THIS DAY ============

  /// Get heroes and events for "On This Day" feature
  Future<OnThisDayData> getOnThisDayData(DateTime date) async {
    final month = date.month;
    final day = date.day;

    final heroes = await _dataSource.getHeroesOnDate(month, day);
    final events = await _dataSource.getEventsOnDate(month, day);

    // Separate births and deaths
    final births = heroes.where((h) => h.hasBirthOnDate(month, day)).toList();
    final deaths = heroes.where((h) => h.hasDeathOnDate(month, day)).toList();

    return OnThisDayData(
      date: date,
      births: births,
      deaths: deaths,
      events: events,
    );
  }

  // ============ ERAS ============

  /// Get all eras
  Future<List<Era>> getAllEras() async {
    return _dataSource.loadEras();
  }

  /// Get era by ID
  Future<Era?> getEraById(String id) async {
    return _dataSource.getEraById(id);
  }

  /// Get era hero count
  Future<int> getEraHeroCount(String eraId) async {
    final heroes = await _dataSource.getHeroesByEra(eraId);
    return heroes.length;
  }

  // ============ CATEGORIES ============

  /// Get all categories
  Future<List<Category>> getAllCategories() async {
    return _dataSource.loadCategories();
  }

  /// Get category by ID
  Future<Category?> getCategoryById(String id) async {
    return _dataSource.getCategoryById(id);
  }

  /// Get category hero count
  Future<int> getCategoryHeroCount(String categoryId) async {
    final heroes = await _dataSource.getHeroesByCategory(categoryId);
    return heroes.length;
  }

  // ============ LOCATIONS ============

  /// Get all locations
  Future<List<Location>> getAllLocations() async {
    return _dataSource.loadLocations();
  }

  // ============ STATISTICS ============

  /// Get total hero count
  Future<int> getTotalHeroCount() async {
    final heroes = await _dataSource.loadHeroes();
    return heroes.length;
  }

  /// Get hero count by era
  Future<Map<String, int>> getHeroCountByEra() async {
    final heroes = await _dataSource.loadHeroes();
    final counts = <String, int>{};
    for (final hero in heroes) {
      counts[hero.eraId] = (counts[hero.eraId] ?? 0) + 1;
    }
    return counts;
  }
}

/// Data class for "On This Day" feature
class OnThisDayData {
  final DateTime date;
  final List<Hero> births;
  final List<Hero> deaths;
  final List<GlobalEvent> events;

  const OnThisDayData({
    required this.date,
    required this.births,
    required this.deaths,
    required this.events,
  });

  bool get isEmpty => births.isEmpty && deaths.isEmpty && events.isEmpty;
  bool get isNotEmpty => !isEmpty;

  int get totalItems => births.length + deaths.length + events.length;
}
