/// Localized content for a hero
class LocalizedContent {
  final String name;
  final String shortBio;
  final String fullBiography;
  final String? quote;
  final String? birthPlace;
  final String? achievements;

  const LocalizedContent({
    required this.name,
    required this.shortBio,
    required this.fullBiography,
    this.quote,
    this.birthPlace,
    this.achievements,
  });

  factory LocalizedContent.fromJson(Map<String, dynamic> json) {
    return LocalizedContent(
      name: json['name'] as String,
      shortBio: json['short_bio'] as String,
      fullBiography: json['full_biography'] as String,
      quote: json['quote'] as String?,
      birthPlace: json['birth_place'] as String?,
      achievements: json['achievements'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'short_bio': shortBio,
      'full_biography': fullBiography,
      if (quote != null) 'quote': quote,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (achievements != null) 'achievements': achievements,
    };
  }

  LocalizedContent copyWith({
    String? name,
    String? shortBio,
    String? fullBiography,
    String? quote,
    String? birthPlace,
    String? achievements,
  }) {
    return LocalizedContent(
      name: name ?? this.name,
      shortBio: shortBio ?? this.shortBio,
      fullBiography: fullBiography ?? this.fullBiography,
      quote: quote ?? this.quote,
      birthPlace: birthPlace ?? this.birthPlace,
      achievements: achievements ?? this.achievements,
    );
  }
}

/// Date information for a hero
class HeroDates {
  final String? birth;
  final String? death;
  final List<HistoricalEvent>? events;

  const HeroDates({
    this.birth,
    this.death,
    this.events,
  });

  factory HeroDates.fromJson(Map<String, dynamic> json) {
    return HeroDates(
      birth: json['birth'] as String?,
      death: json['death'] as String?,
      events: json['events'] != null
          ? (json['events'] as List)
              .map((e) => HistoricalEvent.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (birth != null) 'birth': birth,
      if (death != null) 'death': death,
      if (events != null) 'events': events!.map((e) => e.toJson()).toList(),
    };
  }

  /// Check if birth matches given month and day
  bool matchesBirthDate(int month, int day) {
    if (birth == null) return false;
    try {
      final parts = birth!.split('-');
      if (parts.length >= 3) {
        return int.parse(parts[1]) == month && int.parse(parts[2]) == day;
      }
    } catch (_) {}
    return false;
  }

  /// Check if death matches given month and day
  bool matchesDeathDate(int month, int day) {
    if (death == null) return false;
    try {
      final parts = death!.split('-');
      if (parts.length >= 3) {
        return int.parse(parts[1]) == month && int.parse(parts[2]) == day;
      }
    } catch (_) {}
    return false;
  }

  /// Get formatted birth year
  String? get birthYear {
    if (birth == null) return null;
    try {
      return birth!.split('-')[0];
    } catch (_) {
      return null;
    }
  }

  /// Get formatted death year
  String? get deathYear {
    if (death == null) return null;
    try {
      return death!.split('-')[0];
    } catch (_) {
      return null;
    }
  }

  /// Get life span string (e.g., "1782-1831")
  String get lifeSpan {
    if (birthYear != null && deathYear != null) {
      return '$birthYear - $deathYear';
    } else if (birthYear != null) {
      return 'Born $birthYear';
    } else if (deathYear != null) {
      return 'Died $deathYear';
    }
    return '';
  }
}

/// Historical event associated with a hero
class HistoricalEvent {
  final String date;
  final Map<String, String> title;
  final Map<String, String> description;

  const HistoricalEvent({
    required this.date,
    required this.title,
    required this.description,
  });

  factory HistoricalEvent.fromJson(Map<String, dynamic> json) {
    return HistoricalEvent(
      date: json['date'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'title': title,
      'description': description,
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
}

/// Hero model representing a historical figure
class Hero {
  final String id;
  final String slug;
  final HeroDates dates;
  final String eraId;
  final List<String> categoryIds;
  final List<String> images;
  final Map<String, LocalizedContent> content;
  final String? locationId;
  final List<String>? relatedHeroIds;
  final int? importance; // 1-5, higher = more important

  const Hero({
    required this.id,
    required this.slug,
    required this.dates,
    required this.eraId,
    required this.categoryIds,
    required this.images,
    required this.content,
    this.locationId,
    this.relatedHeroIds,
    this.importance,
  });

  factory Hero.fromJson(Map<String, dynamic> json) {
    final contentMap = <String, LocalizedContent>{};
    final contentJson = json['content'] as Map<String, dynamic>;
    contentJson.forEach((key, value) {
      contentMap[key] = LocalizedContent.fromJson(value as Map<String, dynamic>);
    });

    return Hero(
      id: json['id'] as String,
      slug: json['slug'] as String,
      dates: HeroDates.fromJson(json['dates'] as Map<String, dynamic>),
      eraId: json['era'] as String,
      categoryIds: List<String>.from(json['category'] as List),
      images: List<String>.from(json['images'] as List),
      content: contentMap,
      locationId: json['location_id'] as String?,
      relatedHeroIds: json['related_hero_ids'] != null
          ? List<String>.from(json['related_hero_ids'] as List)
          : null,
      importance: json['importance'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'dates': dates.toJson(),
      'era': eraId,
      'category': categoryIds,
      'images': images,
      'content': content.map((key, value) => MapEntry(key, value.toJson())),
      if (locationId != null) 'location_id': locationId,
      if (relatedHeroIds != null) 'related_hero_ids': relatedHeroIds,
      if (importance != null) 'importance': importance,
    };
  }

  /// Get content for specified locale (falls back to English)
  LocalizedContent getContent(String locale) {
    return content[locale] ?? content['en']!;
  }

  /// Get hero name for specified locale
  String getName(String locale) => getContent(locale).name;

  /// Get short bio for specified locale
  String getShortBio(String locale) => getContent(locale).shortBio;

  /// Get primary image path
  String get primaryImage => images.isNotEmpty ? images.first : '';

  /// Check if hero matches given date (birth or death)
  bool matchesDate(int month, int day) {
    return dates.matchesBirthDate(month, day) ||
        dates.matchesDeathDate(month, day);
  }

  /// Check if hero has birth on given date
  bool hasBirthOnDate(int month, int day) => dates.matchesBirthDate(month, day);

  /// Check if hero has death on given date
  bool hasDeathOnDate(int month, int day) => dates.matchesDeathDate(month, day);

  Hero copyWith({
    String? id,
    String? slug,
    HeroDates? dates,
    String? eraId,
    List<String>? categoryIds,
    List<String>? images,
    Map<String, LocalizedContent>? content,
    String? locationId,
    List<String>? relatedHeroIds,
    int? importance,
  }) {
    return Hero(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      dates: dates ?? this.dates,
      eraId: eraId ?? this.eraId,
      categoryIds: categoryIds ?? this.categoryIds,
      images: images ?? this.images,
      content: content ?? this.content,
      locationId: locationId ?? this.locationId,
      relatedHeroIds: relatedHeroIds ?? this.relatedHeroIds,
      importance: importance ?? this.importance,
    );
  }
}
