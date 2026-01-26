# Bengal Heroes - App Vision & Documentation

## 🎯 Vision Statement

**Bengal Heroes** is a digital monument to the brave souls who shaped the history of Bengal. Our mission is to preserve, educate, and inspire through the stories of freedom fighters, intellectuals, poets, and leaders who sacrificed for their homeland.

> *"Those who cannot remember the past are condemned to repeat it."* — George Santayana

This app serves as a bridge between generations, ensuring that the sacrifices and achievements of our heroes are never forgotten. We believe that understanding our history is the first step toward building a better future.

---

## 📖 Project Overview

### What is Bengal Heroes?

Bengal Heroes is a **production-grade, offline-first mobile application** built with Flutter. It provides:

- **Comprehensive biographical database** of historical figures from Bengal
- **Bilingual support** (English & Bengali) for maximum accessibility
- **Era-based categorization** spanning from the Sultanate period to 1971 Liberation War
- **Daily historical discoveries** through the "On This Day" feature
- **Modern, elegant UI** that respects the dignity of its subjects

### Target Audience

1. **Students** - Learning about Bengal's rich history
2. **Researchers** - Quick reference for historical data
3. **General Public** - Discovering ancestral heritage
4. **Diaspora** - Staying connected to roots
5. **Educators** - Teaching tool for history classes

### Core Values

| Value | Description |
|-------|-------------|
| **Accuracy** | All information is historically verified |
| **Respect** | Heroes are presented with dignity |
| **Accessibility** | Free, offline, no ads, multilingual |
| **Education** | Pure educational focus, not entertainment |
| **Preservation** | Digital preservation of cultural heritage |

---

## 🏛️ Historical Eras Covered

### 1. Sultanate Era (1352-1576)
The period when Bengal was ruled by independent Sultans, featuring rich culture and architectural marvels.

### 2. Mughal Era (1576-1757)
The era of Mughal expansion and resistance from local chieftains like the Baro-Bhuiyans.

### 3. British Colonial Era (1757-1947)
The Bengal Renaissance period with intellectuals, poets, and social reformers.

### 4. Anti-Colonial Resistance (1757-1947)
Revolutionary movements and armed resistance against British rule.

### 5. Language Movement (1948-1956)
The struggle for Bengali language recognition, leading to the historic 21st February.

### 6. Liberation War 1971
The nine-month war that led to the birth of Bangladesh.

---

## 👥 Hero Categories

| Category | Description | Color Code |
|----------|-------------|------------|
| **Martyr** (শহীদ) | Those who sacrificed their lives | `#D32F2F` |
| **Revolutionary** (বিপ্লবী) | Armed resistance leaders | `#E64A19` |
| **Intellectual** (বুদ্ধিজীবী) | Scholars, writers, thinkers | `#0288D1` |
| **Ruler** (শাসক) | Kings, sultans, political leaders | `#7C4DFF` |
| **Poet** (কবি) | Literary giants | `#E91E63` |
| **Philosopher** (দার্শনিক) | Spiritual and social reformers | `#00897B` |
| **Soldier** (সৈনিক) | Military heroes | `#5D4037` |

---

## 📱 App Features Deep Dive

### 1. Home Screen
- **On This Day**: Shows births, deaths, and events matching today's date
- **Featured Heroes**: Highlights important figures (importance >= 4)
- **Era Carousel**: Quick access to era-based browsing
- **Collection Stats**: Total heroes, eras, and categories

### 2. Heroes List
- **Infinite Scroll**: Loads 20 heroes at a time for performance
- **Filtering**: By era, category, or multiple criteria
- **Sorting**: By importance, then alphabetically
- **Pull-to-Refresh**: Reload data from source

### 3. Hero Detail
- **Rich Biography**: Full localized content
- **Image Gallery**: Multiple portraits when available
- **Quick Facts**: Birth/death dates, birthplace, achievements
- **Related Heroes**: Discover connections
- **Favorite**: Save for quick access

