# Google Play Console Release Guide - Bengal Heroes

Complete guide for building, signing, and releasing Bengal Heroes on Google Play Store.

## ✅ Current Status (February 14, 2026)

| Task | Status |
|------|--------|
| Debug build fix (removed broken `debug.jks`) | ✅ Done |
| App icon generated from `logo_v3.jpg` | ✅ Done |
| Release keystore generated (`upload-keystore.jks`) | ✅ Done |
| `key.properties` created | ✅ Done |
| ProGuard rules fixed | ✅ Done |
| `.gitignore` updated (keystore/credentials excluded) | ✅ Done |
| Production AAB built with obfuscation + tree-shaking | ✅ Done |

## 📍 Key File Locations

| File | Path |
|------|------|
| **Release AAB** | `bengal_heroes/build/app/outputs/bundle/release/app-release.aab` |
| **Keystore** | `bengal_heroes/android/upload-keystore.jks` |
| **Key Properties** | `bengal_heroes/android/key.properties` |
| **Build Config** | `bengal_heroes/android/app/build.gradle.kts` |
| **ProGuard Rules** | `bengal_heroes/android/app/proguard-rules.pro` |
| **App Logo** | `bengal_heroes/assets/logo/logo_v3.jpg` |

## 🔑 Keystore Details

```
Keystore Type : JKS
Keystore File : android/upload-keystore.jks
Key Alias     : upload
Store Password: bengalheroes2026
Key Password  : bengalheroes2026
Validity      : 10,000 days (~27 years)
DN            : CN=Bengal Bytes, OU=Mobile Development, O=Bengal Bytes, L=Dhaka, ST=Dhaka, C=BD
```

> ⚠️ **CRITICAL SECURITY**: Back up your keystore file and passwords securely. If you lose the keystore, you CANNOT update your app on Google Play. Store a copy in a secure location (encrypted USB, password manager, etc.)

## 🔨 Building A New Release

### Step 1: Update Version

In `pubspec.yaml`, increment the version:

```yaml
# Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
version: 1.0.0+1   # First release
version: 1.0.1+2   # Patch fix (next release)
version: 1.1.0+3   # Minor feature (future)
```

> **IMPORTANT**: Google Play requires the `versionCode` (build number after `+`) to be **strictly increasing** with each upload.

### Step 2: Clean & Build

```powershell
cd bengal_heroes

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build production AAB with all optimizations
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info --tree-shake-icons
```

### Step 3: Verify Output

The AAB will be at:
```
bengal_heroes\build\app\outputs\bundle\release\app-release.aab
```

## 🔐 Signing Configuration

The signing is managed via `android/key.properties` which is loaded by `build.gradle.kts`:

**key.properties** (DO NOT commit to Git):
```properties
storePassword=bengalheroes2026
keyPassword=bengalheroes2026
keyAlias=upload
storeFile=c:\\Users\\coder\\Desktop\\bengal-heroes\\bengal_heroes\\android\\upload-keystore.jks
```

**build.gradle.kts** loads it automatically:
```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

## 📦 Google Play Console Upload

### Step 1: Open Google Play Console

1. Go to https://play.google.com/console
2. Select your app **Bengal Heroes** (or create new app)

### Step 2: Store Listing

Fill in the following:

#### App Details
- **App name**: Bengal Heroes  
- **Category**: Education / Books & Reference
- **Default language**: English (US)

#### App Icon
- Size: 512×512 px PNG
- Use: `assets/logo/logo_v3.jpg` (convert to PNG 512×512 for upload)

#### Feature Graphic
- Size: 1024×500 px PNG

#### Short Description (80 chars max)
```
Discover Bengal's legendary heroes, history & culture through interactive stories
```

#### Full Description
```
Discover the legendary heroes of Bengal!

Bengal Heroes is your gateway to the rich history, culture, and inspiring stories of Bengal's greatest heroes. Explore their remarkable journeys through:

✨ Detailed Hero Profiles
Learn about the lives, achievements, and historical significance of legendary figures.

📅 Interactive Timeline
Trace Bengal's history through major events and eras that shaped the region.

🗺️ Geographical Exploration
Discover locations associated with historical events and heroes.

🌍 Multi-language Support
Available in English and Bengali for a personal experience.

🎓 Educational Content
Perfect for students, history enthusiasts, and cultural explorers.

Features:
• Comprehensive hero database with detailed information
• Interactive timeline of Bengal's history
• Location-based historical events
• Category-wise hero exploration
• Smooth animations and intuitive interface
• Offline-ready design
• No ads - pure history learning

