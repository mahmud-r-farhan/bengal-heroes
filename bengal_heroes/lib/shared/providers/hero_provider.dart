import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../data/repositories/hero_repository.dart';

/// Provider for HeroRepository instance
final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  return HeroRepository();
});

/// Provider for all heroes
final allHeroesProvider = FutureProvider<List<Hero>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getAllHeroes();
});

/// Provider for all eras
final allErasProvider = FutureProvider<List<Era>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getAllEras();
});

/// Provider for all categories
final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getAllCategories();
});

/// Provider for all locations
final allLocationsProvider = FutureProvider<List<Location>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getAllLocations();
});

/// Provider for hero filter state
final heroFilterProvider = StateProvider<HeroFilter>((ref) {
  return const HeroFilter();
});

/// Provider for filtered heroes with pagination
final filteredHeroesProvider =
    FutureProvider.family<List<Hero>, int>((ref, page) async {
  final repository = ref.watch(heroRepositoryProvider);
  final filter = ref.watch(heroFilterProvider);
  return repository.getHeroesPaginated(page: page, filter: filter);
});

/// Provider for hero by ID
final heroByIdProvider = FutureProvider.family<Hero?, String>((ref, id) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroById(id);
});

/// Provider for hero by slug
final heroBySlugProvider =
    FutureProvider.family<Hero?, String>((ref, slug) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroBySlug(slug);
});

/// Provider for heroes by era
final heroesByEraProvider =
    FutureProvider.family<List<Hero>, String>((ref, eraId) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroesByEra(eraId);
});

/// Provider for heroes by category
final heroesByCategoryProvider =
    FutureProvider.family<List<Hero>, String>((ref, categoryId) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroesByCategory(categoryId);
});

/// Provider for related heroes
final relatedHeroesProvider =
    FutureProvider.family<List<Hero>, Hero>((ref, hero) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getRelatedHeroes(hero);
});

/// Provider for era by ID
final eraByIdProvider = FutureProvider.family<Era?, String>((ref, id) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getEraById(id);
});

/// Provider for category by ID
final categoryByIdProvider =
    FutureProvider.family<Category?, String>((ref, id) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getCategoryById(id);
});

/// Provider for total hero count
final totalHeroCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getTotalHeroCount();
});

/// Provider for hero count by era
final heroCountByEraProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroCountByEra();
});

/// Provider for era hero count
final eraHeroCountProvider =
    FutureProvider.family<int, String>((ref, eraId) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getEraHeroCount(eraId);
});

/// Provider for category hero count
final categoryHeroCountProvider =
    FutureProvider.family<int, String>((ref, categoryId) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getCategoryHeroCount(categoryId);
});