### 4. Search
- **Fuzzy Matching**: Finds heroes even with typos
- **Bilingual**: Searches in both English and Bengali
- **Weighted Results**: Name matches ranked higher than bio matches
- **Search History**: Quick access to recent searches

### 5. Settings
- **Theme**: Light, Dark, or System default
- **Language**: English or Bengali
- **About**: App information and credits

---

## 🛠️ Technical Architecture

### State Management: Riverpod
- Compile-time safety with code generation
- Easy dependency injection
- Perfect for offline-first apps

### Navigation: GoRouter
- Declarative routing
- Deep linking support
- Shell routes for bottom navigation

### Data Layer
- **Models**: Hero, Era, Category, Location, Event
- **Repository Pattern**: Clean data access
- **Local Data Source**: JSON assets

### Localization: easy_localization
- Runtime language switching
- JSON-based translations
- Fallback to English

---

## 📊 Data Structure

### Hero Schema

```json
{
  "id": "hero_001",           // Unique identifier (hero_XXX format)
  "slug": "titumir",          // URL-friendly name
  "dates": {
    "birth": "1782-01-27",    // Format: YYYY-MM-DD
    "death": "1831-11-19"     // Optional if still living
  },
  "era": "british_resistance", // Must match an era ID
  "category": ["martyr", "revolutionary"], // Array of category IDs
  "images": ["assets/images/heroes/titumir.png"], // Asset paths
  "location_id": "loc_narkelberiya", // Optional location reference
  "importance": 5,            // 1-5 scale (5 = most important)
  "related_hero_ids": ["hero_002"], // Optional related heroes
  "content": {
    "en": {
      "name": "Titumir",
      "short_bio": "Brief description (150-200 chars)...",
      "full_biography": "Detailed multi-paragraph biography...",
      "quote": "Famous quote with attribution...",
      "birth_place": "City, Region, Country",
      "achievements": "Bullet points separated by •"
    },
    "bn": {
      // Same structure in Bengali
    }
  }
}
```

### Era Schema

```json
{
  "id": "liberation_1971",
  "name": { "en": "Liberation War 1971", "bn": "মুক্তিযুদ্ধ ১৯৭১" },
  "description": { "en": "...", "bn": "..." },
  "start_year": "1971",
  "end_year": "1971",
  "icon_asset": "assets/icons/era_liberation.svg",
  "color_hex": "#00695C",
  "sort_order": 6
}
```

### Category Schema

```json
{
  "id": "martyr",
  "name": { "en": "Martyr", "bn": "শহীদ" },
  "description": { "en": "...", "bn": "..." },
  "icon_asset": "assets/icons/cat_martyr.svg",
  "color_hex": "#D32F2F"
}
```

### Event Schema (for On This Day)

```json
{
  "id": "event_001",
  "date": "1952-02-21",
  "title": { "en": "Language Martyrs Day", "bn": "ভাষা শহীদ দিবস" },
  "description": { "en": "...", "bn": "..." },
  "era_id": "language_movement",
  "related_hero_ids": ["hero_009", "hero_010"],
  "image_asset": "assets/images/events/language_day.png"
}
```

---

## 📝 Guidelines for Adding Data

### Adding a New Hero

#### Step 1: Research
1. Verify all dates and facts from multiple sources
2. Ensure historical accuracy
3. Gather high-quality portrait image
4. Prepare content in both English and Bengali

#### Step 2: Prepare Content

**English Content Checklist:**
- [ ] Name (official/most recognized form)
- [ ] Short Bio (150-200 characters)
- [ ] Full Biography (500-1000 words, multiple paragraphs)
- [ ] Famous Quote (if available, with context)
- [ ] Birth Place (City, Region, Historical Country)
- [ ] Achievements (3-5 bullet points, separated by •)

