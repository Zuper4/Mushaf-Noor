import 'package:flutter/foundation.dart';
import '../services/github_qiraat_service.dart';

class DownloadService {
  /// Check if a qiraat is "downloaded" (available for reading)
  /// All qiraats are now streamed from Cloudflare R2, so always "available" with internet
  Future<bool> isQiraatDownloaded(String qiraatId) async {
    // All qiraats are available via Cloudflare R2 (no local download needed)
    // They're streamed on-demand with caching via CachedNetworkImage
    return GitHubQiraatService.isQiraatAvailable(qiraatId);
  }

  /// Get the path or URL for a specific page
  /// Returns a Cloudflare R2 URL for all qiraats
  Future<String> getPagePath(String qiraatId, int pageNumber) async {
    // Use Cloudflare R2 URL for all qiraats (including asim_hafs)
    return GitHubQiraatService.getPageUrl(qiraatId, pageNumber);
  }
  
  /// "Download" a qiraat (actually just marks it as available since we stream from GitHub)
  Future<void> downloadQiraat(
    String qiraatId, {
    Function(double)? onProgress,
  }) async {
    if (kDebugMode) {
      print('DownloadService: "Downloading" $qiraatId (actually just enabling it for streaming)');
    }
    
    // Simulate a brief loading period
    onProgress?.call(0.0);
    await Future.delayed(const Duration(milliseconds: 300));
    onProgress?.call(0.5);
    await Future.delayed(const Duration(milliseconds: 300));
    onProgress?.call(1.0);
    
    if (kDebugMode) {
      print('DownloadService: $qiraatId is now available for streaming from GitHub Pages');
    }
  }
  
  /// Delete a qiraat (not applicable for streamed qiraats)
  Future<void> deleteQiraat(String qiraatId) async {
    // For streamed qiraats, we could clear the cache here
    // But CachedNetworkImage handles this automatically
    if (kDebugMode) {
      print('DownloadService: Clearing cache for $qiraatId');
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
  
  /// Get total storage used (minimal since we stream)
  Future<double> getTotalStorageUsed() async {
    // Only bundled Hafs uses storage, rest is cached temporarily
    return 0.0; // Could calculate actual cache size if needed
  }
  
  /// Get storage used by a specific qiraat
  Future<double> getQiraatStorageUsed(String qiraatId) async {
    return 0.0; // Streaming qiraats don't use persistent storage
  }
}
