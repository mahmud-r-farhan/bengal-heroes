# Bengal Heroes

A production-grade, offline-first Flutter mobile application dedicated to the legends, freedom fighters, and intellectuals of Bengal

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 Features

### Core Features
- **Hero Profiles**: Rich biographies with localized content (English & Bengali)
- **Era-based Categories**: Sultanate, Mughal, British Raj, Liberation 1971, etc.
- **Advanced Search**: Fuzzy search supporting both English and Bengali
- **Filtering**: Filter by era, category, or location
- **On This Day**: Historical events and birthdays matching the current date
- **Favorites**: Save your favorite heroes for quick access

### Technical Features
- **Offline-First**: All data stored locally in JSON assets
- **Material 3 Design**: Modern, elegant historical aesthetic
- **Localization**: Full English and Bengali support
- **State Management**: Riverpod for reactive state management
- **Navigation**: GoRouter for declarative routing
- **Theming**: Light/Dark/System theme modes

## Want to Test the App?

To participate in our closed testing program, please follow the steps below:

### 1. Join the Google Group
First, join our testing group to get access:
- Group: https://groups.google.com/g/playconsole-closed-testing

### 2. Download the App
After joining, download the app from Google Play:
- https://play.google.com/store/apps/details?id=com.bengalbytes.bengalheroes

### Important Note
If you are unable to find the app on the Play Store, please check your Gmail inbox (and spam folder) for the invitation or access confirmation.

---

Thank you for helping us improve the app!

## 🏛️ Architecture

The app follows a **feature-first architecture** with clean separation of concerns:

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Root MaterialApp widget
├── core/
│   ├── constants/            # App-wide constants
│   ├── router/               # GoRouter configuration
│   └── theme/                # Material 3 theme
├── data/
│   ├── models/               # Data models (Hero, Era, Category)
│   ├── datasources/          # Local JSON data source
│   └── repositories/         # Data access layer
├── features/
│   ├── intro/                # Onboarding screen
│   ├── home/                 # Home with On This Day
│   ├── heroes/               # Heroes list with filters
│   ├── hero_detail/          # Hero detail view
│   ├── search/               # Fuzzy search
│   └── settings/             # App settings
└── shared/
    ├── providers/            # Riverpod providers
    └── widgets/              # Reusable widgets
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.10+ |
| State Management | Riverpod |
| Navigation | GoRouter |
| Localization | easy_localization |
| UI/Typography | Google Fonts, Material 3 |
| Search | fuzzy (fuzzy string matching) |
| Storage | SharedPreferences |
| Animations | flutter_animate |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/bengal-heroes.git
   cd bengal-heroes/bengal_heroes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📂 Data Structure

### Hero Model
```json
{
  "id": "hero_001",
  "slug": "titumir",
  "dates": {
    "birth": "1782-01-27",
    "death": "1831-11-19"
  },
  "era": "british_resistance",
  "category": ["martyr", "revolutionary"],
  "images": ["assets/images/heroes/titumir.png"],
  "importance": 5,
  "content": {
    "en": {
      "name": "Titumir",
      "short_bio": "...",
      "full_biography": "...",
      "quote": "...",
      "achievements": "..."
    },
    "bn": { ... }
  }
}
```

## 🎨 Design System

### Color Palette
- **Primary Gold**: `#D4AF37` - Elegance and history
- **Primary Maroon**: `#800020` - Sacrifice and valor
- **Era Colors**: Each era has a distinct color for visual differentiation

### Typography
- **Display**: Playfair Display (heroic, classical)
- **Body**: Source Sans 3 (readable, modern)
- **Bengali**: Hind Siliguri (native support)

## 🌍 Localization

The app supports:
- 🇬🇧 English
- 🇧🇩 Bengali (বাংলা)

All hero content, UI strings, and dates are fully localized.

## 📱 Screenshots

*Screenshots coming soon*

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Adding New Heroes

1. Add hero data to `assets/data/heroes.json`
2. Add hero image to `assets/images/heroes/`
3. Update both English and Bengali content

### Adding New Translations

1. Create a new JSON file in `assets/translations/`
2. Add the locale to `AppConstants.supportedLocales`
3. Translate all strings from `en.json`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- All the heroes of Bengal who sacrificed for freedom
- The historians and researchers who documented these stories
- The open-source community for amazing tools

---

**Made with ❤️ for Bengal**

*This app is a tribute to the legends, freedom fighters, and intellectuals who shaped the history of Bengal.*

> **Note:** The original app signing key has been lost.
