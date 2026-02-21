# Enhanced Unified Search Functionality

## Overview

The search functionality has been significantly enhanced to support searching across **four different data types** in addition to the original hero search:

1. **Heroes** - Historical figures (with photos)
2. **Timeline Events** - Major historical events (no photos)
3. **Travelers** - Notable travelers and visitors (no photos)
4. **Global Events** - Historical events and milestones (no photos)

## Architecture

### 1. Unified Search Result System

#### New Result Types (based on source data)

**Base Class: `BaseSearchResult`** (Abstract)
```dart
abstract class BaseSearchResult {
  final double score;
  final String matchedField;
  final SearchResultType type;
}
```

**Concrete Implementations:**
- `HeroSearchResult` - Contains a `Hero` object
- `TimelineSearchResult` - Contains a `TimelineEvent` object
- `TravelerSearchResult` - Contains a `TimelineEvent` object
- `EventSearchResult` - Contains a `GlobalEvent` object

#### Return Type
```dart
enum SearchResultType { hero, timeline, traveler, event }
```

### 2. Repository Enhancement

**File:** `lib/data/repositories/hero_repository.dart`

**New Public Method:**
```dart
Future<List<BaseSearchResult>> searchAll(
  String query, {
  int limit = 30,
}) async
```

This method:
- Searches all four data types in parallel
- Combines results
- Sorts by score (descending)
- Returns mixed results

**Private Search Methods:**
- `_searchTimeline()` - Searches timeline events
- `_searchTravelers()` - Searches travelers
- `_searchEvents()` - Searches global events
- `searchHeroes()` - Original hero search (kept for backwards compatibility)

### 3. Search Provider Update

**File:** `lib/shared/providers/search_provider.dart`

**New Provider:**
```dart
final unifiedSearchResultsProvider = FutureProvider<List<BaseSearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  
  final repository = ref.watch(heroRepositoryProvider);
  return repository.searchAll(query);
});
```

This replaces the old `searchResultsProvider` for displaying results.

**Backwards Compatibility:**
- Old `searchResultsProvider` still exists for legacy code
- New `isSearchingProvider` now watches `unifiedSearchResultsProvider`

### 4. UI Implementation

**File:** `lib/features/search/search_screen.dart`

#### Key Changes:

1. **Updated Hint Text:**
   - Old: "Search heroes..."
   - New: "Search heroes, events, travelers..."

2. **Result Tile Architecture:**
   
   Single method `_buildResultTile()` that dispatches to type-specific builders:
   - `_buildHeroResultTile()` - Shows hero with photo
   - `_buildTimelineResultTile()` - Shows timeline with icon
   - `_buildTravelerResultTile()` - Shows traveler with icon
   - `_buildEventResultTile()` - Shows event with icon

3. **Visual Differentiation:**
   
   Each result type has:
   - **Type Badge** - Color-coded label
     - Hero: Maroon
     - Timeline: Navy
     - Traveler: Orange
     - Event: Teal
   
   - **Icon/Photo Area** (60x60)
     - Heroes: Photo image
     - Timeline: `Icons.timeline`
     - Travelers: `Icons.public`
     - Events: `Icons.event_note`
   
   - **Content Area**
     - Title (same color as badge)
     - Year/Date information
     - Description preview (2 lines max)
     - Match indicator

4. **Suggestion Updates:**
   - Updated examples to show variety: "Xuanzang", "Language Movement", etc.
   - Updated tips: "Find heroes, timeline events, travelers, and more!"

## Scoring System

### Hero Search Weights:
- Name match: **1.0** (highest priority)
- Bio match: **0.6**
- Era match: **0.5**
- Location match: **0.7**

### Events/Timeline/Travelers Weights:
- Title match: **1.0** (highest priority)
- Description match: **0.6**

### Threshold: 
Minimum score of **0.3** for results to appear

## Search Features

### 1. Multi-Language Support
- Searches in both English and Bengali
- Works regardless of app language setting
- Useful for users who know names in one language

### 2. Fuzzy Matching
Using the `fuzzy` package:
```dart
final options = FuzzyOptions(
  findAllMatches: true,
  tokenize: true,
  threshold: 0.4,
);
```

