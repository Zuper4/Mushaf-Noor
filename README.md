# مصحف نور (Mushaf Noor)

A beautiful Quran reading app built with Flutter that supports multiple Qiraats (recitation styles) with downloadable content and smooth reading experience.

## 🌟 Features

### Core Functionality
- **Complete Qiraats Support**: All 20 traditional recitations (10 Qaris × 2 Rawis each)
- **Downloadable Content**: Download specific Qiraats on-demand to save storage space
- **Smooth Page Navigation**: Intuitive page-by-page reading with swipe gestures
- **High-Quality Pages**: PDF-based page rendering for crisp text display
- **Offline Reading**: Read downloaded content without internet connection

### Reading Experience
- **Customizable Text Size**: Adjust font size for comfortable reading
- **Multiple Font Support**: Choose between Uthmanic and Amiri fonts
- **Dark Mode**: Eye-friendly dark mode for low-light reading
- **Full-Screen Mode**: Distraction-free reading experience
- **Bookmark System**: Save and manage your reading positions
- **Reading History**: Track recently viewed pages

### Qiraat Management
- **Color-Coded Differences**: Visual indicators for variations from Hafs
- **Progressive Download**: Download pages with progress tracking
- **Storage Management**: Monitor and manage downloaded content
- **Pause/Resume Downloads**: Control download process as needed

### User Interface
- **Arabic-First Design**: RTL support with Arabic typography
- **Responsive Layout**: Optimized for different screen sizes
- **Smooth Animations**: Fluid transitions and interactions
- **Intuitive Navigation**: Easy-to-use interface for all users

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── qiraat.dart          # Qiraat model
│   ├── mushaf_page.dart     # Page model
│   └── surah.dart           # Surah model
├── providers/                # State management
│   ├── app_state.dart       # App-wide state
│   ├── qiraat_provider.dart # Qiraat management
│   └── download_provider.dart# Download management
├── services/                 # Business logic
│   ├── database_service.dart # SQLite operations
│   └── download_service.dart # File download/management
├── screens/                  # UI screens
│   ├── home_screen.dart     # Main dashboard
│   ├── reading_screen.dart  # Reading interface
│   ├── qiraat_selection_screen.dart # Qiraat management
│   └── settings_screen.dart # App settings
├── widgets/                  # Reusable components
│   ├── qiraat_card.dart     # Qiraat display card
│   ├── page_viewer.dart     # Page reading widget
│   ├── reading_controls.dart # Reading controls
│   └── page_indicator.dart  # Page position indicator
└── utils/                    # Utilities
    └── theme.dart           # App theming
