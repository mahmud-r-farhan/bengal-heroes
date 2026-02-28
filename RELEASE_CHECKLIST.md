# Bengal Heroes - Release Checklist v1.0

Complete checklist for production release to Google Play Store.

## 📋 Code Quality (Due: -3 days)

### Testing
- [ ] Run `flutter test` - all passing
- [ ] Run `flutter analyze` - no errors/warnings
- [ ] Test on Android 6.0 (minimum support)
- [ ] Test on Android 14+ (latest)
- [ ] Test on physical device (not just emulator)
- [ ] Test on low-end device (2GB RAM)
- [ ] Test UI responsiveness
- [ ] Test with poor network connection
- [ ] Test offline functionality

### Code Review
- [ ] No debug prints in code
- [ ] No hardcoded API keys
- [ ] No commented-out code blocks
- [ ] Appropriate error handling
- [ ] No performance issues
- [ ] Proper null safety
- [ ] Consistent code style

### Documentation
- [ ] Update CHANGELOG.md
- [ ] Update README.md
- [ ] Update Privacy Policy
- [ ] Update Terms of Service (if applicable)

## 📦 Build & Versioning (Due: -2 days)

### Version Management
- [ ] Update version in `pubspec.yaml`
  - Format: `x.y.z+buildNumber`
  - Example: `1.0.0+1`
- [ ] Increment build number
- [ ] Verify `versionCode` in pubspec
- [ ] Verify `versionName` in pubspec

### Test Builds
- [ ] Build APK: `flutter build apk --release`
- [ ] Size: Expected 40-60 MB
- [ ] Test APK on devices
- [ ] Verify no shrinking issues
- [ ] Verify signing works

### Release Build
- [ ] Build AAB: `flutter build appbundle --release`
- [ ] Size: Expected 25-35 MB
- [ ] Verify AAB integrity
- [ ] Keep copy for records

## 🎨 App Store Listing (Due: -2 days)

### Visual Assets
- [ ] App icon: 512x512 px PNG
- [ ] Feature graphic: 1024x500 px PNG
- [ ] Minimum 2 screenshots
- [ ] Maximum 8 screenshots
- [ ] Screenshots: 1080x1920 px minimum
- [ ] All images in high quality
- [ ] Tested for accessibility

### Store Copy
- [ ] App name finalized
- [ ] Subtitle written (optional)
- [ ] Short description written
- [ ] Full description written
- [ ] Content rating completed
- [ ] Privacy policy provided
- [ ] Support email listed

### App Descriptions

**Short Description**:
> Discover legendary bengal heroes with interactive timeline and location-based exploration.

**Full Description**:
> Bengal Heroes brings the rich history and culture of Bengal to life.
> 
> Explore 100+ detailed profiles of legendary figures, trace historical events through an interactive timeline, and discover locations significant to Bengal's heritage.
> 
> Features:
> ✨ Comprehensive hero database
> 📅 Interactive timeline
> 🗺️ Location-based events
> 🌍 Multi-language (English & Bengali)
> 
> Perfect for students, history enthusiasts, and cultural explorers.

## 🔐 Security & Credentials (Due: -1 day)

### Keystore Configuration
- [ ] Production keystore generated
- [ ] Keystore backed up securely
- [ ] Keystore password documented (encrypted)
- [ ] Key alias documented
- [ ] Key password documented (encrypted)
- [ ] Keystore not in version control
- [ ] Environment variables tested

### Google Play Console
- [ ] Google Account created
- [ ] Developer account registered ($25 USD)
- [ ] Payment method added
- [ ] App created in Play Console
- [ ] Application ID matches package name
- [ ] Internal testing track created

### Credentials Security
- [ ] Credentials stored securely
- [ ] No hardcoded secrets
- [ ] .env file in .gitignore
- [ ] Keystore file backed up
- [ ] Backup location documented
- [ ] Recovery procedure documented

## 🧪 Pre-Release Testing (Due: Release Day)

### Functional Testing
- [ ] App launches without crash
- [ ] All screens load properly
- [ ] All buttons functional
- [ ] Navigation works smoothly
- [ ] Animations are smooth (60 FPS)
- [ ] No visual glitches
- [ ] Text readable at all sizes
- [ ] Languages switch correctly
- [ ] Deep linking works (if implemented)

### Performance Testing
- [ ] Cold start < 3 seconds
- [ ] No memory leaks
- [ ] Frame drops minimal
- [ ] Battery impact reasonable
- [ ] Network requests timeout properly
- [ ] Large data loads efficiently

### Edge Cases
- [ ] Works offline
- [ ] Works with slow network
- [ ] Handles missing permissions gracefully
- [ ] Handles permission denials
- [ ] Works with low disk space
- [ ] Works with low memory

### Device Testing
- [ ] Samsung device (Android 8+)
- [ ] Pixel device (Android 11+)
- [ ] Generic device emulator
- [ ] Low-end device (2GB RAM)
- [ ] High-end device (8GB+ RAM)
- [ ] Tablet (if applicable)
- [ ] Different screen sizes

## 📤 Google Play Console Setup (Due: Release Day)

### App Store Listing
- [ ] All translations complete (if multi-language)
- [ ] Store listing finalized
- [ ] Graphics uploaded
- [ ] Screenshots uploaded
- [ ] App preview videos uploaded (optional)
- [ ] Content rating submitted
- [ ] Confirm age rating: 4+ or 7+
- [ ] Content guidelines accepted

