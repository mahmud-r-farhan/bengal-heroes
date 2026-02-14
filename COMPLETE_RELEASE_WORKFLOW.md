# Bengal Heroes - Complete Release Workflow

Step-by-step guide from coding to Google Play Store release.

## 📅 Release Timeline

**Recommended**: 1-2 weeks before target release date

```
Day -7: Code freeze & final testing
Day -3: Build preparation & security setup
Day -1: Final review & approval
Day 0: Release to staging (1%)
Day 1-2: Monitor, expand to 5%
Day 3-5: Monitor, expand to 10%
Day 5-7: Full rollout (100%)
Day 8+: Monitor metrics & plan next release
```

## Phase 1: Preparation (Day -7 to -3)

### 1.1 Code Quality

```powershell
# Navigate to project
cd bengal_heroes

# Run all tests
flutter test

# Analyze code
flutter analyze

# Check for issues
dart fix --dry-run
```

Expected output:
✅ All tests passing
✅ No analysis warnings
✅ Code formatting correct

### 1.2 Version Bump

Edit `pubspec.yaml`:

```yaml
# OLD
version: 0.9.0+5

# NEW
version: 1.0.0+1
```

Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`

### 1.3 Update Documentation

Create/update these files:

**CHANGELOG.md**:
```markdown
## 1.0.0 (February 14, 2026)

### New Features
- Complete hero database (100+ heroes)
- Interactive timeline of Bengal's history
- Location-based event explorer
- Multi-language support (English & Bengali)
- Beautiful Material 3 design

### Performance
- 50% reduction in APK size
- Smooth 60 FPS animations
- Optimized data loading

### Improvements
- Enhanced offline support
- Better error handling
- Improved accessibility

### Translations
- English (complete)
- Bengali (complete)
```

**README.md**:
```markdown
# Bengal Heroes

A mobile app celebrating the legendary heroes of Bengal.

## Features
- 100+ detailed hero profiles
- Interactive historical timeline
- Location-based event exploration
- Dual language support
- Offline functionality

## Requirements
- Android 6.0+ (minSdkVersion 21)
- 40-60 MB storage space
- 3GB+ RAM recommended

## Installation

### From Google Play Store
[Link will be here after release]

### Build from Source
```bash
flutter pub get
flutter build appbundle --release
```

## Contributing
[Your contribution guidelines]

## License
[Your license]

## Credits
[Acknowledgments]
```

### 1.4 Privacy & Legal Review

Create/finalize:

**privacy_policy.md**:
```markdown
# Privacy Policy - Bengal Heroes

Last Updated: February 14, 2026

## Data Collection
- No personal data collected
- No account creation required
- No login authentication
- No identifiable information

## Analytics
- Optional Firebase Analytics
- Anonymous usage patterns only
- User can opt-out

## Permissions
- Internet: For data synchronization
- Storage: For local caching

## Data Retention
- Local data: Until app uninstall
- Cloud data: None retained

## Third-party Services
- Firebase Analytics (optional)
- Google Play Services (required)

## Contact
bengalheroes@bengalbytes.com
```

**terms_of_service.md**:
```markdown
# Terms of Service - Bengal Heroes

## License
Bengal Heroes is provided "as-is" for educational purposes.

## Acceptable Use
Users may not:
- Reverse engineer the app
- Distribute modified versions
- Use for commercial purposes without permission
- Violate intellectual property rights

## Limitations
- No warranty provided
- No liability for information accuracy
- App may be updated without notice

## Changes
We reserve the right to modify these terms.
```

### 1.5 Create Store Assets

Organize in `assets_for_store/`:

```
assets_for_store/
├── icon_512x512.png          (App icon)
├── feature_graphic_1024x500.png
├── screenshots/
│   ├── screenshot_1_en.png   (1080x1920)
│   ├── screenshot_2_en.png
│   ├── screenshot_3_en.png
│   ├── screenshot_4_en.png
│   ├── screenshot_5_en.png
│   └── ...
└── preview_video.mp4 (optional)
```

Screenshots should showcase:
1. Home screen
2. Hero list/search
3. Hero detail screen
4. Timeline view
5. Map/location view
6. Settings
7. Language selection
8. Dark mode (if available)

## Phase 2: Security & Credentials (Day -3 to -1)

### 2.1 Keystore Setup

```powershell
# 1. Generate keystore (if not already done)
cd "$env:USERPROFILE\.android"
keytool -genkey -v -keystore bengal_heroes_release.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias bengal_heroes_key

