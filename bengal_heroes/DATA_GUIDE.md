# Data Contribution Guide

This guide explains how to add new heroes, eras, categories, and events to the Bengal Heroes app.

## 📁 Data Files Location

All data files are located in `assets/data/`:

```
assets/data/
├── heroes.json      # Main hero database
├── eras.json        # Historical eras
├── categories.json  # Hero classifications
├── events.json      # Historical events for "On This Day"
└── locations.json   # Geographical locations
```

---

## 👤 Adding a New Hero

### Template

Copy this template and fill in the details:

```json
{
  "id": "hero_XXX",
  "slug": "hero-url-friendly-name",
  "dates": {
    "birth": "YYYY-MM-DD",
    "death": "YYYY-MM-DD"
  },
  "era": "era_id",
  "category": ["category_id_1", "category_id_2"],
  "images": ["assets/images/heroes/slug.png"],
  "location_id": "loc_XXX",
  "importance": 4,
  "related_hero_ids": ["hero_YYY"],
  "content": {
    "en": {
      "name": "Hero Name in English",
      "short_bio": "A brief 1-2 sentence description of the hero (150-200 characters).",
      "full_biography": "Full multi-paragraph biography.\n\nUse \\n\\n for paragraph breaks.\n\nInclude key life events, achievements, and historical significance.",
      "quote": "Famous quote attributed to the hero, if available.",
      "birth_place": "City, Region, Country",
      "achievements": "Achievement 1 • Achievement 2 • Achievement 3"
    },
    "bn": {
      "name": "বাংলায় নাম",
      "short_bio": "সংক্ষিপ্ত জীবনী বাংলায়।",
      "full_biography": "পূর্ণ জীবনী বাংলায়।\n\nঅনুচ্ছেদ বিরতির জন্য \\n\\n ব্যবহার করুন।",
      "quote": "বিখ্যাত উক্তি (যদি থাকে)",
      "birth_place": "শহর, অঞ্চল, দেশ",
      "achievements": "অর্জন ১ • অর্জন ২ • অর্জন ৩"
    }
  }
}
```

### Field Descriptions

| Field | Required | Description |
|-------|----------|-------------|
| `id` | ✅ | Unique ID in format `hero_XXX` |
| `slug` | ✅ | URL-friendly name (lowercase, no spaces) |
| `dates.birth` | ❌ | Birth date in YYYY-MM-DD format |
| `dates.death` | ❌ | Death date in YYYY-MM-DD format |
| `era` | ✅ | Era ID (must exist in eras.json) |
| `category` | ✅ | Array of category IDs |
| `images` | ✅ | Array of image asset paths |
| `location_id` | ❌ | Location ID reference |
| `importance` | ❌ | 1-5 scale (default: 3) |
| `related_hero_ids` | ❌ | Array of related hero IDs |
| `content.{lang}.name` | ✅ | Localized name |
| `content.{lang}.short_bio` | ✅ | Brief description |
| `content.{lang}.full_biography` | ✅ | Detailed biography |
| `content.{lang}.quote` | ❌ | Famous quote |
| `content.{lang}.birth_place` | ❌ | Birth location |
| `content.{lang}.achievements` | ❌ | Key achievements |

### Importance Scale

| Level | Description | Examples |
|-------|-------------|----------|
| 5 | National icons, globally recognized | Bangabandhu, Tagore, Nazrul |
| 4 | Major historical figures | Titumir, Begum Rokeya |
| 3 | Significant regional figures | Baro-Bhuiyans |
| 2 | Notable local figures | District-level heroes |
| 1 | Documented historical figures | Lesser-known contributors |

### Valid Era IDs

- `sultanate` - Sultanate Era (1352-1576)
- `mughal` - Mughal Era (1576-1757)
- `british_raj` - British Colonial Era (1757-1947)
- `british_resistance` - Anti-Colonial Resistance (1757-1947)
- `language_movement` - Language Movement (1948-1956)
- `liberation_1971` - Liberation War 1971

### Valid Category IDs

- `martyr` - Martyrs (শহীদ)
- `revolutionary` - Revolutionaries (বিপ্লবী)
- `intellectual` - Intellectuals (বুদ্ধিজীবী)
- `ruler` - Rulers (শাসক)
- `poet` - Poets (কবি)
- `philosopher` - Philosophers (দার্শনিক)
- `soldier` - Soldiers (সৈনিক)

