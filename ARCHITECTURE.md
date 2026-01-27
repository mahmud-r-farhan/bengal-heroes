# Bengal Heroes App - Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture Layers](#architecture-layers)
3. [Project Structure](#project-structure)
4. [Design Patterns](#design-patterns)
5. [Data Flow](#data-flow)
6. [State Management](#state-management)
7. [Navigation](#navigation)
8. [Localization](#localization)
9. [Key Components](#key-components)
10. [Dependencies](#dependencies)
11. [Best Practices](#best-practices)
12. [Getting Started](#getting-started)

---

## Overview

**Bengal Heroes** is a Flutter application that showcases the lives and achievements of historical heroes from Bengal. The app employs a **Clean Architecture** pattern with clear separation of concerns, making it scalable, testable, and maintainable.

### Architecture Principles
- **Separation of Concerns:** Each layer has a specific responsibility
- **Dependency Injection:** Uses Riverpod for managing dependencies
- **Reactive Programming:** FutureProviders for async data handling
- **DRY (Don't Repeat Yourself):** Shared components and utilities
- **SOLID Principles:** Applied throughout the codebase

---

## Architecture Layers

### 1. **Presentation Layer** (`lib/features/`)
Handles UI/UX and user interactions.

```
├── home/                          # Home screen feature
│   ├── home_screen.dart          # Main screen
│   └── widgets/                  # Reusable components
│       ├── on_this_day_section.dart
│       ├── era_carousel.dart
│       ├── featured_heroes_section.dart
│       ├── war_collection_section.dart
│       └── timeline_section.dart
├── hero_detail/                  # Hero detail feature
│   └── hero_detail_screen.dart
├── heroes/                       # Heroes list feature
│   └── heroes_screen.dart
└── intro/                        # Intro feature
    └── intro_screen.dart
```

**Responsibilities:**
- Building UI widgets
- Handling user interactions
- Displaying data
- Managing UI state with Riverpod
- Triggering navigation events

**Key Files:**
- `home_screen.dart` - Main landing page
- `hero_detail_screen.dart` - Individual hero details
- `heroes_screen.dart` - Heroes list with filters
- `widgets/` - Reusable UI components

### 2. **Domain/Business Logic Layer** (`lib/shared/`)
Contains application logic, providers, and utilities.

```
├── providers/                    # Riverpod providers
│   ├── hero_provider.dart       # Hero-related providers
│   ├── on_this_day_provider.dart
│   ├── search_provider.dart
│   └── settings_provider.dart
├── widgets/                      # Shared UI components
│   ├── section_header.dart
│   ├── app_bottom_nav_bar.dart
│   └── custom_app_bar.dart
└── utils/                        # Utility functions
    ├── date_utils.dart
    └── string_utils.dart
```

**Responsibilities:**
- Providing reactive data via FutureProviders
- Business logic for filtering and searching
- Shared UI components
- Utility functions and helpers
- Settings and configuration

### 3. **Data Layer** (`lib/data/`)
Handles data access and management.

```
├── datasources/                  # Data sources
│   └── local_data_source.dart   # JSON asset loading
├── models/                       # Data models
│   ├── hero_model.dart
│   ├── category_era_model.dart
│   ├── timeline_model.dart
│   └── models.dart (exports)
└── repositories/                 # Repository pattern
    ├── hero_repository.dart
    └── timeline_repository.dart
```

**Responsibilities:**
- Data loading from JSON assets
- Data caching and management
- Model serialization/deserialization
- Repository interface implementation
- Data transformation

### 4. **Core Layer** (`lib/core/`)
Contains app-wide utilities and configurations.

```
├── constants/                    # App constants
│   ├── app_constants.dart
│   └── asset_paths.dart
├── router/                       # Navigation configuration
│   └── app_routes.dart
└── theme/                        # Theme and styling
    └── app_colors.dart
```

**Responsibilities:**
- Application constants
- Route definitions
- Theme colors
- App-wide configurations

---

## Project Structure

```
bengal_heroes/
│
├── android/                      # Android-specific code
│   ├── app/
│   └── gradle configurations
│
├── ios/                          # iOS-specific code
│   ├── Runner/
│   └── configuration
│
├── assets/                       # Static assets
│   ├── data/
│   │   ├── heroes.json          # Hero data (200+ heroes)
│   │   ├── categories.json      # Categories (8 types)
│   │   ├── eras.json            # Eras (5 periods)
│   │   ├── events.json          # Events (20+ events)
│   │   ├── locations.json       # Locations
│   │   └── timeline.json        # Timeline events (12 events)
│   ├── fonts/                   # Custom fonts
│   ├── icons/                   # SVG/PNG icons
│   ├── images/
│   │   └── heroes/              # Hero images (optional)
│   └── translations/
│       ├── en.json              # English translations
│       └── bn.json              # Bengali translations
│
├── lib/
│   ├── main.dart                # App entry point
│   ├── app.dart                 # App configuration
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── router/
│   │   └── theme/
│   │
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   │
│   ├── features/
│   │   ├── home/
│   │   ├── hero_detail/
│   │   ├── heroes/
│   │   ├── intro/
│   │   └── screen/
│   │
│   ├── shared/
│   │   ├── providers/
│   │   ├── widgets/
│   │   └── utils/
│   │
│   └── app.dart
│
├── web/                         # Web-specific code
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml                 # Dependencies
├── analysis_options.yaml         # Lint rules
└── README.md

```

---

## Design Patterns

### 1. **Repository Pattern**
Abstracts data access, allowing easy switching between data sources.

```dart
// Abstract interface
class HeroRepository {
  Future<List<Hero>> getAllHeroes();
  Future<Hero?> getHeroById(String id);
  Future<List<Hero>> getHeroesByCategory(String categoryId);
}

// Implementation
class HeroRepository {
  final LocalDataSource _dataSource;
  
  HeroRepository(this._dataSource);
  
  Future<List<Hero>> getAllHeroes() async {
    return _dataSource.loadHeroes();
  }
}
```

### 2. **Provider Pattern (Riverpod)**
Manages state reactively with dependency injection.

```dart
// Simple provider
final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  return HeroRepository(LocalDataSource.instance);
});

// Future provider for async data
final allHeroesProvider = FutureProvider<List<Hero>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getAllHeroes();
});

// Family provider for parameterized access
final heroByIdProvider = FutureProvider.family<Hero?, String>((ref, heroId) {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroById(heroId);
});
```

### 3. **Singleton Pattern**
Local data source uses singleton for app-wide instance.

```dart
class LocalDataSource {
  LocalDataSource._();
  static final LocalDataSource instance = LocalDataSource._();
}
```

### 4. **Model Pattern**
Data models with JSON serialization.

```dart
class Hero {
  final String id;
  final Map<String, String> name;
  final String eraId;
  final List<String> categoryIds;
  
  factory Hero.fromJson(Map<String, dynamic> json) {
    return Hero(/*...*/);
  }
  
  Map<String, dynamic> toJson() {
    return {/*...*/};
  }
}
```

---

## Data Flow

### Unidirectional Data Flow (UI → Action → Repository → UI)

```
┌─────────────────────────────────────────────────────┐
│                   USER INTERFACE                     │
│              (Flutter Widgets)                       │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓ (User Interaction)
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                   │
│         (Screens, State Management)                 │
│                 (home_screen.dart)                  │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓ (Watch Provider)
┌─────────────────────────────────────────────────────┐
│                  BUSINESS LOGIC                      │
│              (Riverpod Providers)                    │
│           (allHeroesProvider, filters)              │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓ (Call Repository)
┌─────────────────────────────────────────────────────┐
│                 DATA LAYER                           │
│              (Repository)                            │
│            (HeroRepository)                          │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓ (Load from source)
┌─────────────────────────────────────────────────────┐
│              DATA SOURCE                             │
│         (LocalDataSource)                            │
│       (JSON asset loading)                           │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓ (Parse JSON)
┌─────────────────────────────────────────────────────┐
│              JSON ASSETS                             │
│         (heroes.json, categories.json)              │
└─────────────────────────────────────────────────────┘
```

### Example: Loading Heroes

```
1. HomeScreen requests allHeroesProvider
   └─→ allHeroesProvider watches heroRepositoryProvider
       └─→ heroRepositoryProvider creates HeroRepository
           └─→ HeroRepository calls LocalDataSource.loadHeroes()
               └─→ LocalDataSource parses assets/data/heroes.json
                   └─→ Returns List<Hero>
                       └─→ Provider caches the result
                           └─→ HomeScreen receives data and rebuilds with UI
```

---

## State Management

### Riverpod Architecture

**Provider Types Used:**

1. **Simple Provider** - Static dependencies
```dart
final heroRepositoryProvider = Provider<HeroRepository>((ref) {
  return HeroRepository(LocalDataSource.instance);
});
```

2. **Future Provider** - Async data with caching
```dart
final allHeroesProvider = FutureProvider<List<Hero>>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getAllHeroes();
});
```

3. **Family Provider** - Parameterized access
```dart
final heroByIdProvider = FutureProvider.family<Hero?, String>((ref, heroId) {
  final repository = ref.watch(heroRepositoryProvider);
  return repository.getHeroById(heroId);
});
```

### Benefits
- **Reactive:** Auto-updates when dependencies change
- **Cached:** Data cached automatically
- **Testable:** Easy to mock for testing
- **Scoped:** Lifecycle management automatic
- **Composable:** Providers can depend on other providers

### Usage in Widgets

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider to get data
    final heroes = ref.watch(allHeroesProvider);
    
    return heroes.when(
      data: (heroList) => ListView(
        children: heroList.map((hero) => HeroCard(hero)).toList(),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

---

## Navigation

### Go Router Configuration

**Route Structure** (`lib/core/router/app_routes.dart`):

```dart
class AppRoutes {
  static const String home = '/';
  static const String intro = '/intro';
  static const String heroes = '/heroes';
  static const String heroDetail = '/hero-detail/:id';
  static const String search = '/search';
  static const String warMovements = '/war-movements/:categoryId';
}
```

### Navigation Implementation

```dart
// Push new route
context.push(AppRoutes.heroDetail.replaceFirst(':id', heroId));

// Replace current route
context.go(AppRoutes.home);

// Navigate back
context.pop();

// GoRouter Configuration
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'hero-detail/:id',
          builder: (context, state) => HeroDetailScreen(
            heroId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
```

---

## Localization

### Bilingual Support (English/Bengali)

**Translation Files** (`assets/translations/`):

```json
// en.json
{
  "app_title": "Bengal Heroes",
  "heroes": "Heroes",
  "categories": "Categories"
}

// bn.json
{
  "app_title": "বেঙ্গল হিরোজ",
  "heroes": "হিরো",
  "categories": "বিভাগ"
}
```

**Model Localization**:

```dart
class LocalizedContent {
  final String en;
  final String bn;
  
  String getByLocale(String locale) {
    return locale == 'bn' ? bn : en;
  }
}

// Usage
final locale = Localizations.localeOf(context).languageCode;
final title = hero.name.getByLocale(locale);
```

**Dynamic Language Switching**:

```dart
// Detect current locale
final locale = Localizations.localeOf(context).languageCode;

// Use in widgets
Text(hero.name.getByLocale(locale));
```

---

## Key Components

### 1. **Home Screen**
Main landing page with:
- On This Day section
- Featured Heroes
- Era Carousel
- War Collection
- Timeline Section
- Collection Overview stats

### 2. **Heroes Screen**
Filterable heroes list with:
- Category filtering
- Era filtering
- Search functionality
- Hero cards with images

### 3. **Hero Detail Screen**
Individual hero details:
- Full biography
- Image gallery
- Related heroes
- Historical context
- Timeline connection

### 4. **Search Screen**
Global search with:
- Hero search
- Category search
- Real-time results
- Search history

### 5. **Timeline Section**
Historical timeline showing:
- 12 major Bengal events
- Color-coded categories
- Interactive scrolling
- Bilingual content

### 6. **War Collection**
War-related heroes showcase:
- Horizontal carousel
- Year badges
- Quick navigation
- Category filtering

---

## Dependencies

### Key Packages

| Package | Purpose | Version |
|---------|---------|---------|
| `flutter` | UI framework | latest |
| `flutter_riverpod` | State management | 2.x |
| `go_router` | Navigation | 11.x |
| `flutter_animate` | Animations | latest |
| `google_fonts` | Custom fonts | latest |
| `shared_preferences` | Local storage | latest |
| `sqflite` | Local database | latest |
| `path_provider` | File system access | latest |

### Dev Dependencies
- `flutter_test` - Widget testing
- `build_runner` - Code generation
- `riverpod_generator` - Provider generation
- `custom_lint` - Linting

---

## Best Practices

### 1. **File Organization**
```
✅ Group by feature, not by layer
✅ Keep files focused and single-responsibility
✅ Use meaningful file names
✅ Keep related files together
```

### 2. **Naming Conventions**
```dart
// Classes: PascalCase
class HeroRepository { }

// Variables/functions: camelCase
var heroCount = 0;
void loadHeroes() { }

// Constants: camelCase with underscore prefix for private
const String _heroDataFile = 'assets/data/heroes.json';

// Files: snake_case
hero_repository.dart
local_data_source.dart
```

### 3. **Provider Usage**
```dart
✅ Use family providers for parameterized data
✅ Keep provider logic simple
✅ Cache data with FutureProvider
✅ Use ConsumerWidget for reactive UI
✅ Avoid mutable state when possible
```

### 4. **Widget Structure**
```dart
✅ Extract reusable widgets into shared/widgets
✅ Keep screen widgets simple
✅ Use composition over inheritance
✅ Pass data through constructor
✅ Use const constructors
```

### 5. **Error Handling**
```dart
✅ Handle loading states
✅ Display error messages
✅ Provide fallback UI
✅ Log errors appropriately
✅ Gracefully degrade functionality
```

### 6. **Performance**
```dart
✅ Use const constructors
✅ Implement shouldRebuild effectively
✅ Avoid rebuilding entire widgets
✅ Use efficient list rendering
✅ Cache data appropriately
```

### 7. **Code Quality**
```dart
✅ Follow Dart style guide
✅ Use type annotations
✅ Enable strict null safety
✅ Run analyzer regularly
✅ Write meaningful comments
✅ Keep functions small and focused
```

---

## Getting Started

### 1. **Setup Development Environment**
```bash
# Install Flutter
flutter pub global activate fvm
fvm install 3.16.0

# Clone repository
git clone <repo-url>
cd bengal-heroes

# Install dependencies
cd bengal_heroes
flutter pub get
```

### 2. **Project Structure Overview**
```
lib/
├── main.dart          # Entry point
├── app.dart           # App configuration
├── core/              # App-wide utilities
├── data/              # Data layer
├── features/          # Feature screens
└── shared/            # Shared components
```

### 3. **Running the App**
```bash
# Development
flutter run

# Release
flutter run --release

# Specific device
flutter run -d <device-id>
```

### 4. **Adding a New Feature**

**Step 1:** Create feature directory
```
lib/features/new_feature/
├── new_feature_screen.dart
└── widgets/
    └── component_widget.dart
```

**Step 2:** Create data model (if needed)
```
lib/data/models/new_model.dart
```

**Step 3:** Create repository (if needed)
```
lib/data/repositories/new_repository.dart
```

**Step 4:** Create providers (if needed)
```
lib/shared/providers/new_provider.dart
```

**Step 5:** Implement screen and widgets
```
lib/features/new_feature/new_feature_screen.dart
```

**Step 6:** Add routes
```
lib/core/router/app_routes.dart
```

### 5. **Adding New Data**

**To add new heroes:**
1. Edit `assets/data/heroes.json`
2. Add hero object with required fields
3. Data loads automatically on app start

**To add new categories:**
1. Edit `assets/data/categories.json`
2. App automatically includes in filters

**To add timeline events:**
1. Edit `assets/data/timeline.json`
2. Add event with category and year

### 6. **Debugging**
```bash
# Enable verbose logging
flutter run -v

# Hot reload
r key in terminal

# Hot restart
R key in terminal

# Debug build
flutter run --debug

# Profile build
flutter run --profile
```

---

## Architecture Decisions

### Why Clean Architecture?
- **Testability:** Each layer independently testable
- **Scalability:** Easy to add new features
- **Maintainability:** Clear separation of concerns
- **Flexibility:** Easy to swap implementations
- **Team Collaboration:** Clear structure for team development

### Why Riverpod?
- **Type-Safe:** Compile-time checked dependencies
- **Caching:** Automatic data caching
- **Easy Testing:** Mock providers easily
- **No BuildContext:** Works without context
- **Composable:** Providers can depend on other providers

### Why GoRouter?
- **Type-Safe:** Strongly typed routes
- **Deep Linking:** Automatic deep link support
- **Nested Navigation:** Support for nested routes
- **Easy to Test:** Navigation easy to test

---

## Troubleshooting

### Common Issues

**Issue:** Hot reload not working
```bash
Solution: Use hot restart (R key) or flutter run
```

**Issue:** Build errors after dependency update
```bash
Solution: flutter clean && flutter pub get && flutter run
```

**Issue:** JSON parsing errors
```bash
Solution: Verify JSON syntax, check encoding
```

**Issue:** Provider not updating
```bash
Solution: Check if ConsumerWidget is used, verify ref.watch()
```

---

## Future Improvements

- [ ] Add persistent local database
- [ ] Implement user accounts
- [ ] Add offline mode
- [ ] Create admin panel
- [ ] Add social sharing
- [ ] Implement notifications
- [ ] Add augmented reality features
- [ ] Create API backend integration

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## Contact & Support

For questions or issues:
1. Check documentation files
2. Review code comments
3. Check existing GitHub issues
4. Create new issue with details

---

**Last Updated:** 2024
**App Version:** 1.0.0
**Architecture Version:** 1.0
**Maintained By:** Bengal Heroes Dev Team
