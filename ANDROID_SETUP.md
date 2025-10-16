# Android Setup Guide for Mushaf Noor

## Prerequisites
Before building for Android, you need to set up the Android development environment.

### 1. Install Android Studio
1. Download Android Studio from: https://developer.android.com/studio
2. Run the installer and follow the setup wizard
3. Make sure to install:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)

### 2. Configure Flutter for Android
After installing Android Studio:

```bash
# Accept Android licenses
flutter doctor --android-licenses

# Verify setup
flutter doctor
```

You should see a green checkmark (✓) for "Android toolchain - develop for Android devices"

### 3. Prepare Your Android Device
1. Enable Developer Options on your Android phone:
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Developer Options will now appear in Settings

2. Enable USB Debugging:
   - Go to Settings > Developer Options
   - Enable "USB Debugging"

3. Connect your phone to your computer via USB

### 4. Build and Install the App

#### Option A: Direct Installation (Recommended)
```bash
# Navigate to project directory
cd /Users/zeydajraou/Documents/Mushaf-Noor

# Check connected devices
flutter devices

# Install directly to your device
flutter run
```

#### Option B: Build APK and Install Manually
```bash
# Use our build script
./build_android.sh

# Or manually:
flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Troubleshooting

### If you get "device not found":
- Make sure USB Debugging is enabled
- Try a different USB cable
- On your phone, allow USB debugging when prompted

### If build fails:
- Run `flutter clean` then `flutter pub get`
- Make sure you accepted all Android licenses
- Check `flutter doctor` for any issues

### If the app crashes on startup:
- Check the Android logs: `flutter logs`
- Ensure your phone is running Android 5.0 (API 21) or higher

## What We've Optimized for Android

✅ Added internet permission for downloading qiraats  
✅ Added network state permission  
✅ Added storage permission for saving downloads  
✅ Configured minimum SDK version to 21 (Android 5.0)  
✅ Enabled multidex for larger app size  
✅ Added proguard rules for release builds  
✅ Optimized asset loading for Android  

The app should work perfectly on your Android device once you complete the setup!