# Bengal Heroes - Google Play Store Upload & Console Setup Guide

## Overview
Complete step-by-step guide for uploading Bengal Heroes to Google Play Console, from developer account creation to app publication.

**Current Version**: 1.0.0 (Build 1)  
**App Name**: Bengal Heroes  
**Package ID**: `com.bengalbytes.bengalheroes`  
**Category**: Books & Reference / Educational  

---

## Table of Contents
1. [Google Play Developer Account Setup](#google-play-developer-account-setup)
2. [Create App in Play Console](#create-app-in-play-console)
3. [Prepare Store Listing](#prepare-store-listing)
4. [Upload Application Bundles](#upload-application-bundles)
5. [Content Rating Questionnaire](#content-rating-questionnaire)
6. [Target Audience & Content](#target-audience--content)
7. [Review & Testing](#review--testing)
8. [Submit for Review](#submit-for-review)
9. [Post-Launch Monitoring](#post-launch-monitoring)
10. [Troubleshooting](#troubleshooting)

---

## Google Play Developer Account Setup

### Step 1: Create Google Play Developer Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Sign in with your Google account (or create a new one)
3. Complete your developer profile:
   - Developer name: "Bengal Bytes" or your organization name
   - Email: Development team's email
   - Phone number: Verify with SMS
   - Payment method: Add valid credit/debit card (one-time $25 USD fee)

### Step 2: Accept Google Play Policies

- ✅ Accept Developer Program Policies
- ✅ Accept API Terms of Service
- ✅ Accept Content Policy Guidelines
- ✅ Accept Google Play Developer Distribution Agreement

### Step 3: Add Team Members (Optional)

1. Go to **Settings** → **User and permissions**
2. Click **Invite users**
3. Add team member email addresses
4. Assign appropriate roles:
   - **Admin**: Full access
   - **Developer**: Upload apps, manage versions
   - **Viewer**: Read-only access

---

## Create App in Play Console

### Step 1: Create New Application

1. In Google Play Console, click **Create app**
2. Fill in the following details:

| Field | Value |
|---|---|
| App name | Bengal Heroes |
| Default language | English |
| App or game | App |
| Free or paid | Free |

3. Click **Create app**

### Step 2: Complete App Setup

You'll be taken to the app dashboard. Complete the following sections:

#### Store Listing
- Short description (80 characters)
- Full description (4000 characters)
- Add app screenshots and feature graphics

#### Application Release
- Upload your APK/AAB file
- Set target Android version

#### Content Rating
- Complete questionnaire about app content

#### Pricing & Distribution
- Set as Free
- Select target countries/regions

---

## Prepare Store Listing

### 1. App Title & Short Description

**Title**: `Bengal Heroes` (max 50 characters)

**Short Description** (80 characters):
```
Discover the legends and freedom fighters of Bengal. Learn inspiring stories.
```

### 2. Full Description (4000 characters max)

```
Bengal Heroes - Discover the Untold Stories of Bengal's Greatest Leaders

Bengal Heroes is an interactive educational app that celebrates the remarkable 
lives of freedom fighters, intellectuals, and heroes from Bengal. Explore the 
rich history and contributions of Bengal to India's independence movement and 
cultural renaissance.

FEATURES:
✓ Explore Heroes & Freedom Fighters
  - Discover biographical information about legendary personalities
  - Learn about their contributions to Indian independence
  - Access inspiring quotes and historical facts

✓ Interactive Timeline
  - Navigate through important events in Bengal's history
  - Understand the chronological sequence of historical events
  - Connect heroes to their historical contexts

✓ Eras Exploration
  - Explore different historical periods of Bengal
  - Understand the cultural and political context of each era
  - Learn about the socio-political movements

✓ Multi-Language Support
  - Available in English and Bengali
  - Seamless language switching

✓ Rich Media Content
  - High-quality images of heroes and historical events
  - Detailed information and historical context
  - Museum-quality presentation

✓ Offline Access
  - Access content without active internet connection
  - Data cached locally for better performance

PERFECT FOR:
• Students studying Indian history and independence movement
• History enthusiasts and researchers
• Anyone interested in Bengal's cultural heritage
• Educators teaching Indian freedom struggle

EDUCATIONAL VALUE:
This app serves as a comprehensive educational resource, making history engaging 
and accessible. It encourages exploration and deeper learning about India's 
freedom struggle and Bengal's pivotal role.

DISCLAIMER:
This app is developed for educational purposes. All historical information is 
sourced from academic references and verified historical records.

Download Bengal Heroes today and embark on a journey through Bengal's glorious 
past!

---
Questions or feedback? We'd love to hear from you!
```

### 3. App Screenshots (Required)

Prepare 4-8 screenshots showing:

1. Home/Heroes screen
2. Hero detail view
3. Timeline feature
4. Eras exploration
5. Language options (optional)

**Screenshot Requirements**:
- Format: PNG or JPEG
- Minimum dimensions: 1080 x 1920 px (9:16 aspect ratio)
- Maximum dimensions: 1440 x 2560 px
- Maximum file size: 8 MB each
- 2 to 8 screenshots required

### 4. Feature Graphic

**Dimensions**: 1024 x 500 px  
**Format**: PNG or JPEG  
**Description**: Eye-catching banner for Google Play Store listing

Create an attractive banner featuring:
- App icon
- Key tagline: "Discover Bengal's Heroes"
- Colors from app theme

### 5. App Icon

**Dimensions**: 512 x 512 px (or larger, square format)  
**Format**: PNG with transparency  
**File**: Should be located at `assets/logo/logo_v2.png`

---

## Upload Application Bundles

### Step 1: Prepare Release Build

```powershell
# In project root directory
cd bengal_heroes

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build app bundle (AAB) - Recommended for Play Store
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

# Output file location:
# build\app\outputs\bundle\release\app-release.aab
```

### Step 2: Navigate to Release Section

1. In Google Play Console, click **Testing** → **Internal testing**
2. Or go directly to **Release** → **Production**

### Step 3: Upload App Bundle

1. Click **Create new release**
2. Under "App bundles and APKs", click **Browse files**
3. Select the generated `.aab` file from:
   ```
   bengal_heroes/build/app/outputs/bundle/release/app-release.aab
   ```
4. Wait for the upload to complete (file will be scanned)

### Step 4: Add Release Notes

In the "Release notes" section, add:

```
Version 1.0.0 (Build 1) - Initial Release

LAUNCH HIGHLIGHTS:
✓ Complete hero database with detailed biographies
✓ Interactive timeline of Bengal's history
✓ Multi-era exploration feature
✓ Bilingual support (English & Bengali)
✓ Optimized for all Android devices
✓ Offline content access

Known Limitations:
- Network features require internet connection
- Recommended for Android 5.0 and above

We appreciate your support! Please share any feedback with us.
```

---

## Content Rating Questionnaire

### Step 1: Access Content Rating

1. In Play Console, go to **Setup** → **Content rating**
2. Click **Start Questionnaire**

### Step 2: Fill Questionnaire

**Section 1: Target Age Category**
- Select: **Greater than 3 years**

**Section 2: Content**

| Category | Answer |
|---|---|
| Violence | No |
| Sexual Content | No |
| Language | No (occasional mild language) |
| Gambling | No |
| Alcohol & Tobacco | No |
| Scary/Horror | No |
| Deceptive Behavior | No |
| Financial Transactions | No |
| Location Sharing | No |
| Personal Information | No |

**Section 3: Advertising & Analytics**

- Personal Data Collected: Select "None" or applicable options
- Advertising: "Yes, third-party" (if using ads)
- Analytics: "Yes" (for crash reporting and usage analytics)

### Step 3: Save & Submit

- Click **Save questionnaire**
- System generates content rating (e.g., PEGI 3)

---

## Target Audience & Content

### Step 1: Declare Content Rating

1. Go to **Setup** → **App content**
2. Select rating classification: **PEGI 3** (or as determined)

### Step 2: Target Audience

1. Go to **Setup** → **Target audience**
2. Select appropriate categories:

| Category | Selection |
|---|---|
| Target age | 7 years and up, 12+, 16+ |
| Primary app type | Books & Reference / Educational |
| Secondary app type | Education |

### Step 3: Privacy Policy

1. Go to **Setup** → **App content** → **Safety**
2. Provide Privacy Policy URL:

```
https://www.example.com/privacy-policy
```

Or prepare a privacy policy like:

```markdown
# Privacy Policy - Bengal Heroes App

Effective Date: [Today's Date]

## Data Collection
- This app does not collect personal user data
- No tracking or analytics of user behavior
- No third-party data sharing

## Permissions
- Internet: Only for downloading assets and updates
- Storage: Local caching of app data only

## Contact
If you have privacy concerns, email: privacy@example.com
```

Host this policy on your website or attach in console.

---

## Review & Testing

### Step 1: Pre-Launch Report

Before submitting, Google generates a Pre-launch report:

1. Navigate to **Release** → **Pre-launch report**
2. View automated testing results:
   - Crash test results
   - Performance analysis
   - Security scan
   - Compatibility report

**Expected Results**:
- ✅ No critical crashes
- ✅ Compatible with target Android versions
- ✅ No security vulnerabilities
- ✅ Normal performance metrics

### Step 2: Internal Testing

1. Go to **Testing** → **Internal testing**
2. Click **Create new release**
3. Upload `.aab` file
4. Add team members to internal testing group
5. Share test link with team
6. Test on actual devices:

**Test Cases**:
- [ ] App launches without crashing
- [ ] All screens load properly
- [ ] Navigation works smoothly
- [ ] Images load correctly
- [ ] Search functionality works
- [ ] Filter/sort features work
- [ ] Language switching works (EN/BN)
- [ ] App handles offline content
- [ ] No hardcoded debug info visible
- [ ] Proper error messages displayed
- [ ] Battery usage is reasonable
- [ ] Network connectivity works

### Step 3: Beta Testing (Optional)

For wider testing:

1. Go to **Testing** → **Closed testing**
2. Create a testing group (limit to 100 test users)
3. Share opt-in link with beta testers
4. Run for 1-2 weeks
5. Collect feedback and issues
6. Fix critical issues before production release

---

## Submit for Review

### Step 1: Complete All Requirements

Before submitting, verify:

- [ ] App bundle (.aab) uploaded
- [ ] Store listing fully completed with screenshots
- [ ] Content rating questionnaire completed
- [ ] Privacy policy provided
- [ ] Target audience/content rating set
- [ ] Release notes added
- [ ] Pre-launch report reviewed (no critical issues)
- [ ] App tested on actual devices

### Step 2: Review Compliance

Google Play policies checklist:

- [ ] No prohibited content (violence, hate speech, malware)
- [ ] No misleading descriptions
- [ ] No impersonation or intellectual property infringement
- [ ] Privacy policy is clear and accessible
- [ ] No bypassing Play Store policies
- [ ] Appropriate for declared age rating

### Step 3: Submit for Review

1. Go to **Release** → **Production**
2. Review all details one final time
3. Click **Review release**
4. Click **Start rollout to Production**
5. Select: **Release this version to Production**
6. Confirm submission

**Review Time**: Typically 1-3 hours, sometimes up to 24 hours

### Step 4: Monitor Review Status

1. After submission, check **Release** → **Production**
2. Status will show:
   - 🔄 "Pending review" - Being reviewed by Google
   - ✅ "Approved" - Live on Play Store
   - ❌ "Rejected" - Policy violation (check email for details)

---

## Post-Launch Monitoring

### Immediate Actions (First 24 Hours)

- [ ] Verify app is live on Google Play Store
- [ ] Search for "Bengal Heroes" and confirm listing appears
- [ ] Download and test the released version
- [ ] Monitor Install rate (usually slow initially)
- [ ] Check crash reports in **Analytics** → **Stability**
- [ ] Monitor user ratings (initial ratings critical)

### First Week

- [ ] Monitor crash rates (target: < 1%)
- [ ] Review user feedback and ratings
- [ ] Monitor install/uninstall ratio
- [ ] Check performance metrics
- [ ] Address critical bugs immediately (hotfix release)
- [ ] Engage with users in reviews section

### Ongoing Monitoring

See [PRODUCTION_APP_GUIDELINES.md](PRODUCTION_APP_GUIDELINES.md) for detailed post-launch procedures.

---

## Troubleshooting

### Issue 1: App Bundle Upload Fails

**Error**: "Error processing app bundle"

**Solution**:
```powershell
# Rebuild the app bundle
flutter clean
flutter pub get
flutter build appbundle --release

# Verify the .aab file exists
Test-Path "bengal_heroes\build\app\outputs\bundle\release\app-release.aab"
```

Wait 5 minutes before retrying upload.

### Issue 2: Pre-Launch Report Shows Crashes

**Error**: Crash detected in pre-launch testing

**Solution**:
1. Review crash details in Pre-launch report
2. Fix the crash in code
3. Rebuild and re-upload
4. Re-run pre-launch tests

### Issue 3: Rejected for Policy Violation

**Error**: App rejected for policy violation

**Solution**:
1. Check rejection email for specific reason
2. Review the policy violation link provided
3. Make necessary changes to code/content
4. Update Version and rebuild
5. Resubmit after addressing all concerns

### Issue 4: Graphics/Screenshots Not Uploading

**Error**: "Invalid image format"

**Solution**:
- Convert to PNG or JPEG format
- Verify dimensions: 1080 x 1920 px minimum
- Ensure file size < 8 MB
- Avoid animated format (GIF)
- Re-upload

### Issue 5: Low Install Rate After Launch

**Issue**: App not showing in search results

**Solution**:
- Verify app keywords in store listing
- Update app description with relevant keywords
- Verify app icon and screenshots are professional
- Request reviews from initial users
- Monitor for critical bugs
- Run marketing/promotion campaign

---

## Useful Links

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Bundle Documentation](https://developer.android.com/guide/app-bundle)
- [Store Listing Best Practices](https://support.google.com/googleplay/android-developer/answer/4448379)
- [Google Play Policy Center](https://play.google.com/about/developer-content-policy/)
- [Pre-launch Report Guide](https://support.google.com/googleplay/android-developer/answer/9019589)

---

## Checklist for Go-Live

### 24 Hours Before Release

- [ ] Final code review completed
- [ ] All dependencies updated
- [ ] Versioning finalized
- [ ] Release notes prepared
- [ ] Screenshots and graphics ready
- [ ] Privacy policy prepared
- [ ] Tested on 2-3 physical devices

### Day of Release

- [ ] Build final APK/AAB
- [ ] Upload to Play Console
- [ ] Complete store listing
- [ ] Submit content rating
- [ ] Run pre-launch tests
- [ ] Submit for review
- [ ] Monitor status every 30 minutes

### After Approval

- [ ] Announce on social media / website
- [ ] Monitor crash reports
- [ ] Respond to early reviews
- [ ] Watch installation metrics
- [ ] Be ready to issue hotfix if needed

---

**Next Step**: Read [TESTING_GUIDELINES.md](TESTING_GUIDELINES.md) for comprehensive testing procedures.

---

**Last Updated**: February 2026  
**Maintained By**: Development Team  
**Status**: Production Ready ✅
