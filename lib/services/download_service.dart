import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static const String baseUrl = 'https://zuper4.github.io/mushaf-qiraats';
  
  Future<bool> isQiraatDownloaded(String qiraatId) async {
    if (qiraatId == 'asim_hafs') {
      return true;
    }
    return false;
  }

  Future<String> getPagePath(String qiraatId, int pageNumber) async {
    if (qiraatId == 'asim_hafs') {
      return 'assets/images/qiraats/asim_hafs/page_${pageNumber.toString().padLeft(3, '0')}.jpg';
    }
    return '$baseUrl/$qiraatId/page_${pageNumber.toString().padLeft(3, '0')}.jpg';
  }
  
  Future<void> downloadQiraatPages(String qiraatId, {required Function(double, String) onProgress}) async {
    onProgress(0.0, 'GitHub qiraats are loaded on-demand');
    await Future.delayed(const Duration(milliseconds: 500));
    onProgress(1.0, 'Ready to use');
  }
  
  Future<void> downloadQiraat(String qiraatId) async {
  }
  
  Future<void> deleteQiraat(String qiraatId) async {
  }
  
  Future<void> cancelDownload(String qiraatId) async {
  }
  
  Future<void> pauseDownload(String qiraatId) async {
  }
  
  Future<void> resumeDownload(String qiraatId, {required Function(double, String) onProgress}) async {
    await downloadQiraatPages(qiraatId, onProgress: onProgress);
  }
  
  Future<double> getTotalStorageUsed() async {
    return 0.0;
  }
  
  Future<double> getQiraatStorageUsed(String qiraatId) async {
    return 0.0;
  }
  
  static Future<String> getDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
