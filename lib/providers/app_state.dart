import 'package:flutter/material.dart';
import '../models/mushaf_page.dart';

class AppState extends ChangeNotifier {
  int _currentPage = 2;  // Start from page 2 (page 1 is cover)
  bool _isDarkMode = false;
  double _fontSize = 18.0;
  String _fontFamily = 'Uthmanic';
  bool _showTranslation = false;
  bool _isFullScreen = false;
  String _languageCode = 'en'; // Default to English

  // Getters
  int get currentPage => _currentPage;
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  bool get showTranslation => _showTranslation;
  bool get isFullScreen => _isFullScreen;
  String get languageCode => _languageCode;

  // Page navigation
  void goToPage(int page) {
    if (page >= 1 && page <= 606) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < 606) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  // Theme settings
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  // Font settings
  void increaseFontSize() {
    if (_fontSize < 32.0) {
      _fontSize += 2.0;
      notifyListeners();
    }
  }

  void decreaseFontSize() {
    if (_fontSize > 12.0) {
      _fontSize -= 2.0;
      notifyListeners();
    }
  }

  void setFontSize(double size) {
    if (size >= 12.0 && size <= 32.0) {
      _fontSize = size;
      notifyListeners();
    }
  }

  void setFontFamily(String family) {
    _fontFamily = family;
    notifyListeners();
  }

  // Display settings
  void toggleTranslation() {
    _showTranslation = !_showTranslation;
    notifyListeners();
  }

  void setShowTranslation(bool show) {
    _showTranslation = show;
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void setFullScreen(bool fullScreen) {
    _isFullScreen = fullScreen;
    notifyListeners();
  }

  // Language settings
  void setLanguage(String languageCode) {
    _languageCode = languageCode;
    notifyListeners();
  }

  void toggleLanguage() {
    _languageCode = _languageCode == 'en' ? 'ar' : 'en';
    notifyListeners();
  }

  // Bookmark functionality
  final List<int> _bookmarks = [];
  List<int> get bookmarks => List.unmodifiable(_bookmarks);

  void addBookmark(int page) {
    if (!_bookmarks.contains(page)) {
      _bookmarks.add(page);
      _bookmarks.sort();
      notifyListeners();
    }
  }

  void removeBookmark(int page) {
    _bookmarks.remove(page);
    notifyListeners();
  }

  bool isBookmarked(int page) {
    return _bookmarks.contains(page);
  }

  void toggleBookmark(int page) {
    if (isBookmarked(page)) {
      removeBookmark(page);
    } else {
      addBookmark(page);
    }
  }

  // Reading history
  final List<int> _recentPages = [];
  List<int> get recentPages => List.unmodifiable(_recentPages);

  void addToHistory(int page) {
    _recentPages.remove(page); // Remove if already exists
    _recentPages.insert(0, page); // Add to beginning
    
    // Keep only last 20 pages
    if (_recentPages.length > 20) {
      _recentPages.removeLast();
    }
    notifyListeners();
  }
}