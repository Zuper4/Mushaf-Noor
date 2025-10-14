import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qiraat.dart';

class DownloadService {
  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};

  DownloadService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<String> get _localPath async {
    if (kIsWeb) {
      // For web, we'll simulate using SharedPreferences
      return '/web_storage/qiraats';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  Future<Directory?> _getQiraatDirectory(String qiraatId) async {
    if (kIsWeb) {
      // For web, we don't use actual directories
      return null;
    } else {
      final path = await _localPath;
      final dir = Directory('$path/qiraats/$qiraatId');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    }
  }

  Future<void> downloadQiraat(
    Qiraat qiraat, {
    required Function(double) onProgress,
  }) async {
    await downloadQiraatPages(
      qiraat.id,
      onProgress: (progress, status) => onProgress(progress),
    );
  }

  Future<void> downloadQiraatPages(
    String qiraatId, {
    required Function(double, String) onProgress,
  }) async {
    // For Hafs, just create manifest without downloading
    if (qiraatId == 'asim_hafs') {
      onProgress(0.0, 'Preparing Hafs recitation...');
      await _createManifestFile(qiraatId, null);
      onProgress(1.0, 'Hafs recitation ready');
      return;
    }

    final cancelToken = CancelToken();
    _cancelTokens[qiraatId] = cancelToken;

    try {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      const totalPages = 606;
      
      onProgress(0.0, 'Preparing download...');

      if (kIsWeb) {
        // For web, simulate download with faster progress
        for (int i = 0; i <= 100; i += 10) {
          if (cancelToken.isCancelled) break;
          
          final progress = i / 100.0;
          onProgress(progress, 'Processing qiraat data... ${i}%');
          
          await Future.delayed(const Duration(milliseconds: 200));
        }
      } else {
        // For mobile/desktop, do actual file download
        for (int page = 1; page <= totalPages; page++) {
          if (cancelToken.isCancelled) break;

          final progress = (page - 1) / totalPages;
          onProgress(progress, 'Downloading page $page of $totalPages');

          await _downloadPage(qiraatId, page, qiraatDir?.path ?? '', cancelToken);
          
          // Small delay to prevent overwhelming the server
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      if (!cancelToken.isCancelled) {
        onProgress(1.0, 'Download completed');
        await _createManifestFile(qiraatId, qiraatDir?.path);
      }
    } catch (e) {
      if (!cancelToken.isCancelled) {
        throw Exception('Download failed: $e');
      }
    } finally {
      _cancelTokens.remove(qiraatId);
    }
  }

  Future<void> _downloadPage(
    String qiraatId,
    int pageNumber,
    String dirPath,
    CancelToken cancelToken,
  ) async {
    if (cancelToken.isCancelled) return;
    
    final fileName = 'page_${pageNumber.toString().padLeft(3, '0')}.jpg';
    final filePath = '$dirPath/$fileName';

    // Skip if file already exists
    if (await File(filePath).exists()) return;

    // For development: First try to copy from assets if they exist
    try {
      final qiraat = await _getQiraatById(qiraatId);
      if (qiraat != null && qiraat.folderPath.isNotEmpty) {
        await _tryLoadFromAssets(qiraat.folderPath, pageNumber, filePath);
        return;
      }
    } catch (e) {
      // Continue to network download if asset loading fails
    }

    // Try network download
    try {
      final pageUrl = _getPageUrl(qiraatId, pageNumber);
      await _dio.download(
        pageUrl,
        filePath,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'User-Agent': 'MushafNoor/1.0',
          },
        ),
      );
    } catch (e) {
      // Create placeholder for development
      await _createPlaceholderPage(filePath, pageNumber);
    }
  }

  String _getPageUrl(String qiraatId, int pageNumber) {
    // Replace with your actual server URLs
    // Example: 'https://your-server.com/qiraats/$qiraatId/pages/$pageNumber.jpg'
    return 'https://api.mushafnoor.com/qiraats/$qiraatId/pages/${pageNumber.toString().padLeft(3, '0')}.jpg';
  }

  Future<Qiraat?> _getQiraatById(String qiraatId) async {
    // In a real implementation, this would come from a database or provider
    // For now, we'll return null and rely on network/placeholder
    return null;
  }

  Future<void> _tryLoadFromAssets(String folderPath, int pageNumber, String outputPath) async {
    try {
      // Try to load from assets/images/qiraats/[qiraatId]/page_XXX.jpg
      // folderPath is actually the qiraatId now
      final assetPath = 'assets/images/qiraats/$folderPath/page_${pageNumber.toString().padLeft(3, '0')}.jpg';
      final byteData = await rootBundle.load(assetPath);
      
      final file = File(outputPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    } catch (e) {
      // Asset doesn't exist, will fall back to network or placeholder
      rethrow;
    }
  }

  Future<void> _createPlaceholderPage(String filePath, int pageNumber) async {
    // Create a simple text placeholder for development
    final file = File(filePath);
    await file.writeAsString('Placeholder for page $pageNumber - Qiraat content would be here');
  }

  Future<void> _createManifestFile(String qiraatId, String? dirPath) async {
    final manifest = {
      'qiraatId': qiraatId,
      'totalPages': 606,
      'downloadedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
    };

    if (kIsWeb) {
      // For web, store manifest in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('qiraat_manifest_$qiraatId', jsonEncode(manifest));
    } else if (dirPath != null) {
      // For mobile/desktop, store as file
      final manifestFile = File('$dirPath/manifest.json');
      await manifestFile.writeAsString(jsonEncode(manifest));
    }
  }

  Future<void> cancelDownload(String qiraatId) async {
    final cancelToken = _cancelTokens[qiraatId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Download cancelled by user');
    }
  }

  Future<void> pauseDownload(String qiraatId) async {
    // For simplicity, pause is implemented as cancel
    // In a more sophisticated implementation, you would save progress
    await cancelDownload(qiraatId);
  }

  Future<void> resumeDownload(
    String qiraatId, {
    required Function(double, String) onProgress,
  }) async {
    // Resume from where we left off
    await downloadQiraatPages(qiraatId, onProgress: onProgress);
  }

  Future<void> deleteQiraat(String qiraatId) async {
    if (kIsWeb) {
      // For web, remove from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('qiraat_manifest_$qiraatId');
    } else {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      if (qiraatDir != null && await qiraatDir.exists()) {
        await qiraatDir.delete(recursive: true);
      }
    }
  }

  Future<bool> isQiraatDownloaded(String qiraatId) async {
    // For Hafs (default), mark as always available
    if (qiraatId == 'asim_hafs') {
      return true;
    }
    
    if (kIsWeb) {
      // For web, check SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('qiraat_manifest_$qiraatId');
    } else {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      if (qiraatDir == null) return false;
      final manifestFile = File('${qiraatDir.path}/manifest.json');
      return await manifestFile.exists();
    }
  }

  Future<String?> getPagePath(String qiraatId, int pageNumber) async {
    if (!await isQiraatDownloaded(qiraatId)) return null;
    
    if (kIsWeb) {
      // For web, return the asset path without the "assets/" prefix
      return 'images/qiraats/$qiraatId/page_${pageNumber.toString().padLeft(3, '0')}.jpg';
    } else {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      if (qiraatDir == null) return null;
      
      final fileName = 'page_${pageNumber.toString().padLeft(3, '0')}.jpg';
      final filePath = '${qiraatDir.path}/$fileName';
      
      final file = File(filePath);
      return await file.exists() ? filePath : null;
    }
  }

  Future<double> getTotalStorageUsed() async {
    if (kIsWeb) {
      // For web, return estimated size based on downloaded qiraats
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('qiraat_manifest_'));
      return keys.length * 50.0; // Estimate 50MB per qiraat
    } else {
      final path = await _localPath;
      final qiraatsDir = Directory('$path/qiraats');
      
      if (!await qiraatsDir.exists()) return 0.0;
      
      double totalSize = 0.0;
      await for (final entity in qiraatsDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }
      
      return totalSize / (1024 * 1024); // Convert to MB
    }
  }

  Future<double> getQiraatStorageUsed(String qiraatId) async {
    if (kIsWeb) {
      // For web, return estimated size if downloaded
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('qiraat_manifest_$qiraatId') ? 50.0 : 0.0;
    } else {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      
      if (qiraatDir == null || !await qiraatDir.exists()) return 0.0;
      
      double totalSize = 0.0;
      await for (final entity in qiraatDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }
      
      return totalSize / (1024 * 1024); // Convert to MB
    }
  }
}