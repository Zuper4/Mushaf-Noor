#!/bin/bash

echo "🚀 Building Mushaf Noor for Android..."
echo

# Check if Android SDK is available
if ! flutter doctor | grep -q "Android toolchain.*✓"; then
    echo "❌ Android toolchain not found!"
    echo "Please install Android Studio first:"
    echo "1. Download from: https://developer.android.com/studio"
    echo "2. Install and follow the setup wizard"
    echo "3. Run 'flutter doctor --android-licenses' to accept licenses"
    echo "4. Then run this script again"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Check for connected devices
echo "📱 Checking for connected devices..."
flutter devices

# Build debug APK
echo "🔨 Building debug APK..."
flutter build apk --debug

if [ $? -eq 0 ]; then
    echo
    echo "✅ Build successful!"
    echo "📍 APK location: build/app/outputs/flutter-apk/app-debug.apk"
    echo
    echo "To install on your device:"
    echo "1. Enable Developer Options and USB Debugging on your phone"
    echo "2. Connect your phone via USB"
    echo "3. Run: flutter install"
    echo "   Or: adb install build/app/outputs/flutter-apk/app-debug.apk"
else
    echo "❌ Build failed. Check the errors above."
    exit 1
fi