# 2. Verify keystore
keytool -list -v -keystore bengal_heroes_release.jks
```

Save output with certificate fingerprints!

### 2.2 Environment Variables

Create `.env.release` (NOT in git):

```env
KEYSTORE_PATH=C:\Users\YourUsername\.android\bengal_heroes_release.jks
KEYSTORE_PASSWORD=YourStrongPassword123!
KEY_ALIAS=bengal_heroes_key
KEY_PASSWORD=YourStrongPassword123!
```

Add to `.gitignore`:
```
.env*
*.jks
*.keystore
```

### 2.3 Google Play Console Setup

1. Go to https://play.google.com/console
2. Create new application:
   - App name: "Bengal Heroes"
   - Default language: English
   - App or game: App
   - Category: Books & Reference / Education
   - Enter contact details
3. Accept policies
4. Note Application ID: `com.bengalbytes.bengalheroes`

## Phase 3: Build & Testing (Day -1 to 0)

### 3.1 Test APK Build

```powershell
# Navigate to project
cd bengal_heroes

# Set environment variables
$env:KEYSTORE_PATH = "C:\Users\YourUsername\.android\bengal_heroes_release.jks"
$env:KEYSTORE_PASSWORD = "YourPassword123!"
$env:KEY_ALIAS = "bengal_heroes_key"
$env:KEY_PASSWORD = "YourPassword123!"

# Clean
flutter clean

# Get dependencies
flutter pub get

# Build test APK
flutter build apk --release -v
```

Expected:
✅ Build completes without errors
✅ APK size: 40-60 MB
✅ Location: `build/app/outputs/apk/release/app-release.apk`

### 3.2 Device Testing

```powershell
# Install APK on device
adb install build/app/outputs/apk/release/app-release.apk

# Test on device:
# ✓ App launches
# ✓ No crashes
# ✓ All screens load
# ✓ Navigation smooth
# ✓ Language switching works
# ✓ Offline functionality works
# ✓ Performance good
```

### 3.3 Build Release AAB

```powershell
# Build Android App Bundle
flutter build appbundle --release -v

# Expected
# ✓ Build completes without errors
# ✓ AAB size: 25-35 MB
# ✓ Location: build/app/outputs/bundle/release/app-release.aab
```

### 3.4 Verify AAB

```powershell
# Check AAB integrity
# Download bundletool (if not already)
wget https://developer.android.com/studio/command-line/bundletool/bundletool-all-LATEST.jar

# Validate AAB
java -jar bundletool-all.jar validate --bundle-path app-release.aab

# Generate APKs from AAB
java -jar bundletool-all.jar build-apks `
  --bundle=app-release.aab `
  --output=app.apks `
  --ks=bengal_heroes_release.jks `
  --ks-pass=pass:YourPassword123! `
  --ks-key-alias=bengal_heroes_key `
  --key-pass=pass:YourPassword123!
```

## Phase 4: Final Review (Day 0)

### 4.1 Checklist

- [ ] Code quality: All tests passing
- [ ] Version bumped in pubspec.yaml
- [ ] CHANGELOG updated
- [ ] Privacy policy complete
- [ ] Store assets ready
- [ ] Credentials stored securely
- [ ] APK tested on device
- [ ] AAB built successfully
- [ ] Team approval received
- [ ] No last-minute changes

### 4.2 Final Sign-Off

```
RELEASE APPROVAL FORM

Release: Bengal Heroes v1.0.0
Date: February 14, 2026
Build Number: 1

Quality Assurance:
- Tested on Android 6.0: ✓
- Tested on Android 14: ✓
- Crashes detected: 0
- Performance: Acceptable
- QA Sign-off: [NAME]

Security:
- Keystore configured: ✓
- Credentials secure: ✓
- No sensitive data: ✓
- Security review: [NAME]

Product:
- Features complete: ✓
- Documentation done: ✓
- Store assets ready: ✓
- Product approval: [NAME]

