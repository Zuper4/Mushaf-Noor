import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/ayah_bounds.dart';

/// Service for managing ayah bounds data
/// Loads mapping data that defines where each ayah is located on each page
class AyahBoundsService {
  static final AyahBoundsService _instance = AyahBoundsService._internal();
  factory AyahBoundsService() => _instance;
  AyahBoundsService._internal();

  final Dio _dio = Dio();
  
  // Cache of loaded bounds data: qiraatId -> pageNumber -> PageAyahBounds
  final Map<String, Map<int, PageAyahBounds>> _boundsCache = {};
  
  // Metadata about available bounds data for each qiraat
  final Map<String, QiraatBoundsMetadata> _boundsMetadata = {};

  /// Initialize bounds metadata for all qiraats
  /// This should be called when the app starts
  Future<void> initialize() async {
    // TODO: Load metadata from a central JSON file or API
    // For now, we'll assume asim_hafs has bounds data
    _boundsMetadata['asim_hafs'] = const QiraatBoundsMetadata(
      qiraatId: 'asim_hafs',
      isBoundsDataAvailable: true,
      isBoundsDataDownloaded: false, // Will check local storage
      cloudBoundsUrl: 'https://your-cloud-storage.com/bounds/asim_hafs/',
    );
    
    debugPrint('AyahBoundsService initialized');
  }

  /// Check if bounds data is available for a qiraat
  bool isBoundsDataAvailable(String qiraatId) {
    return _boundsMetadata[qiraatId]?.isBoundsDataAvailable ?? false;
  }

  /// Get bounds for a specific page and qiraat
  /// Will load from cache if available, otherwise load from storage/cloud
  Future<PageAyahBounds?> getBoundsForPage(String qiraatId, int pageNumber) async {
    // Check cache first
    if (_boundsCache.containsKey(qiraatId) && 
        _boundsCache[qiraatId]!.containsKey(pageNumber)) {
      return _boundsCache[qiraatId]![pageNumber];
    }

    // Try to load from local storage
    final localBounds = await _loadBoundsFromLocal(qiraatId, pageNumber);
    if (localBounds != null) {
      _cacheBounds(qiraatId, pageNumber, localBounds);
      return localBounds;
    }

    // Try to load from assets (for bundled qiraats)
    final assetBounds = await _loadBoundsFromAssets(qiraatId, pageNumber);
    if (assetBounds != null) {
      _cacheBounds(qiraatId, pageNumber, assetBounds);
      return assetBounds;
    }

    // Finally, try to download from cloud
    final cloudBounds = await _downloadBoundsFromCloud(qiraatId, pageNumber);
    if (cloudBounds != null) {
      _cacheBounds(qiraatId, pageNumber, cloudBounds);
      // Save to local storage for future use
      await _saveBoundsToLocal(qiraatId, pageNumber, cloudBounds);
    }

    return cloudBounds;
  }

  /// Load bounds from local file storage
  Future<PageAyahBounds?> _loadBoundsFromLocal(String qiraatId, int pageNumber) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/bounds/$qiraatId/page_$pageNumber.json');
      
      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      
      return PageAyahBounds.fromJson(json);
    } catch (e) {
      debugPrint('Error loading bounds from local storage: $e');
      return null;
    }
  }

  /// Load bounds from app assets
  Future<PageAyahBounds?> _loadBoundsFromAssets(String qiraatId, int pageNumber) async {
    try {
      final assetPath = 'assets/json/bounds/$qiraatId/page_$pageNumber.json';
      final jsonString = await rootBundle.loadString(assetPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      
      return PageAyahBounds.fromJson(json);
    } catch (e) {
      // Asset doesn't exist, which is normal for most qiraats
      return null;
    }
  }

  /// Download bounds from cloud storage
  Future<PageAyahBounds?> _downloadBoundsFromCloud(String qiraatId, int pageNumber) async {
    try {
      final metadata = _boundsMetadata[qiraatId];
      if (metadata == null || metadata.cloudBoundsUrl == null) {
        return null;
      }

      final url = '${metadata.cloudBoundsUrl}page_$pageNumber.json';
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        return PageAyahBounds.fromJson(response.data as Map<String, dynamic>);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error downloading bounds from cloud: $e');
      return null;
    }
  }

  /// Save bounds to local storage
  Future<void> _saveBoundsToLocal(String qiraatId, int pageNumber, PageAyahBounds bounds) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final boundsDir = Directory('${dir.path}/bounds/$qiraatId');
      
      if (!await boundsDir.exists()) {
        await boundsDir.create(recursive: true);
      }

      final file = File('${boundsDir.path}/page_$pageNumber.json');
      final jsonString = jsonEncode(bounds.toJson());
      await file.writeAsString(jsonString);
      
      debugPrint('Saved bounds to local storage: ${file.path}');
    } catch (e) {
      debugPrint('Error saving bounds to local storage: $e');
    }
  }

  /// Cache bounds in memory
  void _cacheBounds(String qiraatId, int pageNumber, PageAyahBounds bounds) {
    if (!_boundsCache.containsKey(qiraatId)) {
      _boundsCache[qiraatId] = {};
    }
    _boundsCache[qiraatId]![pageNumber] = bounds;
  }

  /// Clear cache for a specific qiraat
  void clearCache(String qiraatId) {
    _boundsCache.remove(qiraatId);
    debugPrint('Cleared bounds cache for $qiraatId');
  }

  /// Clear all cached bounds data
  void clearAllCache() {
    _boundsCache.clear();
    debugPrint('Cleared all bounds cache');
  }

  /// Download all bounds data for a qiraat
  /// Useful for offline usage
  Future<void> downloadAllBounds(String qiraatId, {
    Function(int current, int total)? onProgress,
  }) async {
    const totalPages = 606;
    
    for (int page = 1; page <= totalPages; page++) {
      await getBoundsForPage(qiraatId, page);
      onProgress?.call(page, totalPages);
    }
    
    debugPrint('Downloaded all bounds for $qiraatId');
  }

  /// Delete all local bounds data for a qiraat
  Future<void> deleteLocalBounds(String qiraatId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final boundsDir = Directory('${dir.path}/bounds/$qiraatId');
      
      if (await boundsDir.exists()) {
        await boundsDir.delete(recursive: true);
        debugPrint('Deleted local bounds for $qiraatId');
      }
      
      clearCache(qiraatId);
    } catch (e) {
      debugPrint('Error deleting local bounds: $e');
    }
  }

  /// Find which ayah is at a specific point on a page
  Future<AyahBoundInfo?> findAyahAtPoint(
    String qiraatId,
    int pageNumber,
    double x,
    double y,
  ) async {
    final bounds = await getBoundsForPage(qiraatId, pageNumber);
    return bounds?.findAyahAtPoint(x, y);
  }

  /// Get all ayahs on a specific page
  Future<List<AyahBoundInfo>> getAyahsOnPage(String qiraatId, int pageNumber) async {
    final bounds = await getBoundsForPage(qiraatId, pageNumber);
    return bounds?.ayahs ?? [];
  }
}
