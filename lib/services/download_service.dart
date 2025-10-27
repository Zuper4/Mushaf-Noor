import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/github_qiraat_service.dart';

class DownloadService {
  static const String _downloadedQiraatsKey = 'downloaded_qiraats';
  final Dio _dio = Dio();
  
  Future<String> get _localPath async {
    if (kIsWeb) {
      return '/web_storage/qiraats';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }
  
  Future<Directory> _getQiraatDirectory(String qiraatId) async {
    final path = await _localPath;
    final dir = Directory('$path/qiraats/$qiraatId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
  
  /// Check if a qiraat is downloaded locally (not just available for streaming)
  Future<bool> isQiraatDownloaded(String qiraatId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadedQiraats = prefs.getStringList(_downloadedQiraatsKey) ?? [];
      
      // Check if it's in the downloaded list
      if (!downloadedQiraats.contains(qiraatId)) {
        return false;
      }
      
      // Verify files actually exist (check a few sample pages)
      if (!kIsWeb) {
        final qiraatDir = await _getQiraatDirectory(qiraatId);
        
        // Check if directory exists and has at least some pages
        if (!await qiraatDir.exists()) {
          return false;
        }
        
        // Check for a few key pages to verify download integrity
        final pagesToCheck = [1, 100, 200, 300, 400, 500, 606];
        int existingPages = 0;
        
        for (final pageNum in pagesToCheck) {
          final file = File('${qiraatDir.path}/page_$pageNum.png');
          if (await file.exists()) {
            existingPages++;
          }
        }
        
        // Consider it downloaded if at least 5 out of 7 sample pages exist
        return existingPages >= 5;
      }
      
      return true; // For web, just check the preference
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if qiraat is downloaded: $e');
      }
      return false;
    }
  }
  
  /// Check if a qiraat is available for streaming (all qiraats are)
  bool isQiraatAvailableOnline(String qiraatId) {
    return GitHubQiraatService.isQiraatAvailable(qiraatId);
  }

  /// Get the path or URL for a specific page
  /// Returns local path if downloaded, otherwise returns Cloudflare R2 URL
  Future<String> getPagePath(String qiraatId, int pageNumber) async {
    // Check if qiraat is downloaded
    final isDownloaded = await isQiraatDownloaded(qiraatId);
    
    if (isDownloaded && !kIsWeb) {
      // Return local path
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      final filePath = '${qiraatDir.path}/page_$pageNumber.png';
      final file = File(filePath);
      
      if (await file.exists()) {
        return filePath;
      }
    }
    
    // Fall back to streaming from Cloudflare R2
    return GitHubQiraatService.getPageUrl(qiraatId, pageNumber);
  }
  
  /// "Download" a qiraat (actually downloads all 606 pages for offline use)
  Future<void> downloadQiraat(
    String qiraatId, {
    Function(double)? onProgress,
  }) async {
    if (kDebugMode) {
      print('DownloadService: Downloading $qiraatId for offline use');
    }
    
    try {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      const totalPages = 606;
      
      // Download each page
      for (int page = 1; page <= totalPages; page++) {
        if (kDebugMode && page % 50 == 0) {
          print('DownloadService: Downloading page $page/$totalPages');
        }
        
        // Get the URL for this page
        final pageUrl = GitHubQiraatService.getPageUrl(qiraatId, page);
        final filePath = '${qiraatDir.path}/page_$page.png';
        
        // Check if file already exists
        final file = File(filePath);
        if (!await file.exists()) {
          try {
            // Download the page image
            await _dio.download(
              pageUrl,
              filePath,
              options: Options(
                receiveTimeout: const Duration(seconds: 30),
              ),
            );
          } catch (e) {
            if (kDebugMode) {
              print('DownloadService: Error downloading page $page: $e');
            }
            // Continue with other pages even if one fails
          }
        }
        
        // Update progress
        final progress = page / totalPages;
        onProgress?.call(progress);
        
        // Small delay to not overwhelm the network
        if (page % 10 == 0) {
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
      
      // Mark as downloaded in preferences
      final prefs = await SharedPreferences.getInstance();
      final downloadedQiraats = prefs.getStringList(_downloadedQiraatsKey) ?? [];
      if (!downloadedQiraats.contains(qiraatId)) {
        downloadedQiraats.add(qiraatId);
        await prefs.setStringList(_downloadedQiraatsKey, downloadedQiraats);
      }
      
      if (kDebugMode) {
        print('DownloadService: $qiraatId downloaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DownloadService: Error downloading qiraat: $e');
      }
      rethrow;
    }
  }
  
  /// Delete a qiraat (remove from downloaded list and delete files)
  /// Note: asim_hafs can be deleted but must be re-downloaded for offline use
  Future<void> deleteQiraat(String qiraatId) async {
    try {
      // Delete the downloaded files
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      if (await qiraatDir.exists()) {
        await qiraatDir.delete(recursive: true);
      }
      
      // Remove from preferences
      final prefs = await SharedPreferences.getInstance();
      final downloadedQiraats = prefs.getStringList(_downloadedQiraatsKey) ?? [];
      downloadedQiraats.remove(qiraatId);
      await prefs.setStringList(_downloadedQiraatsKey, downloadedQiraats);
      
      if (kDebugMode) {
        print('DownloadService: Deleted $qiraatId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DownloadService: Error deleting qiraat: $e');
      }
    }
  }
  
  /// Cancel download (not applicable for streamed qiraats)
  Future<void> cancelDownload(String qiraatId) async {
    // Not needed for streaming
  }
  
  /// Pause download (not applicable for streamed qiraats)
  Future<void> pauseDownload(String qiraatId) async {
    // Not needed for streaming
  }
  
  /// Resume download (not applicable for streamed qiraats)
  Future<void> resumeDownload(
    String qiraatId, {
    Function(double, String)? onProgress,
  }) async {
    // Not needed for streaming
  }
  
  /// Get total storage used (calculate actual file sizes)
  Future<double> getTotalStorageUsed() async {
    if (kIsWeb) return 0.0;
    
    try {
      final path = await _localPath;
      final qiraatsDir = Directory('$path/qiraats');
      
      if (!await qiraatsDir.exists()) {
        return 0.0;
      }
      
      double totalSize = 0;
      await for (var entity in qiraatsDir.list(recursive: true)) {
        if (entity is File) {
          final size = await entity.length();
          totalSize += size;
        }
      }
      
      // Convert bytes to MB
      return totalSize / (1024 * 1024);
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating storage: $e');
      }
      return 0.0;
    }
  }
  
  /// Get storage used by a specific qiraat (calculate actual file size)
  Future<double> getQiraatStorageUsed(String qiraatId) async {
    if (kIsWeb) return 0.0;
    
    try {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      
      if (!await qiraatDir.exists()) {
        return 0.0;
      }
      
      double totalSize = 0;
      await for (var entity in qiraatDir.list(recursive: true)) {
        if (entity is File) {
          final size = await entity.length();
          totalSize += size;
        }
      }
      
      // Convert bytes to MB
      return totalSize / (1024 * 1024);
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating qiraat storage: $e');
      }
      return 0.0;
    }
  }
}
