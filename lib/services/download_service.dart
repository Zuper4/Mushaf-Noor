import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static const String baseUrl = 'https://zuper4.github.io/mushaf-qiraats';
  
  // Main methods called by the app
  Future<bool> isQiraatDownloaded(String qiraatId) async {
    if (qiraatId == 'asim_hafs') {
      return true; // Available as local asset
    }
    return false; // GitHub qiraats are not "downloaded"
  }

  Future<String> getPagePath(String qiraatId, int pageNumber) async {
    if (qiraatId == 'asim_hafs') {
      return 'assets/images/qiraats/asim_hafs/page_${pageNumber.toString().padLeft(3, '0')}.jpg';
    }
    return '$baseUrl/$qiraatId/page_${pageNumber.toString().padLeft(3, '0')}.jpg';
  }
  
  // Methods expected by download provider
  Future<void> downloadQiraatPages(String qiraatId, {required Function(double, String) onProgress}) async {
    onProgress(0.0, 'GitHub qiraats are loaded on-demand');
    await Future.delayed(const Duration(milliseconds: 500));
    onProgress(1.0, 'Ready to use');
  }
  
  Future<void> downloadQiraat(String qiraatId) async {
    // No-op for GitHub qiraats
  }
  
  Future<void> deleteQiraat(String qiraatId) async {
    // No-op for GitHub qiraats  
  }
  
  Future<void> cancelDownload(String qiraatId) async {
    // No-op for GitHub qiraats
  }
  
  Future<void> pauseDownload(String qiraatId) async {
    // No-op for GitHub qiraats
  }
  
  Future<void> resumeDownload(String qiraatId, {required Function(double, String) onProgress}) async {
    await downloadQiraatPages(qiraatId, onProgress: onProgress);
  }
  
  Future<double> getTotalStorageUsed() async {
    return 0.0; // GitHub qiraats use no local storage
  }
  
  Future<double> getQiraatStorageUsed(String qiraatId) async {
    return 0.0; // GitHub qiraats use no local storage
  }
  
  static Future<String> getDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
