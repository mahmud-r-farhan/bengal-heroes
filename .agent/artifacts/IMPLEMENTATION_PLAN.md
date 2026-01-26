# Bengal Heroes - Implementation Plan

## Project Overview
A production-grade, offline-first historical mobile application dedicated to the legends, freedom fighters, and intellectuals of Bengal (from the Sultanate era to the 1971 Liberation War).

## Architecture Decisions

### 1. State Management: **Riverpod with Code Generation**
- **Why Riverpod over BLoC?**
  - Less boilerplate code for read-heavy apps
  - Better compile-time safety with code generation
  - Easier testing and dependency injection
  - Perfect for offline-first apps with cached data

### 2. Project Structure (Feature-First)
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── theme/
│   ├── utils/
│   └── router/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── features/
│   ├── intro/
│   ├── home/
│   ├── heroes/
│   ├── hero_detail/
│   ├── search/
│   ├── on_this_day/
│   └── settings/
├── l10n/
└── shared/
    ├── widgets/
    └── providers/
```

## Implementation Phases

### Phase 1: Foundation Setup ✓
- [x] Update pubspec.yaml with dependencies
- [x] Create folder structure
- [x] Setup theme system (Material 3)
- [x] Configure GoRouter
- [x] Setup Riverpod
- [x] Configure localization

### Phase 2: Data Layer
- [x] Create Hero model with localization support
- [x] Create JSON data files (heroes, eras, categories)
- [x] Implement data repository
- [x] Create Riverpod providers

### Phase 3: Features Implementation
- [x] Intro Screen (onboarding with theme/language selection)
- [x] Home Screen with "On This Day" section
- [x] Hero List Screen with categories
- [x] Hero Detail Screen
- [x] Advanced Search with fuzzy logic
- [x] Filter functionality

### Phase 4: Polish
- [x] Animations and transitions
- [x] Performance optimization
- [x] Final UI refinements

## Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  go_router: ^15.2.0
  easy_localization: ^3.0.7
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.17
  cached_network_image: ^3.4.1
  fuzzy: ^0.5.1
  intl: ^0.20.2
  shared_preferences: ^2.5.3

dev_dependencies:
  riverpod_generator: ^2.6.4
  build_runner: ^2.4.15
```

## JSON Data Schema (Enhanced)
```json
{
  "heroes": [...],
  "eras": [...],
  "categories": [...],
  "events": [...],
  "locations": [...]
}
```

## Key Features Implementation Notes

### 1. "On This Day" Logic
- Query heroes by birth/death dates matching current month/day
- Query historical events by date
- Display in a carousel on home screen

### 2. Fuzzy Search
- Use 'fuzzy' package for approximate string matching
- Search in both English and Bangla fields
- Weighted results (name > era > category > biography)

### 3. Infinite Scroll
- Implement pagination with Riverpod's FutureProvider
- Load 20 items at a time
- Cache loaded data for offline access

### 4. Theme System
- Historical/Elegant aesthetic
- Rich gold, deep maroon, ivory colors
- Custom typography with Google Fonts