**Bengali Content Checklist:**
- [ ] নাম (Name)
- [ ] সংক্ষিপ্ত জীবনী (Short Bio)
- [ ] পূর্ণ জীবনী (Full Biography)
- [ ] উক্তি (Quote)
- [ ] জন্মস্থান (Birth Place)
- [ ] অর্জন (Achievements)

#### Step 3: Prepare Image

**Image Requirements:**
- **Format**: PNG (preferred) or WebP
- **Size**: 800x1000 pixels (portrait orientation)
- **Background**: Transparent or neutral
- **Naming**: `{slug}.png` (e.g., `titumir.png`)
- **Location**: `assets/images/heroes/`

#### Step 4: Add to JSON

1. Open `assets/data/heroes.json`
2. Add new hero object to the array
3. Ensure proper JSON formatting (validate with a JSON linter)
4. Increment `id` (e.g., `hero_009`, `hero_010`)

#### Step 5: Update Assets

If adding images:
1. Place image in `assets/images/heroes/`
2. Ensure `pubspec.yaml` includes the assets directory

#### Step 6: Test

1. Run `flutter pub get`
2. Hot restart the app
3. Verify hero appears in list
4. Check both English and Bengali content
5. Test search functionality
6. Verify "On This Day" if dates match

### Adding a New Era

1. Add era object to `assets/data/eras.json`
2. Use unique `id` (snake_case)
3. Assign unique `color_hex` for visual distinction
4. Set appropriate `sort_order` for chronological display
5. Add corresponding icon to `assets/icons/`
6. Update `AppColors.getEraColor()` if needed

### Adding a New Category

1. Add category object to `assets/data/categories.json`
2. Use unique `id` (snake_case)
3. Assign unique `color_hex`
4. Add corresponding icon to `assets/icons/`
5. Update `AppColors.getCategoryColor()` if needed

### Adding Historical Events

1. Add event to `assets/data/events.json`
2. Use `YYYY-MM-DD` format for dates
3. Link to related heroes via `related_hero_ids`
4. Events appear in "On This Day" when date matches

---

## 🌍 Localization Guidelines

### Adding Translations

All user-facing strings should be in translation files:
- English: `assets/translations/en.json`
- Bengali: `assets/translations/bn.json`

### Translation Keys

Use nested structure for organization:
```json
{
  "section": {
    "subsection": "Translated text"
  }
}
```

### Bengali Typography Notes

- Use Hind Siliguri font for optimal readability
- Test all Bengali text for proper rendering
- Consider text length (Bengali often longer than English)
- Use Unicode for Bengali characters (U+0980–U+09FF)

---

## 🔮 Future Roadmap

### Phase 2: Enhanced Features
- [ ] Audio narration of biographies
- [ ] Interactive timeline view
- [ ] Map view showing birthplaces
- [ ] Bookmark and notes feature
- [ ] Quiz mode for learning

### Phase 3: Community
- [ ] User-submitted hero suggestions
- [ ] Content moderation workflow
- [ ] Community translations
- [ ] Social sharing with cards

### Phase 4: Platform Expansion
- [ ] Web version (Flutter Web)
- [ ] Desktop apps (Windows, macOS)
- [ ] Tablet-optimized layouts
- [ ] Accessibility improvements

---

## 📞 Contact & Contribution

### How to Contribute

1. **Data Contribution**: Submit verified hero information
2. **Translation**: Help with Bengali or other languages
3. **Images**: Provide high-quality historical portraits
4. **Code**: Submit pull requests for features/fixes

### Content Guidelines

- All submissions must be historically accurate
- Cite sources for verification
- Respect the dignity of historical figures
- No political commentary or bias
- Educational focus only

---

## 📜 License & Credits

This project is dedicated to the heroes of Bengal.

**Made with ❤️ for Bengal**

*"যে জাতি তার ইতিহাস জানে না, সে জাতি উন্নতি করতে পারে না।"*
*(A nation that does not know its history cannot progress.)*

---

*Last Updated: January 2026*
*Version: 1.0.0*
