# Bengal Heroes - Release Quick Reference Card

One-page reference for quick access to release procedures.

## 🚀 Launch Release in 5 Steps

### Step 1: Setup Credentials (5 min)

```powershell
$env:KEYSTORE_PATH = "C:\Users\[USER]\.android\bengal_heroes_release.jks"
$env:KEYSTORE_PASSWORD = "[PASSWORD]"
$env:KEY_ALIAS = "bengal_heroes_key"
$env:KEY_PASSWORD = "[PASSWORD]"
```

### Step 2: Prepare Code (10 min)

```powershell
cd bengal_heroes
flutter clean
flutter pub get
flutter test
flutter analyze
```

### Step 3: Build Release (10 min)

```powershell
# APK (optional)
flutter build apk --release

# AAB (required for Play Store)
flutter build appbundle --release
```

### Step 4: Upload to Google Play (5 min)

1. Go to https://play.google.com/console
2. Select app → Releases → Create new release
3. Upload `build/app/outputs/bundle/release/app-release.aab`
4. Set to **1% staged rollout**
5. Click "Start rollout"

### Step 5: Monitor (Daily)

- Check crash rate (target: < 0.5%)
- Read user reviews
- Increase rollout when stable:
  - Day 2: 5% → Day 4: 10% → Day 7: 100%

---

## 📋 Essential Checklists

### Pre-Release (Day Before)

- [ ] Version bumped: `pubspec.yaml`
- [ ] CHANGELOG updated
- [ ] All tests passing: `flutter test`
- [ ] APK tested on device
- [ ] Credentials verified
- [ ] Privacy policy ready
- [ ] Screenshots prepared

### During Release

- [ ] AAB built successfully
- [ ] Play Console app created
- [ ] AAB uploaded
- [ ] Release notes added
- [ ] Rollout set to 1%
- [ ] Release approved

### Post-Release (Daily x 7)

- [ ] Crash rate < 0.5%
- [ ] No critical bugs reported
- [ ] User reviews read
- [ ] Metrics monitored
- [ ] Increase rollout on Day 2, 4, 7

---

## 📊 Version Format

```
version: MAJOR.MINOR.PATCH+BUILD_NUMBER

Examples:
1.0.0+1   (Initial release)
1.0.1+2   (Bug fix)
1.1.0+3   (New feature)
2.0.0+4   (Major update)
```

---

## 🔍 Build Output Paths

| Build Type | Path | Size |
|-----------|------|------|
| APK | `build/app/outputs/apk/release/app-release.apk` | 40-60 MB |
| AAB | `build/app/outputs/bundle/release/app-release.aab` | 25-35 MB |

---

## 🐛 Common Errors & Fixes

| Error | Solution |
|-------|----------|
| "Keystore not found" | Verify `KEYSTORE_PATH` environment variable |
| "Wrong password" | Check `KEYSTORE_PASSWORD` contains no special chars (or escape properly) |
| "Version code must increment" | Increase build number in `pubspec.yaml` |
| "KeyAlias not found" | Use correct alias: `bengal_heroes_key` (case-sensitive) |
| "Build failed" | Run `flutter clean` then try again |

---

## 📞 Key Resources

**Documentation**:
- [Google Play Release Guide](GOOGLE_PLAY_RELEASE_GUIDE.md) - Complete walkthrough
- [Production Optimization](PRODUCTION_BUILD_OPTIMIZATION.md) - Build settings
- [Secure Credentials](SECURE_CREDENTIALS_GUIDE.md) - Keystore management
- [Release Checklist](RELEASE_CHECKLIST.md) - Detailed checklist
- [Complete Workflow](COMPLETE_RELEASE_WORKFLOW.md) - Full timeline

**External**:
- Google Play Console: https://play.google.com/console
- Flutter Docs: https://flutter.dev/docs
- Android Docs: https://developer.android.com

---

## ⚡ Pro Tips

1. **Use 1% Staged Rollout** for first releases (safer)
2. **Set Build Number + 1** each release (required by Play Store)
3. **Keep Keystore Backup** (encrypted, offline)
4. **Monitor First 24 Hours** closely
5. **Respond to Reviews** quickly (builds credibility)
6. **Update CHANGELOG** before every release
7. **Test on Real Device** before submitting
8. **Set Release Notes** (helps users understand changes)

---

## 🔐 Security Reminders

❌ **Never**:
- Commit `.env*` files
- Share keystore file
- Use debug keystore for release
- Store passwords in code
- Log sensitive data

✅ **Always**:
- Use environment variables
- Backup keystore encrypted
- Rotate passwords annually
- Use strong passwords (12+ chars)
- Review code before submission

---

## 🎯 Release Timeline

```
Day -7 to -3: Preparation & QA
Day -1 to 0:  Build & Testing
Day 1:        1% Rollout (Heavy monitoring)
Day 2:        5% Rollout (if stable)
Day 4:        10% Rollout
Day 7:        100% Full Release
Day 8:        Post-release analysis
```

---

## 📈 Success Targets

**3 Months After Release**:
- Installs: 1,000+
- Rating: 4.2+ stars
- Retention: 30%+ (Day 7)
- Crash Rate: < 0.1%
- Reviews: 50+

---

## 🚨 Emergency Procedures

**Critical Crash Detected**:
1. Pause rollout immediately (don't expand)
2. Investigate crash logs
3. Push hotfix
4. Build new AAB with incremented version
5. Create new release with hotfix AAB
6. Resume rollout

**Compromised Credentials**:
1. Stop all builds immediately
2. Generate new keystore
3. Update Google Play signing key
4. Update environment variables
5. Resume operations with new keystore

---

## 📑 File Checklist

Ensure these files exist and are updated:

```
√ pubspec.yaml          (version updated)
√ CHANGELOG.md          (release notes)
√ README.md             (installation instructions)
√ privacy_policy.md     (for app store)
√ assets_for_store/     (screenshots, icons)
√ .gitignore            (.env*, *.jks)
√ android/app/proguard-rules.pro (code shrinking)
```

---

**For detailed help on any step, see full documentation files listed above.**

*Last Updated: February 2026*
