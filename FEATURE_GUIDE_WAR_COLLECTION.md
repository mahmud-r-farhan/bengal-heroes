# War & Political Movements Collection Feature Guide

## Overview

The War Collection feature adds a dedicated section to the Bengal Heroes app's home screen that showcases Bengal's political movements and wars. It provides users with an interactive way to explore war-related heroes and events chronologically.

## Feature Structure

### Component Architecture

```
HomeScreen
├── OnThisDaySection
├── FeaturedHeroesSection
├── EraCarousel
├── WarCollectionSection ← NEW
│   ├── Collection Header
│   ├── War Event Cards Carousel (Horizontal)
│   │   └── _WarEventCard (Individual War/Hero)
│   │       ├── Year Badge
│   │       ├── Hero Name
│   │       ├── Short Bio
│   │       └── View Details Link
│   └── "Explore All War & Movements" Button
└── Collection Overview Stats
```

## File Structure

```
lib/features/home/
├── home_screen.dart                    (Updated: added WarCollectionSection import and integration)
└── widgets/
    ├── war_collection_section.dart     (NEW: Main war collection widget)
    ├── on_this_day_section.dart
    ├── era_carousel.dart
    └── featured_heroes_section.dart
```

## Component Breakdown

### WarCollectionSection (Main Widget)

**Location:** `lib/features/home/widgets/war_collection_section.dart`

**Purpose:** Displays a curated carousel of war-related heroes from the `war_movement` category

**Key Features:**
- Fetches heroes tagged with `war_movement` category
- Displays them in a horizontal scrollable carousel
- Each card shows hero name, time period (birth-death years), and short bio
- Clicking any card navigates to the war-related heroes list
- Smooth fade-in and slide animations on load

**Data Flow:**
```
HeroRepository.getHeroesByCategory('war_movement')
    ↓
List<Hero> (filtered to war_movement category)
    ↓
_WarEventCard widgets rendered in ListView
    ↓
onTap → context.push(AppRoutes.getWarMovementsPath('war_movement'))
```

**Dependencies:**
- `HeroRepository` (via `heroRepositoryProvider`)
- `AppRoutes` (routing constants)
- `AppColors` (color theme)
- `flutter_animate` (animations)

### _WarEventCard (Sub-Widget)

**Purpose:** Individual card displaying a war/movement and its key figure

**Card Content:**
- **Year Badge:** Shows birth year - death year range (e.g., "1764 - 1831")
- **Hero Name:** Bold, truncated to 2 lines
- **Short Bio:** Limited to 2 lines with ellipsis
- **View Details Indicator:** Arrow icon with "View details" text

**Visual Design:**
- Rounded corners (16px border radius)
- Hover effect: Border color changes from subtle to prominent
- Decorative background circle in top-right
- Responsive padding and spacing
- Shadow effect that increases on hover

**State Management:**
- Uses `StatefulWidget` to track hover state
- `_isHovered` boolean for interactive feedback
- Smooth `AnimatedContainer` transitions on state change

## Data Integration

### War Events Data Source

The feature relies on war-tagged heroes from the `war_movement` category:

**JSON Structure (heroes.json):**
```json
{
  "id": "hero_id",
  "name": {
    "en": "Hero Name",
    "bn": "হিরো নাম"
  },
  "shortBio": {
    "en": "Short biographical description",
    "bn": "সংক্ষিপ্ত জীবনী"
  },
  "dates": {
    "birth": { "year": "1764", "month": null, "day": null },
    "death": { "year": "1831", "month": null, "day": null }
  },
  "categories": ["war_movement"],
  "eraId": "bengal_sultanate"
}
```

### Current War-Related Heroes

The feature displays heroes tagged with:
- **Category ID:** `war_movement`
- **Category Name:** "Bengal Faces War"
- **Coverage Period:** 1352-2024

Current heroes include (as of latest data):
- Tipu Sultan (1764-1799)
- Mir Jafar (1691-1763)
- Siraj ud-Daulah (1733-1757)
- Pather Dewan (dates vary)
- And others from different eras

## Navigation Integration

### Route Information

**Route Path:** `/war-movements/:categoryId`

**Navigation Method:**
```dart
context.push(AppRoutes.getWarMovementsPath('war_movement'))
```

**Destination:** `HeroesScreen` filtered to display only heroes with `war_movement` category

**Navigation Points:**
1. Individual war card click
2. "View Details" link on each card
3. "Explore All War & Movements" button at bottom

All navigation points direct to the same destination with the same category filter.

## Localization Support

The feature fully supports bilingual content:

**Supported Languages:**
- English (default)
- Bengali

**Localized Elements:**
- Section header: "Bengal Faces War" (with fallback to English)
- Section subtitle: "Political movements & historical upheavals"
- Button text: "Explore All War & Movements"
- Card content: Hero names and bios (from localized JSON)
- Year badges: Numbers remain consistent across languages

**Locale Detection:**
```dart
final locale = Localizations.localeOf(context).languageCode;
// Then used: hero.getContent(locale)
```

## Animation & Visual Effects

The feature includes carefully timed animations:

**Section-Level Animations:**
- Fade in: 400ms
- Slide Y: From +0.1 to 0 (upward slide)
- Delay: 500ms after previous sections

