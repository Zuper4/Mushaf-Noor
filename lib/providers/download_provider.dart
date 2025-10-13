import 'package:flutter/material.dart';
import '../services/download_service.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();
  
  final Map<String, double> _downloadProgress = {};
  final Map<String, String> _downloadStatus = {};
  final Set<String> _activeDownloads = {};

  Map<String, double> get downloadProgress => Map.unmodifiable(_downloadProgress);
  Map<String, String> get downloadStatus => Map.unmodifiable(_downloadStatus);
  Set<String> get activeDownloads => Set.unmodifiable(_activeDownloads);

  bool isDownloading(String qiraatId) {
    return _activeDownloads.contains(qiraatId);
  }

  double getProgress(String qiraatId) {
    return _downloadProgress[qiraatId] ?? 0.0;
  }

  String getStatus(String qiraatId) {
    return _downloadStatus[qiraatId] ?? 'Not started';
  }

  Future<void> startDownload(String qiraatId, String qiraatName) async {
    if (_activeDownloads.contains(qiraatId)) return;

    _activeDownloads.add(qiraatId);
    _downloadProgress[qiraatId] = 0.0;
    _downloadStatus[qiraatId] = 'Starting download...';
    notifyListeners();

    try {
      await _downloadService.downloadQiraatPages(
        qiraatId,
        onProgress: (progress, status) {
          _downloadProgress[qiraatId] = progress;
          _downloadStatus[qiraatId] = status;
          notifyListeners();
        },
      );

      _downloadStatus[qiraatId] = 'Download completed';
      _downloadProgress[qiraatId] = 1.0;
    } catch (e) {
      _downloadStatus[qiraatId] = 'Download failed: ${e.toString()}';
      _downloadProgress[qiraatId] = 0.0;
    } finally {
      _activeDownloads.remove(qiraatId);
      notifyListeners();
    }
  }

  Future<void> cancelDownload(String qiraatId) async {
    if (!_activeDownloads.contains(qiraatId)) return;

    try {
      await _downloadService.cancelDownload(qiraatId);
      _activeDownloads.remove(qiraatId);
      _downloadProgress[qiraatId] = 0.0;
      _downloadStatus[qiraatId] = 'Download cancelled';
      notifyListeners();
    } catch (e) {
      debugPrint('Error cancelling download: $e');
    }
  }

  Future<void> pauseDownload(String qiraatId) async {
    if (!_activeDownloads.contains(qiraatId)) return;

    try {
      await _downloadService.pauseDownload(qiraatId);
      _downloadStatus[qiraatId] = 'Download paused';
      notifyListeners();
    } catch (e) {
      debugPrint('Error pausing download: $e');
    }
  }

  Future<void> resumeDownload(String qiraatId) async {
    if (_activeDownloads.contains(qiraatId)) return;

    try {
      _activeDownloads.add(qiraatId);
      _downloadStatus[qiraatId] = 'Resuming download...';
      notifyListeners();

      await _downloadService.resumeDownload(
        qiraatId,
        onProgress: (progress, status) {
          _downloadProgress[qiraatId] = progress;
          _downloadStatus[qiraatId] = status;
          notifyListeners();
        },
      );

      _downloadStatus[qiraatId] = 'Download completed';
      _downloadProgress[qiraatId] = 1.0;
    } catch (e) {
      _downloadStatus[qiraatId] = 'Resume failed: ${e.toString()}';
    } finally {
      _activeDownloads.remove(qiraatId);
      notifyListeners();
    }
  }

  void clearDownloadHistory() {
    _downloadProgress.clear();
    _downloadStatus.clear();
    notifyListeners();
  }

  // Get total storage used by all qiraats
  Future<double> getTotalStorageUsed() async {
    return await _downloadService.getTotalStorageUsed();
  }

  // Get storage used by specific qiraat
  Future<double> getQiraatStorageUsed(String qiraatId) async {
    return await _downloadService.getQiraatStorageUsed(qiraatId);
  }
}