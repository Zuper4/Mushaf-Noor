import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qiraat.dart';
import '../models/surah.dart';
import '../models/mushaf_page.dart';

// For web, we'll use SharedPreferences instead of SQLite
class DatabaseService {
  static SharedPreferences? _prefs;
  
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Initialize method to set up default data if needed
  Future<void> initialize() async {
    final preferences = await prefs;
    
    // Check if we've already initialized
    if (!preferences.containsKey('initialized')) {
      // Set up default data
      await preferences.setBool('initialized', true);
    }
  }

  // Qiraat operations
  Future<List<Qiraat>> getQiraats() async {
    final preferences = await prefs;
    final qiraatsJson = preferences.getString('qiraats');
    
    if (qiraatsJson == null) {
      return [];
    }
    
    final List<dynamic> qiraatsList = jsonDecode(qiraatsJson);
    return qiraatsList.map((json) => Qiraat.fromJson(json)).toList();
  }

  Future<void> insertQiraat(Qiraat qiraat) async {
    final preferences = await prefs;
    List<Qiraat> qiraats = await getQiraats();
    
    // Remove existing qiraat with same ID if any
    qiraats.removeWhere((q) => q.id == qiraat.id);
    
    // Add the new/updated qiraat
    qiraats.add(qiraat);
    
    // Save back to preferences
    final qiraatsJson = jsonEncode(qiraats.map((q) => q.toJson()).toList());
    await preferences.setString('qiraats', qiraatsJson);
  }

  Future<void> updateQiraat(Qiraat qiraat) async {
    await insertQiraat(qiraat); // Same as insert for shared preferences
  }

  Future<void> deleteQiraat(String qiraatId) async {
    final preferences = await prefs;
    List<Qiraat> qiraats = await getQiraats();
    
    qiraats.removeWhere((q) => q.id == qiraatId);
    
    final qiraatsJson = jsonEncode(qiraats.map((q) => q.toJson()).toList());
    await preferences.setString('qiraats', qiraatsJson);
  }

  // Surah operations - we'll use the static data from Surah model
  Future<List<Surah>> getSurahs() async {
    // Return the static surahs from the model
    return Surah.allSurahs;
  }

  Future<Surah?> getSurahByNumber(int number) async {
    try {
      return Surah.allSurahs.firstWhere((s) => s.number == number);
    } catch (e) {
      return null;
    }
  }

  // Settings operations
  Future<void> saveSetting(String key, String value) async {
    final preferences = await prefs;
    await preferences.setString('setting_$key', value);
  }

  Future<String?> getSetting(String key) async {
    final preferences = await prefs;
    return preferences.getString('setting_$key');
  }

  Future<void> saveSelectedQiraat(String qiraatId) async {
    await saveSetting('selected_qiraat', qiraatId);
  }

  Future<String?> getSelectedQiraat() async {
    return await getSetting('selected_qiraat');
  }

  // Bookmark operations
  Future<void> addBookmark(int pageNumber, String qiraatId) async {
    final preferences = await prefs;
    List<int> bookmarks = await getBookmarks(qiraatId);
    
    if (!bookmarks.contains(pageNumber)) {
      bookmarks.add(pageNumber);
      bookmarks.sort(); // Keep sorted
      
      await preferences.setStringList(
        'bookmarks_$qiraatId',
        bookmarks.map((e) => e.toString()).toList(),
      );
    }
  }

  Future<void> removeBookmark(int pageNumber, String qiraatId) async {
    final preferences = await prefs;
    List<int> bookmarks = await getBookmarks(qiraatId);
    
    bookmarks.remove(pageNumber);
    
    await preferences.setStringList(
      'bookmarks_$qiraatId',
      bookmarks.map((e) => e.toString()).toList(),
    );
  }

  Future<List<int>> getBookmarks(String qiraatId) async {
    final preferences = await prefs;
    final bookmarksStr = preferences.getStringList('bookmarks_$qiraatId') ?? [];
    
    return bookmarksStr.map((e) => int.parse(e)).toList();
  }

  Future<bool> isBookmarked(int pageNumber, String qiraatId) async {
    final bookmarks = await getBookmarks(qiraatId);
    return bookmarks.contains(pageNumber);
  }
}