**Card-Level Animations:**
- Each card fades in with 100ms stagger
- Each card slides in from the right (20% offset)
- Cumulative effect: Cards appear sequentially

**Hover Effects:**
- Border color transition: Subtle → Prominent
- Shadow enhancement: 8px → 16px blur radius
- Combined effect creates interactive feel

## Responsive Design

**Layout Behavior:**
- Hero cards use fixed width (200px) in horizontal ListView
- Overflow handled by horizontal scrolling
- Padding: 16px horizontal margins
- Card spacing: 12px right margin between cards
- Button spans full width with 16px padding

**Breakpoint Considerations:**
- Works on all screen sizes (phone to tablet)
- Horizontal scroll provides access to overflow content
- Touch-friendly card size (200x160)
- Clear tap targets with adequate spacing

## Performance Optimization

**Data Fetching:**
- Uses Riverpod's `FutureBuilder` for async data loading
- Caches results at provider level
- Shows loading state ("...") if data unavailable
- Falls back gracefully on error

**Rendering:**
- Lazy-loaded via horizontal ListView (only visible cards rendered)
- Fixed item count prevents unnecessary rebuilds
- StatefulWidget used minimally (only for hover state)

## Accessibility Features

**Visual Accessibility:**
- High contrast colors (maroon on white/light backgrounds)
- Clear typography hierarchy
- Icon + text labels for clarity
- Color not used as sole information carrier

**Interactive Accessibility:**
- Tap targets: 200x160 minimum (well above 48x48 guideline)
- Clear visual feedback on interaction
- Navigation is consistent and predictable
- Alternative text available via tooltips (future enhancement)

## Integration Points

### Home Screen Integration

**Location in HomeScreen:** Between `EraCarousel` and `_buildQuickStats`

**Code Addition:**
```dart
const WarCollectionSection()
    .animate()
    .fadeIn(delay: 500.ms, duration: 400.ms)
    .slideY(begin: 0.1, end: 0),
```

**Rationale:**
- Positioned after era exploration (logical flow)
- Before collection stats (maintains visual hierarchy)
- 500ms delay allows previous sections to settle
- Consistent animation pattern with other sections

## Extending the Feature

### Possible Enhancements

1. **Timeline View:** Replace carousel with vertical timeline showing wars chronologically
2. **Event Details:** Add pop-up or bottom sheet with full war details
3. **Related Events:** Show associated events from `events.json` with `category_id: "war_movement"`
4. **Statistics:** Display war counts, involved heroes count, and date ranges
5. **Filtering:** Allow users to filter by era or time period
6. **Search Integration:** Make war names searchable in global search

### Adding New War Heroes

1. Add hero entry to `assets/data/heroes.json`
2. Include `"categories": ["war_movement"]` in the hero data
3. Set appropriate `dates.birth.year` and `dates.death.year`
4. Provide bilingual `name` and `shortBio`
5. Feature will automatically include the hero in the collection

## Testing Considerations

### Test Cases

1. **Data Loading:**
   - Verify heroes with `war_movement` category are fetched
   - Check error handling when no heroes available
   - Test loading state display

2. **Navigation:**
   - Tap each card and verify navigation to HeroesScreen
   - Confirm category filter is applied correctly
   - Check browser back button functionality

3. **Localization:**
   - Switch between English and Bengali
   - Verify hero names and bios display correctly
   - Check section headers translate properly

4. **Responsive:**
   - Test on different screen sizes
   - Verify horizontal scroll works smoothly
   - Check card alignment and spacing

5. **Animation:**
   - Verify fade-in animation occurs
   - Check sequential card appearance
   - Test hover effects responsively

## Code Quality & Standards

**Code Style:**
- Follows Dart effective style guide
- Proper null safety with `?` and `!` operators
- Constants properly defined (`const` constructors)
- Appropriate use of private vs public methods

**State Management:**
- Uses Riverpod for dependency injection
- FutureBuilder for async data handling
- Proper error and loading state handling
- No unnecessary rebuilds

**Documentation:**
- Class and method documentation present
- Inline comments for complex logic
- Clear variable naming conventions
- Proper imports organization

## Troubleshooting

### Common Issues

**Issue:** War collection section not appearing
- **Check:** Verify `war_movement` category exists in categories.json
- **Check:** Ensure at least one hero has `"categories": ["war_movement"]` in heroes.json
- **Check:** Verify no runtime errors in console

**Issue:** Cards showing "..." or error state
- **Check:** Verify network/asset loading works for other sections
- **Check:** Check that HeroRepository methods are accessible
- **Check:** Review console for async errors

**Issue:** Navigation not working
- **Check:** Verify `/war-movements/:categoryId` route is defined in AppRoutes
- **Check:** Ensure HeroesScreen can handle category filters
- **Check:** Check GoRouter configuration

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024 | Initial release with war collection carousel |

## Related Documentation

- [Bengal Heroes Architecture Guide](ARCHITECTURE.md)
- [Data Guide](DATA_GUIDE.md)
- [Implementation Notes](IMPLEMENTATION_NOTES.md)
- [Router Configuration](lib/core/router/app_routes.dart)