Whether you're a history student or someone proud of Bengali culture, Bengal Heroes brings history to life with beautiful design and rich content.

Learn • Explore • Celebrate Bengal's Heritage!
```

### Step 3: Content Rating

1. Go to **Policy** → **App content** → **Content rating**
2. Answer the questionnaire:
   - Violence: **None**
   - Sexuality: **None**
   - Language: **None**
   - Controlled substance: **None**
   - Type: **Educational/Historical**
3. Expected rating: **Everyone (E)** / **PEGI 3**

### Step 4: Upload AAB

1. Go to **Release** → **Production** (or **Testing** → **Internal testing** for first test)
2. Click **Create new release**
3. Upload `app-release.aab` from: `bengal_heroes\build\app\outputs\bundle\release\`
4. Add release notes:

```
Version 1.0.0 - Initial Release

New Features:
✨ Comprehensive hero database with Bengali legends
✨ Interactive timeline of Bengal's history from Sultanate to modern era
✨ Location-based historical events
✨ Multi-language support (English & Bengali)
✨ Category-based hero exploration
✨ Beautiful UI with smooth animations

Optimizations:
📈 Code obfuscation for security
📈 Tree-shaken icons for smaller app size
📈 R8 full mode optimization
📈 Resource shrinking enabled
```

5. Click **Review Release** → **Start rollout to Production**

### Step 5: Rollout Strategy

#### Recommended: Staged Rollout
| Phase | Percentage | Duration | Focus |
|-------|-----------|----------|-------|
| 1 | 1% | 24-48 hrs | Monitor crashes |
| 2 | 10% | 24-48 hrs | Check feedback |
| 3 | 50% | 1-3 days | Verify stability |
| 4 | 100% | — | Full release |

## 🛡️ Production Optimizations Applied

| Optimization | Status | Details |
|------|--------|---------|
| R8 Code Shrinking | ✅ | `isMinifyEnabled = true` |
| Resource Shrinking | ✅ | `isShrinkResources = true` |
| Code Obfuscation | ✅ | `--obfuscate` flag |
| Tree Shaking | ✅ | `--tree-shake-icons` (99.7% font reduction) |
| ProGuard Rules | ✅ | Custom rules for Flutter, Kotlin, Riverpod |
| Debug Symbols | ✅ | `--split-debug-info` for crash reporting |
| Bundle Splitting | ✅ | Language, density, ABI splits enabled |
| NDK Debug Symbols | ✅ | `debugSymbolLevel = "FULL"` for Play Console |
| R8 Full Mode | ✅ | `android.enableR8.fullMode=true` |
| Gradle Caching | ✅ | Parallel + on-demand configuration |

## ⚠️ Security Checklist

- [x] Keystore file excluded from Git (`.gitignore`)
- [x] `key.properties` excluded from Git (`.gitignore`)
- [ ] Keystore backed up to secure location
- [ ] Keystore password stored in password manager
- [x] `allowBackup="false"` in AndroidManifest.xml
- [x] `usesCleartextTraffic="false"` in AndroidManifest.xml
- [ ] Google Play App Signing enrolled (recommended)

## 🔧 Troubleshooting

### "Keystore file not found for signing config 'debug'"
**Fixed**: Removed custom `debug.jks` reference. Debug builds now use the default Android debug keystore.

### "key.properties not found"
**Solution**: Ensure `android/key.properties` exists with correct paths. The build will fall back to debug signing if not found.

### "-dontshrink conflicts with isShrinkResources"
**Fixed**: Removed `-dontshrink` from ProGuard rules.

### "Version code must increment"
**Solution**: Increase build number in `pubspec.yaml`: `version: 1.0.0+2`

### Build takes too long
**Solution**: The first release build with R8 full mode can take 5-10 minutes. Subsequent builds use Gradle caching.

## 📝 Future Release Workflow (Quick Reference)

```powershell
# 1. Update version in pubspec.yaml (increment +BUILD_NUMBER)
# 2. Run:
cd bengal_heroes
flutter clean
flutter pub get
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info --tree-shake-icons
# 3. Upload build\app\outputs\bundle\release\app-release.aab to Play Console
```

---

**App ID**: `com.bengalbytes.bengalheroes`  
**Keystore Alias**: `upload`  
**Min SDK**: 21 (Android 5.0 Lollipop)  
**Target SDK**: 34 (Android 14)
