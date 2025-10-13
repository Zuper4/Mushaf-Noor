import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/qiraat.dart';

class DownloadService {
  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};

  DownloadService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> _getQiraatDirectory(String qiraatId) async {
    final path = await _localPath;
    final dir = Directory('$path/qiraats/$qiraatId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
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
    final cancelToken = CancelToken();
    _cancelTokens[qiraatId] = cancelToken;

    try {
      final qiraatDir = await _getQiraatDirectory(qiraatId);
      const totalPages = 604;
      
      onProgress(0.0, 'Preparing download...');

      for (int page = 1; page <= totalPages; page++) {
        if (cancelToken.isCancelled) break;

        final progress = (page - 1) / totalPages;
        onProgress(progress, 'Downloading page $page of $totalPages');

        await _downloadPage(qiraatId, page, qiraatDir.path, cancelToken);
        
        // Small delay to prevent overwhelming the server
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!cancelToken.isCancelled) {
        onProgress(1.0, 'Download completed');
        await _createManifestFile(qiraatId, qiraatDir.path);
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
    // In a real app, you would have actual URLs for each qiraat page
    // This is a placeholder structure
    final pageUrl = _getPageUrl(qiraatId, pageNumber);
    final fileName = 'page_${pageNumber.toString().padLeft(3, '0')}.jpg';
    final filePath = '$dirPath/$fileName';

    // Skip if file already exists
    if (await File(filePath).exists()) return;

    try {
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
      // In development, create placeholder files
      if (e is DioException && e.type == DioExceptionType.connectionError) {
        await _createPlaceholderPage(filePath, pageNumber);
      } else {
        rethrow;
      }
    }
  }

  String _getPageUrl(String qiraatId, int pageNumber) {
    // Replace with your actual server URLs
    // Example: 'https://your-server.com/qiraats/$qiraatId/pages/$pageNumber.jpg'
    return 'https://api.mushafnoor.com/qiraats/$qiraatId/pages/${pageNumber.toString().padLeft(3, '0')}.jpg';
  }

  Future<void> _createPlaceholderPage(String filePath, int pageNumber) async {
    // Create a placeholder file for development
    final file = File(filePath);
    await file.writeAsString('Placeholder for page $pageNumber');
  }

  Future<void> _createManifestFile(String qiraatId, String dirPath) async {
    final manifest = {
      'qiraatId': qiraatId,
      'totalPages': 604,
      'downloadedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
    };

    final manifestFile = File('$dirPath/manifest.json');
    await manifestFile.writeAsString(
      Uri.encodeComponent(manifest.toString()),
    );
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
    final qiraatDir = await _getQiraatDirectory(qiraatId);
    if (await qiraatDir.exists()) {
      await qiraatDir.delete(recursive: true);
    }
  }

  Future<bool> isQiraatDownloaded(String qiraatId) async {
    final qiraatDir = await _getQiraatDirectory(qiraatId);
    final manifestFile = File('${qiraatDir.path}/manifest.json');
    return await manifestFile.exists();
  }

  Future<String?> getPagePath(String qiraatId, int pageNumber) async {
    if (!await isQiraatDownloaded(qiraatId)) return null;
    
    final qiraatDir = await _getQiraatDirectory(qiraatId);
    final fileName = 'page_${pageNumber.toString().padLeft(3, '0')}.jpg';
    final filePath = '${qiraatDir.path}/$fileName';
    
    final file = File(filePath);
    return await file.exists() ? filePath : null;
  }

  Future<double> getTotalStorageUsed() async {
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

  Future<double> getQiraatStorageUsed(String qiraatId) async {
    final qiraatDir = await _getQiraatDirectory(qiraatId);
    
    if (!await qiraatDir.exists()) return 0.0;
    
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