/// Era model representing a historical period
class Era {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final String startYear;
  final String endYear;
  final String iconAsset;
  final String colorHex;
  final int sortOrder;

  const Era({
    required this.id,
    required this.name,
    required this.description,
    required this.startYear,
    required this.endYear,
    required this.iconAsset,
    required this.colorHex,
    required this.sortOrder,
  });

  factory Era.fromJson(Map<String, dynamic> json) {
    return Era(
      id: json['id'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      startYear: json['start_year'] as String,
      endYear: json['end_year'] as String,
      iconAsset: json['icon_asset'] as String,
      colorHex: json['color_hex'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_year': startYear,
      'end_year': endYear,
      'icon_asset': iconAsset,
      'color_hex': colorHex,
      'sort_order': sortOrder,
    };
  }

  /// Get name in specified locale
  String getName(String locale) => name[locale] ?? name['en'] ?? '';

  /// Get description in specified locale
  String getDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';

  /// Get period string (e.g., "1757-1947")
  String get period => '$startYear $endYear';
}

/// Category model representing hero classification
class Category {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final String iconAsset;
  final String colorHex;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.colorHex,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      iconAsset: json['icon_asset'] as String,
      colorHex: json['color_hex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_asset': iconAsset,
      'color_hex': colorHex,
    };
  }

  /// Get name in specified locale
  String getName(String locale) => name[locale] ?? name['en'] ?? '';

  /// Get description in specified locale
  String getDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';
}

/// Location model for geographical reference
class Location {
  final String id;
  final Map<String, String> name;
  final String? region;
  final double? latitude;
  final double? longitude;

  const Location({
    required this.id,
    required this.name,
    this.region,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: Map<String, String>.from(json['name'] as Map),
      region: json['region'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (region != null) 'region': region,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  /// Get name in specified locale
  String getName(String locale) => name[locale] ?? name['en'] ?? '';
}

/// Global historical event (not tied to a specific hero)
class GlobalEvent {
  final String id;
  final String date;
  final Map<String, String> title;
  final Map<String, String> description;
  final String? eraId;
  final List<String>? relatedHeroIds;
  final String? imageAsset;

  const GlobalEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    this.eraId,
    this.relatedHeroIds,
    this.imageAsset,
  });

  factory GlobalEvent.fromJson(Map<String, dynamic> json) {
    return GlobalEvent(
      id: json['id'] as String,
      date: json['date'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      eraId: json['era_id'] as String?,
      relatedHeroIds: json['related_hero_ids'] != null
          ? List<String>.from(json['related_hero_ids'] as List)
          : null,
      imageAsset: json['image_asset'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'description': description,
      if (eraId != null) 'era_id': eraId,
      if (relatedHeroIds != null) 'related_hero_ids': relatedHeroIds,
      if (imageAsset != null) 'image_asset': imageAsset,
    };
  }

  /// Get title in specified locale
  String getTitle(String locale) => title[locale] ?? title['en'] ?? '';

  /// Get description in specified locale
  String getDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';

  /// Check if event matches given month and day
  bool matchesDate(int month, int day) {
    try {
      final parts = date.split('-');
      if (parts.length >= 3) {
        return int.parse(parts[1]) == month && int.parse(parts[2]) == day;
      }
    } catch (_) {}
    return false;
  }

  /// Get year from date
  String? get year {
    try {
      return date.split('-')[0];
    } catch (_) {
      return null;
    }
  }
}