```

### State Management
- **Provider Pattern**: Clean and efficient state management
- **Separation of Concerns**: Distinct providers for different features
- **Reactive UI**: Automatic updates based on state changes

### Data Storage
- **SQLite Database**: Local storage for metadata and preferences
- **File System**: Efficient storage of downloaded Qiraat pages
- **Caching Strategy**: Smart caching for optimal performance

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mushaf-noor
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Setup for Development

1. **Add Arabic Fonts**
   - Download Uthmanic Hafs font and place in `assets/fonts/`
   - Download Amiri font and place in `assets/fonts/`

2. **Configure Server URLs**
   - Update `download_service.dart` with your actual server URLs
   - Implement your backend API for Qiraat pages

3. **Database Setup**
   - The app will automatically create the SQLite database
   - Add your Surah metadata to `database_service.dart`

## 📱 Usage

### Basic Reading
1. Launch the app
2. Select "Continue Reading" to start from your last position
3. Swipe left/right to navigate between pages
4. Tap the screen to show/hide controls

### Managing Qiraats
1. Go to "القراءات" (Qiraats) from the home screen
2. Browse available Qiraats
3. Tap "تنزيل" (Download) to download a specific Qiraat
4. Select a downloaded Qiraat to switch to it

### Customization
1. Access settings from the home screen or reading controls
2. Adjust font size, font type, and display preferences
3. Toggle dark mode for comfortable reading
4. Manage bookmarks and reading history

## 🎨 Design Philosophy

### Arabic-First Approach
- Right-to-left (RTL) text flow
- Arabic typography and calligraphy
- Cultural sensitivity in UI/UX design

### Accessibility
- High contrast color schemes
- Scalable font sizes
- Touch-friendly interface elements
- Screen reader compatibility

### Performance
- Lazy loading of pages
- Efficient memory management
- Optimized image rendering
- Smooth 60fps animations

## 🔧 Technical Details

### Dependencies
- **flutter_screenutil**: Responsive design
- **provider**: State management
- **sqflite**: Local database
- **dio**: HTTP client for downloads
- **cached_network_image**: Image caching
- **flutter_pdfview**: PDF rendering
- **path_provider**: File system access

### Supported Qiraats (All 20 Recitations)

#### The 10 Qaris with their 2 Rawis each:

**1. Nafi' (نافع) from Madinah**
- قالون عن نافع (Qalun 'an Nafi')
- ورش عن نافع (Warsh 'an Nafi') - *Popular in North/West Africa*

**2. Ibn Kathir (ابن كثير) from Makkah**
- البزي عن ابن كثير (Al-Bazzi 'an Ibn Kathir)
- قنبل عن ابن كثير (Qunbul 'an Ibn Kathir)

**3. Abu 'Amr (أبو عمرو) from Basra**
- الدوري عن أبي عمرو (Ad-Duri 'an Abu 'Amr)
- السوسي عن أبي عمرو (As-Sussi 'an Abu 'Amr)

**4. Ibn 'Amir (ابن عامر) from Damascus**
- هشام عن ابن عامر (Hisham 'an Ibn 'Amir)
- ابن ذكوان عن ابن عامر (Ibn Dhakwan 'an Ibn 'Amir)

**5. 'Asim (عاصم) from Kufa**
- شعبة عن عاصم (Shu'ba 'an 'Asim)
- حفص عن عاصم (Hafs 'an 'Asim) - *Most widely used today*

**6. Hamzah (حمزة) from Kufa**
- خلاد عن حمزة (Khalaad 'an Hamzah)
- خلف عن حمزة (Khalaf 'an Hamzah)

**7. Al-Kisa'i (الكسائي) from Kufa**
- أبو الحارث عن الكسائي (Abu al-Harith 'an al-Kisa'i)
- الدوري عن الكسائي (Ad-Duri 'an al-Kisa'i)

**8. Abu Ja'far (أبو جعفر) from Madinah**
- ابن وردان عن أبي جعفر (Ibn Wardan 'an Abu Ja'far)
- ابن جماز عن أبي جعفر (Ibn Jammaz 'an Abu Ja'far)

**9. Ya'qub (يعقوب) from Basra**
- رويس عن يعقوب (Ruways 'an Ya'qub)
- روح عن يعقوب (Rawh 'an Ya'qub)

**10. Khalaf al-'Ashir (خلف العاشر)**
- إسحاق عن خلف (Ishaq 'an Khalaf)
- إدريس عن خلف (Idris 'an Khalaf)

### File Format
- Pages stored as high-resolution JPEG images
- Compressed for optimal storage
- Manifest files for integrity checking

## 🚀 Future Enhancements

### Planned Features
- **Audio Recitation**: Synchronized audio with text
- **Search Functionality**: Search verses and chapters
- **Translation Support**: Multiple language translations
- **Tafsir Integration**: Commentary and interpretation
- **Social Features**: Share verses and bookmarks
- **Advanced Typography**: More calligraphy options

### Technical Improvements
- **Offline-First Architecture**: Enhanced offline capabilities
- **Cloud Synchronization**: Backup and sync across devices
- **Performance Optimization**: Further speed improvements
- **Accessibility Enhancements**: Better screen reader support

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes with proper documentation
4. Add tests for new functionality
5. Submit a pull request

### Development Guidelines
- Follow Flutter/Dart best practices
- Maintain Arabic language support
- Write comprehensive tests
- Document all public APIs
- Follow the existing code style

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Islamic texts and Qiraat data sources
- Arabic typography and font creators
- Flutter community and contributors
- Beta testers and feedback providers

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact the development team
- Check the documentation and FAQs

---

**Built with ❤️ for the Muslim community**

*"وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ فَهَلْ مِن مُّدَّكِرٍ"*  
*"And We have certainly made the Qur'an easy for remembrance, so is there any who will remember?"* - Al-Qamar 54:17