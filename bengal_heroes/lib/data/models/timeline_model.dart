/// Timeline event model representing a historical event in Bengal's timeline
class TimelineEvent {
  final String id;
  final int year;
  final String period;
  final LocalizedContent title;
  final LocalizedContent description;
  final String category;
  final String? empire;
  final String significance;
  final String icon;

  const TimelineEvent({
    required this.id,
    required this.year,
    required this.period,
    required this.title,
    required this.description,
    required this.category,
    this.empire,
    required this.significance,
    required this.icon,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['id'] as String,
      year: json['year'] as int,
      period: json['period'] as String,
      title: LocalizedContent.fromJson(json['title'] as Map<String, dynamic>),
      description: LocalizedContent.fromJson(
        json['description'] as Map<String, dynamic>,
      ),
      category: json['category'] as String,
      empire: json['empire'] as String?,
      significance: json['significance'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'year': year,
    'period': period,
    'title': title.toJson(),
    'description': description.toJson(),
    'category': category,
    'empire': empire,
    'significance': significance,
    'icon': icon,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          year == other.year &&
          period == other.period &&
          title == other.title &&
          description == other.description &&
          category == other.category &&
          empire == other.empire &&
          significance == other.significance &&
          icon == other.icon;

  @override
  int get hashCode =>
      id.hashCode ^
      year.hashCode ^
      period.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      empire.hashCode ^
      significance.hashCode ^
      icon.hashCode;

  @override
  String toString() {
    return 'TimelineEvent{id: $id, year: $year, category: $category}';
  }
}

/// Localized content for bilingual support
class LocalizedContent {
  final String en;
  final String bn;

  const LocalizedContent({
    required this.en,
    required this.bn,
  });

  factory LocalizedContent.fromJson(Map<String, dynamic> json) {
    return LocalizedContent(
      en: json['en'] as String,
      bn: json['bn'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'en': en,
    'bn': bn,
  };

  String getByLocale(String locale) {
    if (locale == 'bn') {
      return bn;
    }
    return en;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizedContent &&
          runtimeType == other.runtimeType &&
          en == other.en &&
          bn == other.bn;

  @override
  int get hashCode => en.hashCode ^ bn.hashCode;

  @override
  String toString() => 'LocalizedContent{en: $en, bn: $bn}';
}
