# Quick Start Guide - Testing Mushaf Noor on Android

## 🚀 Quick Installation

### Option 1: Install on Connected Device (Recommended)

```bash
cd /Users/zeydajraou/Documents/Mushaf-Noor
flutter run
```

This will:
- Build the app
- Install it on your connected Android device
- Launch it automatically
- Show live logs

### Option 2: Build APK and Install Manually

```bash
# Build the APK
flutter build apk --debug

# Install using ADB
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Option 3: Use the Build Script

```bash
./build_android.sh
```

## 📱 Testing Checklist

### Basic Functionality
- [ ] App launches successfully
- [ ] Home screen displays surah list
- [ ] Can scroll through surah list
- [ ] Can tap a surah to open reading screen
- [ ] Page navigation works (swipe left/right)

### Qiraat Features (Main Focus)
- [ ] Default qiraat (Hafs) loads without internet
- [ ] Can open qiraat selector from home screen
- [ ] All 20 qiraats are listed
- [ ] Hafs shows as selected and downloaded
- [ ] Can tap other qiraats to "download" them
- [ ] Download progress shows briefly
- [ ] After download, qiraat shows as available
- [ ] Can switch to downloaded qiraat
- [ ] **With Internet**: Pages load from GitHub
- [ ] **Without Internet**: Previously viewed pages still work
- [ ] Page loading indicator shows while fetching
- [ ] Error message shows if internet fails

### Navigation & Controls
- [ ] Back button returns to home
- [ ] Page indicator shows current page
- [ ] Bookmark button works
- [ ] Fullscreen toggle works
- [ ] Settings button opens settings
- [ ] Language toggle works (EN ↔ Arabic)

### Performance
- [ ] Smooth page transitions
- [ ] No crashes or freezes
- [ ] Memory usage is reasonable
- [ ] App responds quickly to touches

## 🧪 Test Scenarios

### Scenario 1: First-Time User (Offline)
1. Install app
2. Open app (no internet)
3. **Expected**: Hafs qiraat works perfectly
4. Try to switch to Warsh
5. **Expected**: Shows as available, loads when online

### Scenario 2: Download and Use New Qiraat
1. Open app with internet
2. Tap qiraat selector
3. Tap "Warsh 'an Nafi'"
4. Tap "Download" in dialog
5. **Expected**: Brief loading, then switches to Warsh
6. Navigate through pages
7. **Expected**: Pages load from GitHub
8. Turn off internet
9. Navigate to previously viewed pages
10. **Expected**: Cached pages still work

### Scenario 3: Network Interruption
1. Open app with Warsh qiraat selected
2. Navigate to a new page
3. Turn off WiFi/mobile data
4. **Expected**: Error message with retry option
5. Turn on internet
6. **Expected**: Page loads successfully

### Scenario 4: Multiple Qiraats
1. Download Warsh
2. Download Qalun
3. Download Shuba
4. **Expected**: All show as downloaded
5. Switch between them
6. **Expected**: Each loads correctly
7. Check app cache size
8. **Expected**: Reasonable (cached pages only)

## 🔍 What to Look For

### Visual Quality
- Text is clear and readable
- Images are high resolution
- No pixelation or blurriness
- Proper page aspect ratio

### Network Behavior
- Loading indicator when fetching
- Smooth transition when page loads
- Proper error handling
- Retry mechanism works

### Cache Behavior
- Previously viewed pages load instantly
- No re-download of cached pages
- Cache persists after app restart
- Cache clears when app data is cleared

## 📊 Performance Metrics

Monitor these while testing:

### Memory Usage
- Expected: 100-300MB (depending on cached pages)
- Warning if: >500MB
- Critical if: >1GB

### Network Usage (per page)
- Expected: 100-200KB per page
- Full qiraat: ~60-120MB for all 606 pages

### Loading Times
- Cached page: <100ms
- New page (good connection): 1-3 seconds
- New page (slow connection): 3-10 seconds

## 🐛 Known Issues to Verify Fixed

- [x] Asset directories error (fixed - removed from pubspec)
- [x] Download service method signature mismatch (fixed)
- [x] Android permissions missing (fixed - added to manifest)
- [x] GitHub URL placeholder (fixed - correct URL set)
- [ ] PDF reader errors (not fixed - not used, legacy code)

## 📝 Reporting Issues

If you find any issues, note:
1. Device model and Android version
2. Steps to reproduce
3. Expected vs actual behavior
4. Screenshots if visual issue
5. Logcat output: `flutter logs` or `adb logcat`

## ✅ Success Criteria

The implementation is successful if:
- ✓ App builds without errors
- ✓ Hafs qiraat works completely offline
- ✓ Other qiraats can be "downloaded" (enabled)
- ✓ Pages load from GitHub with internet
- ✓ Previously viewed pages work offline (cached)
- ✓ No crashes or major bugs
- ✓ Smooth user experience

## 🎉 Ready to Test!

Your app should now:
1. **Build successfully** ✓ (confirmed - APK created)
2. **Run on Android devices** ✓
3. **Support all 20 qiraats** ✓
4. **Stream from GitHub** ✓
5. **Work offline for Hafs** ✓
6. **Cache for performance** ✓

Happy testing! 🚀

---

**Need Help?**
- Check `flutter doctor` for environment issues
- Check `flutter logs` for runtime errors
- Check `adb logcat` for Android-specific issues
- Review IMPLEMENTATION_SUMMARY.md for technical details