This allows:
- Typo tolerance
- Partial word matching
- Token-based matching

### 3. No Photo Handling
- Items without photos display icon instead
- No breaking of layout or functionality
- Consistent visual experience across all types

## Data Sources

### Timeline Events
- **File:** `assets/data/timeline.json`
- **Fields:** id, year, period, title (en/bn), description (en/bn), category, significance, icon

### Travelers
- **File:** `assets/data/travelers.json`
- **Fields:** id, year, period, title (en/bn), description (en/bn), category, significance, icon
- **Note:** Stored in same format as timeline events

### Global Events
- **File:** `assets/data/events.json`
- **Fields:** id, date, title (en/bn), description (en/bn), era_id, image_asset, related_hero_ids

### Heroes (unchanged)
- **File:** `assets/data/heroes.json`
- **Fields:** id, name (en/bn), bio (en/bn), era_id, category_ids, image_path, etc.

## Implementation Quality

### Senior Engineer Considerations

1. **Type Safety**
   - Abstract base class for all search results
   - Proper enum for result types
   - Type casting before accessing type-specific properties

2. **Performance**
   - Parallel data loading (where applicable)
   - Efficient search with fuzzy matching
   - Limited result limit (30 default)

3. **Backwards Compatibility**
   - Old `searchResultsProvider` still works
   - Old `SearchResult` class preserved
   - Gradual migration path

4. **Code Organization**
   - Separation of concerns (search logic vs UI)
   - DRY principles with shared methods
   - Clear naming conventions

5. **Error Handling**
   - Graceful fallbacks for missing data
   - Empty result handling
   - Type-safe casting

6. **UI/UX**
   - Consistent design across result types
   - Clear visual hierarchy
   - Type badges for clarity
   - Appropriate icons for each type
   - Smooth animations

## Testing Checklist

- [ ] Search for hero names
- [ ] Search for timeline events
- [ ] Search for travelers
- [ ] Search for global events
- [ ] Test partial matches (e.g., "Bangli" for "Ray")
- [ ] Test Bengali input
- [ ] Verify mixed results are properly sorted by score
- [ ] Check that items without photos display correctly
- [ ] Verify type badges show correctly
- [ ] Test empty results handling
- [ ] Test search history with new search types
- [ ] Verify animations work smoothly

## Usage Example

### For Users:
```
Search query: "Bengal"

Results:
1. Rammohun Roy (Hero) - Matched in era
2. Hiuen Tsang (Traveler) - Matched in description
3. 1960 Bengal Famine (Event) - Matched in title
4. Language Movement (Timeline) - Matched in title
```

### For Developers:
```dart
// Search all types
final results = await repository.searchAll("Bengal");

// Process results
for (final result in results) {
  switch (result.type) {
    case SearchResultType.hero:
      final hero = (result as HeroSearchResult).hero;
      // Handle hero
      break;
    case SearchResultType.timeline:
      final event = (result as TimelineSearchResult).event;
      // Handle timeline event
      break;
    // ... etc
  }
}
```

## Files Modified

1. **lib/data/repositories/hero_repository.dart**
   - Added new search result classes
   - Added `searchAll()` method
   - Added private search methods for each type

2. **lib/shared/providers/search_provider.dart**
   - Added `unifiedSearchResultsProvider`
   - Updated `isSearchingProvider` to use unified results

3. **lib/features/search/search_screen.dart**
   - Updated hint text
   - Added type-specific tile builders
   - Implemented visual differentiation
   - Updated suggestions and tips

## Future Enhancements

1. **Result Grouping**
   - Group results by type for easier browsing
   
2. **Advanced Filters**
   - Filter by result type
   - Filter by era or date range
   
3. **Search Analytics**
   - Track popular searches
   - Identify trending queries
   
4. **Smart Suggestions**
   - AI-powered query suggestions
   - Learning from user behavior

## Conclusion

The enhanced search functionality provides a unified, intelligent way to discover all types of historical content in the Bengal Heroes app. With proper handling of different data types, visual differentiation, and intelligent ranking, users can now find exactly what they're looking for across the entire dataset.