### Release Configuration
- [ ] Release track selected (Production recommended)
- [ ] AAB file uploaded
- [ ] Release name set (e.g., "1.0.0")
- [ ] Release notes written
- [ ] Version code verified
- [ ] Rollout percentage set (recommend 1% staged rollout)
- [ ] Release notes review complete

### Permissions & Policies
- [ ] Privacy policy URL provided
- [ ] Target audience age verified
- [ ] Content rating acceptable
- [ ] Google Play policies reviewed
- [ ] Content policy compliance verified
- [ ] No prohibited content

## 🚀 Release & Rollout (Release Day/Day 1)

### Pre-Launch
- [ ] Final testing complete
- [ ] All checks passing
- [ ] Release notes finalized
- [ ] Support contact ready
- [ ] Team notified of release
- [ ] Backup of keystore verified

### Release
- [ ] Review release details one final time
- [ ] Confirm AAB file correct
- [ ] Confirm version code incremented
- [ ] Submit release
- [ ] Email confirmation received
- [ ] Play Console shows pending

### Monitor Rollout (Day 1-2)
- [ ] App appears in Play Store
- [ ] Install count increases
- [ ] Check for crash reports
- [ ] Monitor ratings
- [ ] Read user reviews
- [ ] Check crash analytics
- [ ] Observe performance metrics

## 📊 Post-Release Monitoring (Days 1-7)

### Metrics to Monitor
- [ ] Install rate (should increase steadily)
- [ ] Crash/ANR rate (should be < 0.5%)
- [ ] App rating (target 4+)
- [ ] Active users (gauge engagement)
- [ ] Session retention (track daily retention)
- [ ] Session length (check engagement)

### Issue Response
- [ ] Critical crash > Immediate hotfix
- [ ] Minor bug > Include in next release
- [ ] UI issue > Monitor for patterns
- [ ] Performance issue > Investigate

### Staged Rollout Progression (If Applicable)
- **Day 1-2**: 1% rollout, heavy monitoring
- **Day 2-3**: If stable, increase to 5%
- **Day 3-5**: If stable, increase to 10%
- **Day 5-7**: If stable, complete rollout to 100%

## 📋 Rollout Milestones

### Phase 1: Staged 1% (24-48 hours)
- [ ] Release in production with 1% rollout
- [ ] Monitor crashes closely
- [ ] Check device compatibility errors
- [ ] A/B test alternate UI if applicable
- [ ] Decision: Increase or pause rollout

### Phase 2: Staged 5% (24-48 hours)
- [ ] Expand to 5% of user base
- [ ] Continue crash monitoring
- [ ] Collect user feedback
- [ ] Monitor performance metrics
- [ ] Decision: Increase, pause, or rollback

### Phase 3: Staged 10% (1-2 days)
- [ ] Expand to 10%
- [ ] Final verification
- [ ] Prepare for full rollout
- [ ] Document any issues found

### Phase 4: Full Release (100%)
- [ ] Expand to all users
- [ ] Complete rollout
- [ ] Archive release notes
- [ ] Begin work on next release

## 📝 Documentation

### Required Documents
- [ ] Release notes prepared
- [ ] Update guide prepared (if applicable)
- [ ] Known issues documented
- [ ] Roadmap for next version created
- [ ] Archive previous version info

### Communications
- [ ] Team notified of release
- [ ] User base notified (email/app update note)
- [ ] Social media updated (if applicable)
- [ ] Blog post published (if applicable)

## 🔄 Post-Release (Days 8+)

### Analysis
- [ ] Full analytics review completed
- [ ] User feedback compiled
- [ ] Bug reports prioritized
- [ ] Feature requests cataloged
- [ ] Performance analysis done

### Planning
- [ ] Next release planned
- [ ] Version 1.0.1 (patch) tasks identified
- [ ] Version 1.1.0 (minor) features listed
- [ ] Version 2.0.0 (major) vision created

## ⚠️ Rollback Plan (If Issues Occur)

In case of critical issues:

1. **Identify Issue**
   - Check crash logs
   - Verify reproducibility
   - Assess impact

2. **Rollback Decision**
   - Pause rollout if < 100%
   - Halt release if critical
   - Never rollback major data changes

3. **Immediate Action**
   - Notify affected users
   - Prepare hotfix
   - Test thoroughly
   - Re-release quickly

4. **Post-Mortem**
   - Document root cause
   - Improve QA process
   - Add regression tests
   - Update release checklist

## 📞 Support Contacts

- **Lead Developer**: [Your Name]
- **QA Contact**: [Team Member]
- **Support Email**: bengalheroes@bengalbytes.com
- **Issue Tracking**: GitHub Issues
- **Analytics Dashboard**: Firebase Console

---

## Final Sign-Off

- [ ] All checklist items completed
- [ ] Lead developer: Approved by _______________ Date: ________
- [ ] QA team: Approved by _______________ Date: ________
- [ ] Manager: Approved by _______________ Date: ________

**Ready for Release:** ✅ YES / ❌ NO

---

**Document Version**: 1.0  
**Last Updated**: February 2026  
**Next Review**: [After first release]
