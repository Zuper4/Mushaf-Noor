# Development Setup Guide

## Getting Started with Mushaf Noor

This guide will help you set up the development environment for the Mushaf Noor Flutter application.

## Prerequisites

### Required Software
- **Flutter SDK** (3.10.0 or higher)
- **Dart SDK** (3.0.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### Platform-Specific Requirements

#### For Android Development
- Android Studio with Android SDK
- Android device or emulator (API level 21+)

#### For iOS Development (macOS only)
- Xcode 14.0 or higher
- iOS Simulator or physical iOS device
- Apple Developer account (for device deployment)

## Installation Steps

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd mushaf-noor
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Verify Flutter Installation
```bash
flutter doctor
```
Ensure all requirements are met before proceeding.

### 4. Set up Assets

#### Arabic Fonts
Download and add the following fonts to `assets/fonts/`:
- **Uthmanic Hafs font** (`UthmanicHafs.ttf`)
- **Amiri font** (`Amiri-Regular.ttf`, `Amiri-Bold.ttf`)

You can download these fonts from:
- Uthmanic: [King Fahd Glorious Qur'an Printing Complex](https://fonts.qurancomplex.gov.sa/)
- Amiri: [Amiripas Type](https://github.com/amiripas/amiri-font)

#### Default Images
Add placeholder images to `assets/images/` for development:
- App icon placeholders
- Loading screens
- Background patterns

### 5. Configure Development Settings

#### Update Server URLs
In `lib/services/download_service.dart`, update the server URLs:
```dart
String _getPageUrl(String qiraatId, int pageNumber) {
  return 'https://your-server.com/qiraats/$qiraatId/pages/${pageNumber.toString().padLeft(3, '0')}.jpg';
}
```

#### Database Configuration
The app will automatically create the SQLite database on first run. No additional setup needed.

### 6. Run the Application
```bash
# For debug mode
flutter run

# For specific device
flutter run -d <device-id>

# For release mode
flutter run --release
```

## Development Workflow

### Project Structure Understanding
```
lib/
├── main.dart                    # App entry point
├── models/                      # Data structures
├── providers/                   # State management (Provider pattern)
├── services/                    # Business logic and API calls
├── screens/                     # UI screens and pages
├── widgets/                     # Reusable UI components
└── utils/                       # Helper functions and constants
```

### State Management
The app uses the **Provider** pattern for state management:
- `AppState`: General app settings and navigation
- `QiraatProvider`: Qiraat selection and management
- `DownloadProvider`: Download progress and management

### Key Features to Understand

#### 1. Qiraat Management
- Each Qiraat has downloadable content
- Color coding shows differences from Hafs
- Progressive download with pause/resume

#### 2. Page Rendering
- Pages are stored as images
- InteractiveViewer for zoom/pan
- Placeholder content for undownloaded pages

#### 3. Offline Support
- SQLite for metadata storage
- File system for page images
- Graceful offline/online transitions

## Development Guidelines

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable names
- Add documentation for public APIs
- Maintain RTL text direction support

### Arabic Text Handling
- Always use `fontFamily: 'Amiri'` for Arabic text
- Implement proper RTL text direction
- Test with different font sizes
- Ensure proper text alignment

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run specific test file
flutter test test/widget_test.dart
```

### Building for Release

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## Common Development Tasks

### Adding a New Qiraat
1. Update the default qiraats list in `qiraat_provider.dart`
2. Ensure server has the corresponding page images
3. Add color code for difference highlighting
4. Test download and selection functionality

### Modifying UI Themes
1. Edit `lib/utils/theme.dart`
2. Update both light and dark themes
3. Test with different screen sizes
4. Verify Arabic text rendering

### Adding New Settings
1. Add property to `AppState` provider
2. Create UI controls in `SettingsScreen`
3. Implement persistence in `DatabaseService`
4. Test setting persistence across app restarts

## Troubleshooting

### Common Issues

#### Font Not Loading
- Verify font files are in `assets/fonts/`
- Check `pubspec.yaml` font declarations
- Restart the app after adding fonts

#### Database Errors
- Clear app data to reset database
- Check SQL syntax in `database_service.dart`
- Verify database version increments

#### Download Issues
- Check internet connectivity
- Verify server URLs are accessible
- Test with smaller download chunks

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Debug Tools
- Use Flutter Inspector for UI debugging
- Enable verbose logging in providers
- Use breakpoints in VS Code/Android Studio
- Monitor memory usage with DevTools

## Contributing

### Before Making Changes
1. Create a new branch from `main`
2. Run existing tests to ensure they pass
3. Follow the coding guidelines
4. Add tests for new functionality

### Submitting Changes
1. Write clear commit messages
2. Update documentation if needed
3. Test on both Android and iOS (if available)
4. Submit a pull request with description

## Resources

### Flutter Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)

### Islamic Resources
- [Tanzil Quran Text](https://tanzil.net/)
- [Quranic Arabic Resources](https://corpus.quran.com/)
- [Islamic Typography](https://github.com/topics/islamic-typography)

### Design References
- [Material Design 3](https://m3.material.io/)
- [Arabic UI Design Patterns](https://arabicuidesign.com/)
- [RTL Design Guidelines](https://material.io/design/usability/bidirectionality.html)

## Getting Help

If you encounter issues:
1. Check this documentation first
2. Search existing GitHub issues
3. Create a new issue with detailed description
4. Include Flutter doctor output and error logs
5. Specify device/platform information

---

Happy coding! 🚀 May your contributions benefit the Muslim community worldwide.