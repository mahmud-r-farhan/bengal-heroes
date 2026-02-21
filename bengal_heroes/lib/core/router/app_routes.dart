/// Application route paths
class AppRoutes {
  AppRoutes._();

  // Main routes
  static const String intro = '/intro';
  static const String home = '/';
  static const String heroes = '/heroes';
  static const String search = '/search';
  static const String settings = '/settings';

  // Detail routes
  static const String heroDetail = '/hero';
  static const String heroesByEra = '/era';
  static const String heroesByCategory = '/category';
  static const String warMovements = '/war-movements';
  
  // Timeline event detail route
  static const String timelineEventDetail = '/timeline-event';

  // Helper methods for navigation
  static String getHeroDetailPath(String heroId) => '$heroDetail/$heroId';
  static String getHeroesByEraPath(String eraId) => '$heroesByEra/$eraId';
  static String getHeroesByCategoryPath(String categoryId) =>
      '$heroesByCategory/$categoryId';
  static String getWarMovementsPath(String categoryId) =>
      '$warMovements/$categoryId';
  static String getTimelineEventDetailPath(String eventId, String type) =>
      '$timelineEventDetail/$eventId/$type';
}