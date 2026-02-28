# Bengal Heroes - Production Setup & Signing Configuration Guide

## Overview
This guide provides complete instructions for preparing the Bengal Heroes app for production release on Google Play Store. It covers code signing, build optimization, and configuration management.

**Version**: 1.0.0 (Build 1)  
**Target Platform**: Android (Google Play Store)  
**Target SDK**: Android 34+  
**Min SDK**: Android 21+  

---

## Table of Contents
1. [Pre-Release Checklist](#pre-release-checklist)
2. [Create Signing Keystore](#create-signing-keystore)
3. [Configure Environment Variables](#configure-environment-variables)
4. [Build Configuration Review](#build-configuration-review)
5. [Code Optimization Settings](#code-optimization-settings)
6. [Versioning Strategy](#versioning-strategy)
7. [Security Guidelines](#security-guidelines)
8. [Common Issues & Troubleshooting](#common-issues--troubleshooting)

---

## Pre-Release Checklist

Before proceeding with production build, ensure:

- [ ] **Code Review**: All code has been reviewed and committed to version control
- [ ] **Version Updated**: `pubspec.yaml` version number reflects the release (e.g., 1.0.0+1)
- [ ] **Dependencies Updated**: Run `flutter pub get` and verify no deprecated packages
- [ ] **Assets Optimized**: All images and assets are properly compressed
- [ ] **Translations Complete**: All supported languages (EN, BN) are properly translated
- [ ] **Error Handling**: App handles network errors gracefully
- [ ] **Permissions**: AndroidManifest.xml includes only necessary permissions
- [ ] **Branding Assets**: App icon and splash screen are finalized
- [ ] **Privacy Policy**: Prepare privacy policy URL for Google Play Store

---

## Create Signing Keystore

### Step 1: Generate a New Keystore (One-time Setup)

Run this command in PowerShell/Terminal:

```powershell
# On Windows (PowerShell as Administrator)
keytool -genkey -v -keystore "C:\Users\<YourUsername>\.android\bengal_heroes.keystore" `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10950 `
  -alias bengal_heroes_key `
  -storepass <YOUR_SECURE_PASSWORD> `
  -keypass <YOUR_SECURE_PASSWORD>
```

**Replace**:
- `<YourUsername>`: Your Windows username
- `<YOUR_SECURE_PASSWORD>`: A strong password (min 8 characters, including special characters)

### Step 2: Keystore Details Entry

When prompted, enter the following information:

```
First and Last Name: Bengal Heroes App
Organizational Unit: Engineering
Organization: Bengal Bytes
City or Locality: Kolkata
State or Province: West Bengal
Country Code: IN
```

### Step 3: Verify Keystore Creation

```powershell
# List keystore contents
keytool -list -v -keystore "C:\Users\<YourUsername>\.android\bengal_heroes.keystore" `
  -storepass <YOUR_SECURE_PASSWORD>
```

**⚠️ IMPORTANT**: 
- Keep this keystore file in a SECURE location
- Never commit keystore file to Git repository
- Add `*.keystore` to `.gitignore`
- Backup the keystore file securely (USB drive, encrypted cloud storage)

---

## Configure Environment Variables

### Method 1: Set Environment Variables (Recommended for CI/CD)

**On Windows (Permanent)**:

1. Open Environment Variables:
   - Press `Win + X` → System
   - Advanced system settings → Environment Variables
   - Click "New" under System variables

2. Add the following variables:

| Variable Name | Value |
|---|---|
| `KEYSTORE_PATH` | `C:\Users\<YourUsername>\.android\bengal_heroes.keystore` |
| `KEYSTORE_PASSWORD` | `<YOUR_SECURE_PASSWORD>` |
| `KEY_ALIAS` | `bengal_heroes_key` |
| `KEY_PASSWORD` | `<YOUR_SECURE_PASSWORD>` |

3. Restart PowerShell to load variables

### Method 2: Local Properties File (For Local Development)

Create/edit `android/local.properties`:

```properties
# Keystore configuration
KEYSTORE_PATH=C:\Users\<YourUsername>\.android\bengal_heroes.keystore
KEYSTORE_PASSWORD=<YOUR_SECURE_PASSWORD>
KEY_ALIAS=bengal_heroes_key
KEY_PASSWORD=<YOUR_SECURE_PASSWORD>

# SDK and tool paths
sdk.dir=/path/to/android/sdk
flutter.sdk=/path/to/flutter
```

### Method 3: `.env` File (For Manual Builds)

Create `android/.env`:

```bash
KEYSTORE_PATH=/path/to/bengal_heroes.keystore
KEYSTORE_PASSWORD=your_password
KEY_ALIAS=bengal_heroes_key
KEY_PASSWORD=your_password
```

---

## Build Configuration Review

### Current Production Settings

The app is configured with the following production optimizations:

#### Release Build Optimization (`android/app/build.gradle.kts`)

```kotlin
buildTypes {
    release {
        isMinifyEnabled = true              // Enable R8 code shrinking
        isShrinkResources = true            // Remove unused resources
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        signingConfig = signingConfigs.getByName("release")
        buildConfigField("boolean", "DEBUG_MODE", "false")
    }
}
```

#### ProGuard Rules (`android/app/proguard-rules.pro`)

- Keeps Flutter and Dart classes intact
- Removes debug logging in production
- Obfuscates business logic while preserving functionality
- Optimizes code for smaller app size

---

## Code Optimization Settings

### 1. Enable R8 Full Mode
Status: ✅ **ENABLED**

```properties
# android/gradle.properties
android.enableR8.fullMode=true
```

Benefits:
- Better code optimization than ProGuard
- Smaller APK/AAB size
- Improved performance

### 2. Resource Shrinking
Status: ✅ **ENABLED**

Removes unused resources like unused strings, colors, dimensions.

### 3. Gradle Cache & Parallel Build
Status: ✅ **ENABLED**

```properties
org.gradle.caching=true
org.gradle.parallel=true
org.gradle.configureondemand=true
```

### 4. ProGuard Optimization
Status: ✅ **CONFIGURED**

- Removes excessive logging
- Obfuscates class names and methods
- Keeps model classes and Flutter APIs safe

---

## Versioning Strategy

### Version Format: `X.Y.Z+B`

- **X** = Major release (features, breaking changes)
- **Y** = Minor release (new features)
- **Z** = Patch (bug fixes, security updates)
- **B** = Build number (internal build counter)

### Current Version

```yaml
# pubspec.yaml
version: 1.0.0+1
```

### For Future Updates

#### Minor Bug Fix (e.g., 1.0.1)
```yaml
version: 1.0.1+2
```
Command: `flutter pub get`

#### New Features (e.g., 1.1.0)
```yaml
version: 1.1.0+3
```

#### Major Release (e.g., 2.0.0)
```yaml
version: 2.0.0+4
```

**⚠️ Important**:
- Build number (+B) MUST always increase
- Version code in Google Play Store must increment for each release
- Never release the same build number twice

---

## Security Guidelines

### 1. Secure Password Management

- ✅ Never hardcode keystore passwords in code
- ✅ Use environment variables or local.properties
- ✅ Keep keystore password length ≥ 12 characters
- ✅ Use strong passwords: `Mix of numbers, letters, special chars`

Example strong password: `Bg!@Heroes2024#Secure`

### 2. Keystore Security

- ✅ Store keystore in `~/.android/` directory
- ✅ Set file permissions: `chmod 600 ~/.android/bengal_heroes.keystore`
- ✅ Backup to encrypted USB drive or secure cloud
- ✅ Never share keystore with team members over insecure channels

### 3. Code Security

- ✅ No API keys hardcoded in source code
- ✅ Use secure storage for sensitive data
- ✅ Enable ProGuard/R8 obfuscation
- ✅ Keep dependencies updated (`flutter pub upgrade`)

### 4. Network Security

- ✅ Use HTTPS only for API calls
- ✅ Implement certificate pinning (if using APIs)
- ✅ Validate SSL certificates
- ✅ No cleartext traffic allowed (enforced in AndroidManifest.xml)

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
android:usesCleartextTraffic="false"
```

### 5. Data Security

- ✅ Enable backup prevention for sensitive data
- ✅ Use encrypted local storage (via plugins if needed)
- ✅ Implement user privacy controls
- ✅ Comply with GDPR/data protection laws

---

## Building for Production

### Method 1: Build APK (For Testing)

```powershell
# Clean previous builds
flutter clean

# Build release APK
flutter build apk --release --split-per-abi

# Output location:
# build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk
# build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
# build\app\outputs\flutter-apk\app-x86_64-release.apk
```

### Method 2: Build AAB (Recommended for Google Play Store)

```powershell
# Clean previous builds
flutter clean

# Build Android App Bundle (AAB)
flutter build appbundle --release

# Output location:
# build\app\outputs\bundle\release\app-release.aab
```

**Advantages of AAB**:
- Smaller download size for users
- Automatic splitting per device configuration
- Required for new apps on Google Play Store

### Method 3: Complete Release Build with Version Update

```powershell
# Update version in pubspec.yaml (manually)
# Then run:

flutter clean
flutter pub get
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

# This command:
# --release: Builds optimized release version
# --obfuscate: Enables code obfuscation
# --split-debug-info: Separates debug symbols for crash reporting
```

---

## Verification Checklist Before Upload

- [ ] Build completed successfully without errors
- [ ] App bundle (.aab) generated successfully
- [ ] Version number matches release plan
- [ ] Signing keystore configured correctly
- [ ] No hardcoded secrets in code
- [ ] ProGuard optimization enabled
- [ ] Resource shrinking verified
- [ ] App icon updated
- [ ] Splash screen configured
- [ ] Privacy policy URL prepared
- [ ] Screenshot assets prepared
- [ ] Release notes prepared
- [ ] Tested on physical device (if possible)

---

## Common Issues & Troubleshooting

### Issue 1: Keystore Not Found

**Error**: `Keystore file not found: C:\Users\...\bengal_heroes.keystore`

**Solution**:
```powershell
# Verify keystore exists
Test-Path "C:\Users\<YourUsername>\.android\bengal_heroes.keystore"

# Recreate if missing (see Create Signing Keystore section)
```

### Issue 2: Wrong Keystore Password

**Error**: `Keystore was tampered with, or password was incorrect`

**Solution**:
```powershell
# Verify correct password
keytool -list -v -keystore "C:\Users\<YourUsername>\.android\bengal_heroes.keystore" -storepass <PASSWORD>
```

### Issue 3: Build Size Too Large

**Error**: `APK/AAB size is larger than expected`

**Solutions**:
- Enable R8 full mode: `android.enableR8.fullMode=true`
- Enable resource shrinking
- Remove unused assets/images
- Update dependencies to latest versions

### Issue 4: Signing Configuration Not Applied

**Error**: `Debug key used for signing release build`

**Solution**:
```powershell
# Ensure environment variables are set
$env:KEYSTORE_PATH
$env:KEYSTORE_PASSWORD
$env:KEY_ALIAS
$env:KEY_PASSWORD

# Rebuild
flutter clean
flutter build appbundle --release
```

### Issue 5: ProGuard Obfuscation Issues

**Error**: `ClassNotFoundException or MethodNotFoundException after obfuscation`

**Solution**:
In `proguard-rules.pro`, add exceptions for affected classes:
```pro
-keep class com.bengalbytes.bengalheroes.models.** { *; }
```

---

## Next Steps

1. ✅ **This Guide**: Setup complete ✓
2. → **[GOOGLE_PLAY_UPLOAD_GUIDE.md](GOOGLE_PLAY_UPLOAD_GUIDE.md)**: Upload to Google Play Console
3. → **[TESTING_GUIDELINES.md](TESTING_GUIDELINES.md)**: Pre-release testing
4. → **[PRODUCTION_APP_GUIDELINES.md](PRODUCTION_APP_GUIDELINES.md)**: Post-launch management

---

## Support & Resources

- [Google Play Console Help Center](https://support.google.com/googleplay/android-developer)
- [Flutter Release Build Documentation](https://flutter.dev/docs/deployment/android)
- [Android Application Signing](https://developer.android.com/studio/publish/app-signing)
- [ProGuard & R8 Optimization](https://developer.android.com/studio/build/shrink-code)

---

**Last Updated**: February 2026  
**Maintained By**: Development Team  
**Status**: Production Ready ✅
