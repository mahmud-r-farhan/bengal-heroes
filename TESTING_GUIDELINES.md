# Bengal Heroes - Testing Guidelines & QA Procedures

## Overview
Comprehensive testing guide for Bengal Heroes app before and after production release. Covers functional testing, performance testing, security testing, and user acceptance testing.

**Version**: 1.0.0  
**Platform**: Android 5.0+ (API 21+)  
**Target**: Google Play Store Release  

---

## Table of Contents
1. [Testing Strategy Overview](#testing-strategy-overview)
2. [Pre-Release Testing](#pre-release-testing)
3. [Functional Testing](#functional-testing)
4. [Performance Testing](#performance-testing)
5. [Security Testing](#security-testing)
6. [Compatibility Testing](#compatibility-testing)
7. [User Acceptance Testing (UAT)](#user-acceptance-testing-uat)
8. [Post-Launch Testing](#post-launch-testing)
9. [Bug Reporting & Resolution](#bug-reporting--resolution)
10. [Testing Tools](#testing-tools)

---

## Testing Strategy Overview

### Testing Levels

```
┌─────────────────────────────────────────┐
│     Production Release Testing           │
├─────────────────────────────────────────┤
│ Unit Tests (Development Phase)           │
│ Widget/Component Tests                   │
│ Integration Tests                        │
│ End-to-End Tests (Manual)                │
│ Performance Testing                      │
│ Security Testing                         │
│ Compatibility Testing                    │
│ User Acceptance Testing (UAT)            │
└─────────────────────────────────────────┘
```

### Testing Timeline

| Phase | Duration | Activities |
|---|---|---|
| **Development** | Ongoing | Unit tests, code review |
| **Integration** | 1 week | Functional testing, integration tests |
| **Beta** | 1-2 weeks | UAT, performance testing |
| **Production** | 1-3 hours | Final pre-launch checks, submission |
| **Post-Launch** | Ongoing | Monitoring, hotfix if needed |

---

## Pre-Release Testing

### Checklist (48 Hours Before Release)

- [ ] **Code Quality**
  - [ ] No console errors/warnings
  - [ ] Code reviewed by team lead
  - [ ] No hardcoded debug values
  - [ ] No commented-out code left

- [ ] **Build & Compilation**
  - [ ] Debug build compiles without errors
  - [ ] Release build compiles without errors
  - [ ] No deprecated dependencies
  - [ ] All imports used

- [ ] **Version & Metadata**
  - [ ] Version number updated in pubspec.yaml
  - [ ] Build number incremented
  - [ ] App icon finalized
  - [ ] Splash screen configured

- [ ] **Assets & Resources**
  - [ ] All images optimized (< 500KB each)
  - [ ] No broken image references
  - [ ] Translations complete (EN, BN)
  - [ ] No placeholder text in UI

- [ ] **Documentation**
  - [ ] README.md updated
  - [ ] Privacy policy prepared
  - [ ] Release notes written
  - [ ] Known limitations documented

---

## Functional Testing

### 1. App Launch & Navigation

**Test Case 1.1: App Launch**
```
Prerequisites: App installed and not previously launched
Steps:
1. Tap app icon on home screen
2. Observe splash screen (2-3 seconds)
3. Wait for home screen to load

Expected Result:
✓ App launches without crash
✓ Splash screen displays properly
✓ Home screen loads within 3 seconds
✓ No loading spinner present after initial load
```

**Test Case 1.2: Navigation Between Screens**
```
Prerequisites: App launched and on home screen
Steps:
1. Tap "Heroes" tab - verify heroes list loads
2. Tap "Timeline" tab - verify timeline loads
3. Tap "Eras" tab - verify eras list loads
4. Tap "Search" tab - verify search screen loads
5. Tap back button - verify previous screen

Expected Result:
✓ All tabs navigate without lag
✓ Back button works correctly
✓ Transitions are smooth
✓ Data persists during navigation
```

### 2. Heroes Viewing & Search

**Test Case 2.1: View Heroes List**
```
Prerequisites: App on Heroes screen
Steps:
1. Observe heroes list loaded
2. Scroll up and down through list
3. Tap on a hero card

Expected Result:
✓ All heroes display with images
✓ Scrolling is smooth
✓ Hero detail screen opens
✓ No visual glitches or overlapping text
```

**Test Case 2.2: Hero Detail View**
```
Prerequisites: Hero detail screen open
Steps:
1. Observe all information displayed:
   - Photo
   - Name
   - Birth/death dates
   - Description
   - Related era/timeline
2. Scroll to view full content
3. Tap related links if present

Expected Result:
✓ All text readable and properly formatted
✓ Image displays without distortion
✓ No overlapping content
✓ Layout adapts to screen size
```

**Test Case 2.3: Search Functionality**
```
Prerequisites: App on Search screen
Steps:
1. Type partial hero name (e.g., "rah")
2. Observe search results appear
3. Clear search and try another
4. Search for non-existent hero

Expected Result:
✓ Search results update in real-time
✓ Correct heroes displayed
✓ "No results" message for invalid search
✓ Keyboard appears and dismisses properly
```

### 3. Timeline & Eras Features

**Test Case 3.1: Timeline Navigation**
```
Prerequisites: App on Timeline screen
Steps:
1. Observe timeline with events
2. Scroll horizontally through timeline
3. Tap on an event
4. View event details

Expected Result:
✓ Timeline renders correctly
✓ Horizontal scroll is smooth
✓ Event popup displays correctly
✓ Close event popup with X or back button
```

**Test Case 3.2: Eras Exploration**
```
Prerequisites: App on Eras screen
Steps:
1. View all eras listed
2. Tap on an era card
3. Observe heroes and events for that era
4. Return to eras list

Expected Result:
✓ All eras display correctly
✓ Era detail screen loads (or filter applied)
✓ Correct content for selected era
✓ Navigation back works smoothly
```

### 4. Language Support

**Test Case 4.1: Language Switching**
```
Prerequisites: App on any screen
Steps:
1. Access settings/language menu
2. Toggle between English and Bengali
3. Verify UI text changes
4. Verify image captions change (if applicable)
5. Return to previous screen
6. Verify language persists

Expected Result:
✓ Language changes immediately
✓ All visible text translates correctly
✓ No text overflow in Bengali
✓ Language choice persists after app restart
```

**Test Case 4.2: Text Direction (RTL)**
```
Prerequisites: App in Bengali mode
Steps:
1. Check text alignment
2. Check button/icon positioning
3. Check navigation direction

Expected Result:
✓ RTL layout (if supported) displays correctly
✓ No broken layouts
✓ Text readable in both directions
```

### 5. Offline Functionality

**Test Case 5.1: Offline Content Access**
```
Prerequisites: App launched once with internet, now offline
Steps:
1. Disable WiFi and mobile data
2. Launch app
3. Navigate to Heroes/Timeline/Eras
4. Search for heroes

Expected Result:
✓ Cached content displays normally
✓ "Offline mode" indicator present (if applicable)
✓ No crash or blank screens
✓ All data accessible from cache
```

**Test Case 5.2: Network Recovery**
```
Prerequisites: App in offline mode
Steps:
1. Enable internet connection
2. Perform any action requiring network
3. Observe connection re-established

Expected Result:
✓ App automatically restores connectivity
✓ Data refreshes (if applicable)
✓ No manual app restart required
✓ Smooth transition from offline to online
```

---

## Performance Testing

### 1. App Startup Performance

**Test Case P1: App Launch Time**
```
Prerequisites: App fully closed (not in background)
Measurement: Use Android Studio Profiler
Steps:
1. Record the moment of app icon tap
2. Record the moment home screen is interactive
3. Calculate time difference

Target Metrics:
✓ Cold start: < 3 seconds
✓ Warm start: < 1.5 seconds
✓ Hot start: < 1 second

If exceeds target:
→ Profile app startup
→ Check for heavy initializations
→ Optimize `main()` and `initState()`
```

### 2. Memory Usage

**Test Case P2: Memory Consumption**
```
Tools: Android Studio Profiler
Steps:
1. Open Profiler tab
2. Launch app
3. Navigate through all screens
4. Perform heavy operations (load images, scroll)
5. Observe memory graph

Target Metrics:
✓ Initial memory: 50-100 MB
✓ Peak memory: < 250 MB
✓ No memory leaks
✓ Memory stabilizes after navigation

If exceeds:
→ Profile with Memory Profiler
→ Check for retained objects
→ Optimize image caching
→ Clear unused listeners
```

### 3. Battery Usage

**Test Case P3: Battery Consumption**
```
Duration: 15-30 minutes of continuous use
Tools: Android device battery settings
Steps:
1. Close all background apps
2. Note initial battery %
3. Use app continuously:
   - Scroll heroes list
   - Navigate between screens
   - Read detailed content
4. Note final battery %
5. Calculate battery drain rate

Target Metric:
✓ Battery drain: < 5% per 15 minutes of active use
✓ Minimal drain when idle/background

If exceeds:
→ Check for excessive CPU usage
→ Reduce animation frame rate
→ Optimize network requests
→ Profile with Android Profiler
```

### 4. Data Usage

**Test Case P4: Network Data Consumption**
```
Tools: Android Settings → Network → Data Usage
Steps:
1. Note initial data usage
2. Perform all app actions:
   - Scroll through content
   - Switch languages
   - Load images
3. Calculate data used
4. Note if background data is consumed

Target Metric:
✓ Initial app load: < 5 MB
✓ Navigation/searching: < 1 MB per action
✓ No unnecessary background data

If exceeds:
→ Check image sizes
→ Implement caching
→ Reduce API calls
→ Compress assets
```

### 5. Scrolling & Animation Performance

**Test Case P5: Frame Rate During Scrolling**
```
Tools: Android Studio → Enable "Show GPU rendering"
Steps:
1. Enable GPU rendering overlay
2. Scroll through heroes list
3. Observe green bars in overlay
4. All frames should be green (60 FPS)

Target Metric:
✓ Scroll FPS: 60 FPS (no yellow/red bars)
✓ No jank or stuttering

If issues found:
→ Profile rendering
→ Reduce animation complexity
→ Use `const` constructors
→ Implement `RepaintBoundary`
```

---

## Security Testing

### 1. Code Obfuscation

**Test Case S1: Verify Obfuscation**
```
Prerequisites: Release APK built with --obfuscate flag
Tools: APK decompiler (e.g., JADX, apktool)
Steps:
1. Extract release APK
2. Decompile APK
3. Search for:
   - Class names (should be `a`, `b`, `c`, etc.)
   - Method names (should be obfuscated)
   - String literals (should be preserved for functionality)

Expected Result:
✓ Classes/methods are obfuscated
✓ App-specific logic is unreadable
✓ Functionality still works correctly
```

### 2. Secrets & Hardcoded Data

**Test Case S2: Search for Hardcoded Secrets**
```
Tools: Grep, JADX, GitHub Secret Scanner
Steps:
1. Review source code for:
   - API keys
   - Passwords
   - Private tokens
   - Database credentials
2. Decompile release APK
3. Search for sensitive data

Expected Result:
✓ No hardcoded secrets in source code
✓ No API keys in APK
✓ All sensitive data loaded from secure sources
```

**Test Case S3: Secure Transmission**
```
Tools: Android Network Monitor, Burp Suite (if testing APIs)
Steps:
1. Monitor network traffic while using app
2. Verify all connections use HTTPS
3. Check for cleartext traffic

Expected Result:
✓ All network requests use HTTPS
✓ No HTTP requests
✓ Certificate validation in place
```

### 3. Permissions Testing

**Test Case S4: Minimal Permissions**
```
Prerequisites: App installed
Steps:
1. Open Settings → Apps → Bengal Heroes → Permissions
2. Review all requested permissions
3. Verify each permission is necessary

Current Permissions (Expected):
✓ INTERNET (for network access)
✓ STORAGE (for caching)

NOT Required:
✗ CAMERA
✗ MICROPHONE
✗ CONTACTS
✗ LOCATION
✗ PHONE STATE

Expected Result:
✓ Only necessary permissions requested
✓ No over-privileged app
```

### 4. Data Storage

**Test Case S5: Local Data Security**
```
Prerequisites: App installed and used
Tools: Android Studio Device Explorer
Steps:
1. Navigate to /data/data/com.bengalbytes.bengalheroes/
2. Check for:
   - Database files
   - Shared preferences
   - Cache files
3. Review file permissions

Expected Result:
✓ Sensitive data is encrypted
✓ File permissions are restrictive (600)
✓ No plain-text sensitive data
✓ Backup prevention enabled where needed
```

---

## Compatibility Testing

### 1. Device Compatibility

**Test on Following Device Types:**

| Device Type | OS Version | Screen Size | Status |
|---|---|---|---|
| Small phone | Android 9 | 4.5" | ✓ Test |
| Standard phone | Android 12 | 5.5" | ✓ Test |
| Large phone | Android 13 | 6.7" | ✓ Test |
| Tablet | Android 12 | 10" | ✓ Test (if targeting) |

**Test Case C1: Screen Orientation**
```
Prerequisites: App installed
Steps:
1. Rotate device to portrait
2. Verify layout and content
3. Rotate device to landscape
4. Verify layout adapts

Expected Result:
✓ Layout responsive in both orientations
✓ No content cut off
✓ Text readable in both modes
✓ Navigation works in both modes
```

**Test Case C2: Android Version Compatibility**
```
Prerequisites: Target SDK 34, Min SDK 21
Test on:
- Android 5.0 (API 21) - Minimum
- Android 7.0 (API 24) - Mid-range
- Android 12.0 (API 31) - Recent
- Android 14.0 (API 34) - Latest

Steps:
1. Install on each version
2. Run through all features
3. Verify no crashes or warnings

Expected Result:
✓ App works on all supported versions
✓ No runtime errors specific to Android version
✓ Proper deprecation handling
```

### 2. Screen Size Testing

**Test Case C3: Different Screen Sizes**
```
Test on:
- 4.5" phone (small)
- 5.5" phone (normal)
- 6.5" phone (large)
- 7" tablet (if applicable)

Steps:
1. Launch app on each size
2. Verify text is readable
3. Verify buttons are tappable (min 48dp)
4. Verify no overlapping elements
5. Verify images scale properly

Expected Result:
✓ UI adapts to different screen sizes
✓ Consistent user experience
✓ All interactive elements accessible
```

---

## User Acceptance Testing (UAT)

### UAT Planning

**Duration**: 1-2 weeks before launch  
**Participants**: 5-10 test users (mix of demographics)  
**Focus**: Real-world usage scenarios

### UAT Test Scenarios

**Scenario 1: First-Time User Experience**
```
User Profile: Never used app before
Steps:
1. Download and install app
2. Launch app
3. Explore home screen
4. Navigate to each feature
5. Search for a hero
6. View timeline and eras
7. Close and relaunch app

Task: Rate experience 1-5 stars and provide feedback

Success Criteria:
✓ No crashes during exploration
✓ Intuitive navigation
✓ Clear app purpose
✓ User can accomplish basic tasks
```

**Scenario 2: Regular User Tasks**
```
User Profile: Wants to learn about specific heroes
Steps:
1. Search for "Subhas Chandra Bose"
2. Read biodata
3. Switch language to Bengali
4. Navigate to timeline
5. Explore events related to hero
6. Switch to list view and search again

Task: Complete all tasks successfully and rate ease of use

Success Criteria:
✓ Search works accurately
✓ Content loads without wait
✓ Language switch is smooth
✓ All information is accessible
```

**Scenario 3: Student Research**
```
User Profile: Student researching Bengal history
Steps:
1. Explore eras section
2. Read about Bengal renaissance era
3. Find heroes from that era
4. Access timeline for context
5. Use language switch for Bengali reading

Task: Gather information for essay

Success Criteria:
✓ Content is educational and accurate
✓ Navigation between related content is easy
✓ Information is complete and well-organized
✓ App supports learning goals
```

### UAT Feedback Collection

Create feedback form covering:

```
1. App Performance
   - App launch time
   - Navigation speed
   - Screen loading time
   Rating: 1-5 stars

2. User Interface
   - Button placement intuitive?
   - Text readable?
   - Images display well?
   - Navigation clear?
   Rating: 1-5 stars

3. Content Quality
   - Information accurate?
   - Information complete?
   - Images relevant?
   - Translations correct?
   Rating: 1-5 stars

4. Feature Functionality
   - Search works correctly?
   - Timeline useful?
   - Eras section informative?
   - Language switch smooth?
   Rating: 1-5 stars

5. Overall Experience
   - Would you recommend?
   - What would you improve?
   - Any crashes or issues?
   Feedback: Free text

6. Device Information
   - Device model
   - Android version
   - iOS version (if testing iOS)
```

### UAT Issue Resolution

**Priority Levels**:
- 🔴 **Critical**: App crash, complete feature failure
  - Fix before release
  - Re-test immediately
  
- 🟠 **High**: Major feature partially broken
  - Fix if possible before release
  - Otherwise document as known issue
  
- 🟡 **Medium**: Minor issue, workaround exists
  - Fix in next update
  - Document if critical to understand
  
- 🟢 **Low**: Polish, UX improvement
  - Fix in future update

---

## Post-Launch Testing

### Monitoring & Verification

**Immediate (First 24 Hours)**

```powershell
# Monitor via Google Play Console
1. Check app is live and searchable
2. Monitor crash reports
3. Monitor rating and reviews
4. Monitor installation metrics
5. Verify no critical errors reported
```

**First Week**

- [ ] Monitor daily crash rate (target: < 1%)
- [ ] Monitor daily active users
- [ ] Monitor user retention (day 1, day 7)
- [ ] Review top user feedback
- [ ] Fix any reported critical bugs
- [ ] Monitor performance metrics

**Monthly**

- [ ] Review user analytics
- [ ] Analyze crash reports and patterns
- [ ] Monitor ratings changes
- [ ] Identify most used features
- [ ] Plan updates based on feedback

---

## Bug Reporting & Resolution

### Bug Report Template

```markdown
**Title**: [Brief description of bug]

**Severity**: 
- [ ] Critical (app crash)
- [ ] High (feature broken)
- [ ] Medium (feature partially broken)
- [ ] Low (minor issue)

**Device Information**:
- Device Model: [e.g., Samsung Galaxy S21]
- Android Version: [e.g., 12.0]
- App Version: [e.g., 1.0.0]

**Steps to Reproduce**:
1. [First action]
2. [Second action]
3. [etc.]

**Expected Result**:
[What should happen]

**Actual Result**:
[What actually happens]

**Screenshots/Video**:
[Attach if applicable]

**Additional Notes**:
[Any other relevant information]
```

### Bug Resolution Workflow

```
1. Report Bug → 2. Verify Bug → 3. Assign Severity
        ↓              ↓               ↓
4. Fix Bug → 5. Test Fix → 6. Deploy Fix
        ↓              ↓               ↓
7. Verify in Production ← Closed ←──┘
```

---

## Testing Tools

### Recommended Tools

| Tool | Purpose | Type |
|---|---|---|
| **Android Studio** | Build, test, profile | Development |
| **Android Emulator** | Device simulation | Testing |
| **Google Play Console** | Pre-launch reports | Validation |
| **Firebase** | Analytics, crash reporting | Monitoring |
| **Perfetto** | Performance profiling | Performance |
| **Charles Proxy** | Network monitoring | Security |

### Command-Line Testing

```powershell
# Run tests
flutter test

# Build release APK for testing
flutter build apk --release

# Build AAB for Play Store testing
flutter build appbundle --release

# Run on connected device
flutter run -v

# Run with profiling
flutter run --profile

# Generate coverage report
flutter test --coverage
```

---

## Testing Checklist Matrix

| Feature | Functional | Performance | Security | Compat | UAT | Status |
|---|---|---|---|---|---|---|
| App Launch | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Home Screen | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Heroes List | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Hero Detail | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Search | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Timeline | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Eras | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Language Switch | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Offline Mode | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |
| Navigation | ✓ | ✓ | ✓ | ✓ | ✓ | ✅ |

---

## Quick Reference: Test Before Each Release

```
PRE-RELEASE TESTS (48 HOURS BEFORE)
□ No crashes on home screen
□ All 5 features (Heroes, Timeline, Eras, Search, Settings) work
□ Language switch works (EN/BN)
□ Search returns correct results
□ Offline mode functional
□ No visual glitches
□ All text readable and properly formatted
□ Performance acceptable (no long waits)
□ No hardcoded debug data visible
□ Version numbers updated
□ ProGuard enabled in release build
```

---

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Android Testing Guide](https://developer.android.com/guide/components/activities/testing)
- [Google Play Console Pre-launch Reports](https://support.google.com/googleplay/android-developer/answer/9019589)
- [Firebase Crash Reporting](https://firebase.google.com/products/crashlytics)
- [Android Performance](https://developer.android.com/guide/topics/performance)

---

**Last Updated**: February 2026  
**Created By**: QA Team  
**Status**: Active ✅