---

## 🖼️ Adding Hero Images

### Requirements

- **Format**: PNG (preferred) or WebP
- **Dimensions**: 800 x 1000 pixels (portrait, 4:5 ratio)
- **Background**: Transparent or neutral solid color
- **Quality**: High resolution, clear features
- **File Size**: Under 500KB (optimize if larger)

### Naming Convention

```
{slug}.png
```

Examples:
- `titumir.png`
- `begum_rokeya.png`
- `sheikh_mujibur_rahman.png`

### Location

Place images in:
```
assets/images/heroes/
```

### Image Guidelines

✅ **Do:**
- Use official portraits when available
- Maintain aspect ratio
- Ensure face is clearly visible
- Use historically accurate representations

❌ **Don't:**
- Use copyrighted images without permission
- Use low-quality or blurry images
- Include text or watermarks
- Use modern colorized versions without noting

---

## 📅 Adding Historical Events

### Template

```json
{
  "id": "event_XXX",
  "date": "YYYY-MM-DD",
  "title": {
    "en": "Event Title in English",
    "bn": "বাংলায় শিরোনাম"
  },
  "description": {
    "en": "Detailed description of the event.",
    "bn": "ঘটনার বিস্তারিত বিবরণ।"
  },
  "era_id": "era_id",
  "related_hero_ids": ["hero_XXX", "hero_YYY"],
  "image_asset": "assets/images/events/event_name.png"
}
```

### Important Dates to Include

| Date | Event |
|------|-------|
| Feb 21 | Language Martyrs Day |
| Mar 7 | Historic 7th March Speech |
| Mar 25 | Genocide Remembrance Day |
| Mar 26 | Independence Day |
| Apr 17 | Mujibnagar Day |
| Aug 15 | National Mourning Day |
| Dec 14 | Martyred Intellectuals Day |
| Dec 16 | Victory Day |

---

## 🗺️ Adding Locations

### Template

```json
{
  "id": "loc_XXX",
  "name": {
    "en": "Location Name",
    "bn": "স্থানের নাম"
  },
  "region": "District/Division, Country",
  "latitude": 23.8103,
  "longitude": 90.4125
}
```

---

## ✅ Validation Checklist

Before submitting new data, verify:

### Content Accuracy
- [ ] All dates are historically verified
- [ ] Names spelled correctly in both languages
- [ ] Biography is factually accurate
- [ ] Sources can be cited if questioned

### Technical Validity
- [ ] JSON syntax is valid (use a JSON validator)
- [ ] All referenced IDs exist (era, category, location)
- [ ] Image files exist at specified paths
- [ ] No trailing commas in JSON arrays

### Quality Standards
- [ ] Both English and Bengali content provided
- [ ] Short bio is 150-200 characters
- [ ] Full biography is 500-1000 words
- [ ] Achievements are bullet-pointed with •

---

## 🔧 Testing Your Changes

After adding data:

1. **Validate JSON**
   ```bash
   # Use any JSON validator or online tool
   ```

2. **Run Flutter**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Test Features**
   - Search for the new hero by name
   - Check hero appears in correct era
   - Verify both languages display correctly
   - Test "On This Day" if dates match today

---

## 📋 Suggested Heroes to Add

### Sultanate Era
- Shamsuddin Ilyas Shah
- Raja Ganesh
- Husain Shah

### Mughal Era
- Musa Khan (son of Isa Khan)
- Pratapaditya
- Chand Rai & Kedar Rai

### British Era
- Raja Ram Mohan Roy
- Vidyasagar
- Nawab Sirajuddaula
- Tipu Sultan

### Anti-Colonial Resistance
- Khudiram Bose
- Bagha Jatin
- Pritilata Waddedar
- Benoy-Badal-Dinesh

### Language Movement
- Salam, Barkat, Rafiq, Jabbar
- Abdul Matin
- Ghaziul Haq

### Liberation War 1971
- All seven Bir Shresthas
- Tajuddin Ahmad
- M.A.G. Osmani
- Sector Commanders

---

## 🤝 Submitting Contributions

1. Fork the repository
2. Create a new branch for your additions
3. Add data following this guide
4. Submit a pull request with:
   - List of changes made
   - Sources for historical accuracy
   - Any images added

---

*Thank you for helping preserve Bengal's history!*
