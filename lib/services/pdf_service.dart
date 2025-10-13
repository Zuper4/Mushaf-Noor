import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/qiraat.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class PDFService {
  static final PDFService _instance = PDFService._internal();
  factory PDFService() => _instance;
  PDFService._internal();

  // Cache for loaded PDF paths
  final Map<String, String> _pdfPaths = {};
  
  /// Get the local path for a qiraat's PDF file
  Future<String?> getPDFPath(String qiraatId, {String? qariFolder, String? rawiFileName}) async {
    // Check cache first
    if (_pdfPaths.containsKey(qiraatId)) {
      return _pdfPaths[qiraatId];
    }

    try {
      // New structure: assets/pdfs/{QariFolder}/{RawiFile}.pdf
      // qiraatId format: "qari_rawi" (e.g., "asim_hafs")
      String assetPath;
      
      if (qariFolder != null && rawiFileName != null) {
        // Use provided folder and file names
        assetPath = 'assets/pdfs/$qariFolder/$rawiFileName.pdf';
      } else {
        // Parse from qiraatId
        final parts = qiraatId.split('_');
        if (parts.length >= 2) {
          final qari = parts[0];
          final rawi = parts[1];
          
          // Map qari names to folder names
          final qariMap = {
            'nafi': 'Nafi3',
            'ibn': 'Ibn_Kathir', // for ibn_kathir
            'abu': 'Abu_Amr', // for abu_amr or abu_jafar
            'asim': 'Asim',
            'hamzah': 'Hamzah',
            'kisai': 'Al-Kisai',
            'yaqub': 'Ya3qub',
            'khalaf': 'Khalaf',
          };
          
          // Special handling for compound names
          String folderName;
          if (qiraatId.startsWith('ibn_kathir')) {
            folderName = 'Ibn_Kathir';
          } else if (qiraatId.startsWith('abu_amr')) {
            folderName = 'Abu_Amr';
          } else if (qiraatId.startsWith('ibn_amir')) {
            folderName = 'Ibn_Amir';
          } else if (qiraatId.startsWith('abu_jafar')) {
            folderName = 'Abu_Jafar';
          } else {
            folderName = qariMap[qari] ?? qari.capitalize();
          }
          
          // Map rawi names to file names
          final rawiFileMap = {
            'hafs': 'Hafs',
            'shubah': 'Shu3bah',
            'warsh': 'Warsh',
            'qaloon': 'Qaloon',
            'buzzi': 'Al_Buzzi',
            'qunbul': 'Qunbul',
            'douri': 'Al_Douri',
            'sousi': 'Al_Sousi',
            'hisham': 'Hisham',
            'dhakwan': 'Ibn_Dhakwan',
            'khalaf': 'Khalaf',
            'khallad': 'Khallad',
            'abu': 'Abu_Al_Harith', // for abu_harith
            'harith': 'Abu_Al_Harith',
            'ibn': 'Ibn_Wardan', // Default for ibn_*
            'wardan': 'Ibn_Wardan',
            'jammaz': 'Ibn_Jammaz',
            'ruways': 'Ruways',
            'rawh': 'Rawh',
            'ishaq': 'Ishaq',
            'idris': 'Idris',
          };
          
          final rawiFile = rawiFileMap[rawi] ?? rawi.capitalize();
          assetPath = 'assets/pdfs/$folderName/$rawiFile.pdf';
        } else {
          // Fallback to old naming convention
          assetPath = 'assets/pdfs/$qiraatId/mushaf_$qiraatId.pdf';
        }
      }
      
      if (kIsWeb) {
        // For web, we'll use the asset path directly
        _pdfPaths[qiraatId] = assetPath;
        return assetPath;
      } else {
        // For mobile, copy asset to local storage for better performance
        final localPath = await _copyAssetToLocal(assetPath, qiraatId);
        if (localPath != null) {
          _pdfPaths[qiraatId] = localPath;
          return localPath;
        }
      }
    } catch (e) {
      debugPrint('Error loading PDF for $qiraatId: $e');
    }

    return null;
  }

  /// Copy PDF asset to local storage (mobile only)
  Future<String?> _copyAssetToLocal(String assetPath, String qiraatId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = '${appDir.path}/pdfs/mushaf_$qiraatId.pdf';
      final localFile = File(localPath);

      // Check if file already exists
      if (await localFile.exists()) {
        return localPath;
      }

      // Create directory if it doesn't exist
      await localFile.parent.create(recursive: true);

      // Load asset and write to local file
      final bytes = await rootBundle.load(assetPath);
      await localFile.writeAsBytes(bytes.buffer.asUint8List());

      return localPath;
    } catch (e) {
      debugPrint('Error copying PDF asset to local: $e');
      return null;
    }
  }

  /// Check if PDF exists for a specific qiraat
  Future<bool> hasPDF(String qiraatId, {String? qariFolder, String? rawiFileName}) async {
    try {
      // Get the correct asset path
      String assetPath;
      
      if (qariFolder != null && rawiFileName != null) {
        assetPath = 'assets/pdfs/$qariFolder/$rawiFileName.pdf';
      } else {
        // Parse from qiraatId using the same logic as getPDFPath
        final parts = qiraatId.split('_');
        if (parts.length >= 2) {
          String folderName;
          if (qiraatId.startsWith('ibn_kathir')) {
            folderName = 'Ibn_Kathir';
          } else if (qiraatId.startsWith('abu_amr')) {
            folderName = 'Abu_Amr';
          } else if (qiraatId.startsWith('ibn_amir')) {
            folderName = 'Ibn_Amir';
          } else if (qiraatId.startsWith('abu_jafar')) {
            folderName = 'Abu_Jafar';
          } else if (qiraatId.startsWith('nafi')) {
            folderName = 'Nafi3';
          } else if (qiraatId.startsWith('kisai')) {
            folderName = 'Al-Kisai';
          } else if (qiraatId.startsWith('yaqub')) {
            folderName = 'Ya3qub';
          } else {
            folderName = parts[0].capitalize();
          }
          
          // Get rawi file name
          final rawi = parts.length > 1 ? parts[1] : parts[0];
          final rawiFileMap = {
            'hafs': 'Hafs',
            'shubah': 'Shu3bah',
            'warsh': 'Warsh',
            'qaloon': 'Qaloon',
            'buzzi': 'Al_Buzzi',
            'qunbul': 'Qunbul',
            'douri': 'Al_Douri',
            'sousi': 'Al_Sousi',
            'hisham': 'Hisham',
            'dhakwan': 'Ibn_Dhakwan',
            'khalaf': 'Khalaf',
            'khallad': 'Khallad',
            'harith': 'Abu_Al_Harith',
            'wardan': 'Ibn_Wardan',
            'jammaz': 'Ibn_Jammaz',
            'ruways': 'Ruways',
            'rawh': 'Rawh',
            'ishaq': 'Ishaq',
            'idris': 'Idris',
          };
          
          final rawiFile = rawiFileMap[rawi] ?? rawi.capitalize();
          assetPath = 'assets/pdfs/$folderName/$rawiFile.pdf';
        } else {
          assetPath = 'assets/pdfs/$qiraatId/mushaf_$qiraatId.pdf';
        }
      }
      
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get available qiraats that have PDF files
  Future<List<String>> getAvailableQiraatPDFs() async {
    final availableQiraats = <String>[];
    
    // List of all possible qiraats
    final allQiraats = ['hafs', 'warsh', 'qaloon', 'douri_abu_amr', 'sousi'];
    
    for (final qiraatId in allQiraats) {
      if (await hasPDF(qiraatId)) {
        availableQiraats.add(qiraatId);
      }
    }
    
    return availableQiraats;
  }

  /// Get PDF file size in bytes (for display purposes)
  Future<int> getPDFSize(String qiraatId) async {
    try {
      final assetPath = 'assets/pdfs/$qiraatId/mushaf_$qiraatId.pdf';
      final bytes = await rootBundle.load(assetPath);
      return bytes.lengthInBytes;
    } catch (e) {
      return 0;
    }
  }

  /// Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Clear PDF cache
  void clearCache() {
    _pdfPaths.clear();
  }

  /// Delete local PDF file (mobile only)
  Future<bool> deleteLocalPDF(String qiraatId) async {
    try {
      if (kIsWeb) return true; // No local files on web
      
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = '${appDir.path}/pdfs/mushaf_$qiraatId.pdf';
      final localFile = File(localPath);

      if (await localFile.exists()) {
        await localFile.delete();
        _pdfPaths.remove(qiraatId);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting local PDF: $e');
      return false;
    }
  }

  /// Get PDF page count (requires loading the PDF)
  Future<int> getPageCount(String qiraatId) async {
    // This is a placeholder - actual page count would require
    // loading the PDF with a PDF library
    // For now, return standard Mushaf page count
    return 604;
  }

  /// Calculate which page a specific Surah starts on
  /// This should be updated based on your actual PDF page mappings
  int getSurahStartPage(int surahNumber, String qiraatId) {
    // This is a simplified mapping - you should create a proper
    // mapping based on your actual PDF page numbers
    switch (surahNumber) {
      case 1: return 1;
      case 2: return 2;
      case 3: return 50;
      case 4: return 77;
      case 5: return 106;
      case 6: return 128;
      case 7: return 151;
      case 8: return 177;
      // Add more mappings based on your PDF structure
      default: return 1;
    }
  }
}