Authorization to Release: ✓ APPROVED
```

## Phase 5: Google Play Store Upload (Day 0)

### 5.1 Access Console

1. Go to https://play.google.com/console
2. Select "Bengal Heroes"
3. Navigation:
   - Testing → Internal testing (first) or
   - Release → Production (for full release)

### 5.2 Upload AAB

1. Click "Create new release"
2. Upload AAB file:
   - Click "Browse files"
   - Select `app-release.aab`
3. Fill in details:
   - Release name: `1.0.0`
   - Release notes:
   ```
   First Release - Bengal Heroes v1.0.0

   🎉 Initial Release with:
   - 100+ hero profiles
   - Interactive timeline
   - Location explorer
   - Dual language (English/Bengali)

   Thank you for downloading Bengal Heroes!
   ```

### 5.3 Set Rollout

**First Release - Recommended**:

1. Select "Staged rollout"
2. Set to 1% of devices
3. Click "Review release"
4. Final check of all details
5. Click "Start rollout"

### 5.4 Monitor Launch

Monitor in real-time:

```
Dashboard → Analytics
├── Install quantity (should increase)
├── Crash rate (should be < 0.5%)
├── Uninstall quantity (track over time)
├── Rating (collect feedback)
└── Reviews (read for issues)
```

## Phase 6: Staged Rollout (Days 1-7)

### Day 1: 1% Rollout

Timeline:
- Hour 0-6: Heavy monitoring
  - Check crash reports
  - Monitor performance
  - Read first reviews

- Hour 6-24: Continue monitoring
  - Verify no critical issues
  - Collect user feedback

Decision:
- If stable: Increase to 5%
- If issues: Pause or rollback

### Day 2-3: 5% Rollout

- Monitor crash rate
- Collect feedback from larger audience
- Verify on different device types

### Day 4-5: 10% Rollout

- Extensive compatibility testing with real devices
- Monitor for patterns in crashes
- Check performance on low-end devices

### Day 6-7: Complete Rollout

- Expand to all devices
- Monitor for any issues
- Prepare post-release communication

## Phase 7: Post-Release Monitoring (Days 8+)

### Daily Activities (First Week)

```
Daily Checklist:
□ Check crash reports
□ Review new reviews
□ Monitor ratings trend
□ Check active user count
□ Verify performance metrics
□ Response to critical issues
```

### Weekly Review

```
Weekly Report:
- Total installs: XXX
- Active users: YYY
- Crash rate: Z%
- Average rating: A.B stars
- Issues found: [List]
- Fixes deployed: [List]
- Next steps: [Plan]
```

### Key Metrics to Track

| Metric | Target | Action if Below |
|--------|--------|-----------------|
| Crash Rate | < 0.5% | Investigate & hotfix |
| App Rating | 4.0+ | Improve & address reviews |
| Session Length | 5+ min | Check engagement features |
| Active Users | Increasing | Adjust marketing if needed |
| Retention | 30-40% D1 | Improve retention features |

## Phase 8: Plan Next Version

### Within 1 Week of Release

1. **Gather Feedback**
   - Compile user reviews
   - Check GitHub issues
   - Analyze crash reports

2. **Plan v1.0.1 (Patch)**
   - Hot fixes for bugs
   - Minor improvements
   - Expected: Within 1-2 weeks

3. **Plan v1.1.0 (Minor)**
   - New features
   - Requested enhancements
   - Expected: 1-2 months

4. **Vision for v2.0.0 (Major)**
   - Major features
   - Architecture changes
   - Expected: 6+ months

## 🎯 Release Commands Quick Reference

```powershell
# Complete release workflow

# 1. Setup
$env:KEYSTORE_PATH = "..."
$env:KEYSTORE_PASSWORD = "..."
$env:KEY_ALIAS = "..."
$env:KEY_PASSWORD = "..."

# 2. Clean & build
cd bengal_heroes
flutter clean
flutter pub get

# 3. Test APK
flutter build apk --release -v
adb install build/app/outputs/apk/release/app-release.apk

# 4. Build AAB
flutter build appbundle --release -v

# 5. Validate
java -jar bundletool-all.jar validate --bundle-path app-release.aab

# 6. Upload to Google Play Console
# (Manual process through web console)
```

## 📊 Success Metrics (3 Months Post-Release)

Targets for a successful release:

- **Installs**: 1000+ (varies by marketing)
- **Rating**: 4.2+ stars
- **Reviews**: 50+ user reviews
- **Retention**: 30%+ 7-day retention
- **Crashes**: < 0.1% crash rate
- **Performance**: 95%+ ANR-free sessions

---

**You're now ready to release Bengal Heroes to Google Play! 🚀**

For support: Refer to individual guide documents for detailed help.
