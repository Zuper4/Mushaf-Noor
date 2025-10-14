import 'package:flutter/material.dart';
import '../models/qiraat.dart';
import '../services/database_service.dart';
import '../services/download_service.dart';

class QiraatProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final DownloadService _downloadService = DownloadService();

  List<Qiraat> _availableQiraats = [];
  Qiraat? _selectedQiraat;
  bool _isLoading = false;

  List<Qiraat> get availableQiraats => _availableQiraats;
  Qiraat? get selectedQiraat => _selectedQiraat;
  bool get isLoading => _isLoading;

  QiraatProvider() {
    _initializeQiraats();
  }

  Future<void> _initializeQiraats() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize database
      await _databaseService.initialize();
      
      // Load saved qiraats from database
      final savedQiraats = await _databaseService.getQiraats();
      
      if (savedQiraats.isEmpty) {
        // Load default qiraats list and save to database
        _availableQiraats = await _loadDefaultQiraats();
        
        // Save default qiraats to database
        for (final qiraat in _availableQiraats) {
          await _databaseService.insertQiraat(qiraat);
        }
      } else {
        _availableQiraats = savedQiraats;
      }

      // Update download status for all qiraats
      await _updateDownloadStatuses();

      // Set default qiraat (Warsh - since we have its images)
      _selectedQiraat = _availableQiraats.firstWhere(
        (q) => q.id == 'nafi_warsh',
        orElse: () => _availableQiraats.first,
      );
    } catch (e) {
      debugPrint('Error initializing qiraats: $e');
      // Fall back to default qiraats
      _availableQiraats = await _loadDefaultQiraats();
      _selectedQiraat = _availableQiraats.first;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Qiraat>> _loadDefaultQiraats() async {
    // All 20 Qiraats (10 Qaris × 2 Rawis each)
    return [
      // 1. Nafi' from Madinah
      Qiraat(
        id: 'nafi_qaloon',
        qariName: 'Nafi\'',
        rawiName: 'Qaloon',
        name: 'Qaloon \'an Nafi\'',
        arabicName: 'قالون عن نافع',
        qariArabicName: 'نافع',
        rawiArabicName: 'قالون',
        description: 'Madinan recitation',
        colorCode: '#2196F3',
        folderPath: 'Nafi3',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'nafi_warsh',
        qariName: 'Nafi\'',
        rawiName: 'Warsh',
        name: 'Warsh \'an Nafi\'',
        arabicName: 'ورش عن نافع',
        qariArabicName: 'نافع',
        rawiArabicName: 'ورش',
        description: 'Common in North Africa',
        colorCode: '#FF5722',
        folderPath: 'nafi_warsh',
        isDownloaded: true, // We have the images for this qiraat
      ),
      
      // 2. Ibn Kathir from Makkah
      Qiraat(
        id: 'ibn_kathir_buzzi',
        qariName: 'Ibn Kathir',
        rawiName: 'Al-Buzzi',
        name: 'Al-Buzzi \'an Ibn Kathir',
        arabicName: 'البزي عن ابن كثير',
        qariArabicName: 'ابن كثير',
        rawiArabicName: 'البزي',
        description: 'Makkan recitation',
        colorCode: '#4CAF50',
        folderPath: 'Ibn_Kathir',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'ibn_kathir_qunbul',
        qariName: 'Ibn Kathir',
        rawiName: 'Qunbul',
        name: 'Qunbul \'an Ibn Kathir',
        arabicName: 'قنبل عن ابن كثير',
        qariArabicName: 'ابن كثير',
        rawiArabicName: 'قنبل',
        description: 'Makkan recitation',
        colorCode: '#8BC34A',
        folderPath: 'ibn_kathir_qunbul',
        isDownloaded: true, // We have the images for this qiraat
      ),
      
      // 3. Abu Amr from Basra
      Qiraat(
        id: 'abu_amr_douri',
        qariName: 'Abu Amr',
        rawiName: 'Al-Douri',
        name: 'Al-Douri \'an Abu Amr',
        arabicName: 'الدوري عن أبي عمرو',
        qariArabicName: 'أبو عمرو',
        rawiArabicName: 'الدوري',
        description: 'Basran recitation',
        colorCode: '#9C27B0',
        folderPath: 'Abu_Amr',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'abu_amr_sousi',
        qariName: 'Abu Amr',
        rawiName: 'As-Sousi',
        name: 'As-Sousi \'an Abu Amr',
        arabicName: 'السوسي عن أبي عمرو',
        qariArabicName: 'أبو عمرو',
        rawiArabicName: 'السوسي',
        description: 'Basran recitation',
        colorCode: '#E91E63',
        folderPath: 'Abu_Amr',
        isDownloaded: false,
      ),
      
      // 4. Ibn Amir from Damascus
      Qiraat(
        id: 'ibn_amir_hisham',
        qariName: 'Ibn Amir',
        rawiName: 'Hisham',
        name: 'Hisham \'an Ibn Amir',
        arabicName: 'هشام عن ابن عامر',
        qariArabicName: 'ابن عامر',
        rawiArabicName: 'هشام',
        description: 'Damascene recitation',
        colorCode: '#FF9800',
        folderPath: 'Ibn_Amir',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'ibn_amir_dhakwan',
        qariName: 'Ibn Amir',
        rawiName: 'Ibn Dhakwan',
        name: 'Ibn Dhakwan \'an Ibn Amir',
        arabicName: 'ابن ذكوان عن ابن عامر',
        qariArabicName: 'ابن عامر',
        rawiArabicName: 'ابن ذكوان',
        description: 'Damascene recitation',
        colorCode: '#FFC107',
        folderPath: 'Ibn_Amir',
        isDownloaded: false,
      ),
      
      // 5. Asim from Kufa
      Qiraat(
        id: 'asim_shubah',
        qariName: 'Asim',
        rawiName: 'Shu\'bah',
        name: 'Shu\'bah \'an Asim',
        arabicName: 'شعبة عن عاصم',
        qariArabicName: 'عاصم',
        rawiArabicName: 'شعبة',
        description: 'Kufan recitation',
        colorCode: '#607D8B',
        folderPath: 'Asim',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'asim_hafs',
        qariName: 'Asim',
        rawiName: 'Hafs',
        name: 'Hafs \'an Asim',
        arabicName: 'حفص عن عاصم',
        qariArabicName: 'عاصم',
        rawiArabicName: 'حفص',
        description: 'Most common recitation worldwide',
        colorCode: '#000000',
        folderPath: 'Asim',
        isDownloaded: false,
      ),
      
      // 6. Hamzah from Kufa
      Qiraat(
        id: 'hamzah_khalaf',
        qariName: 'Hamzah',
        rawiName: 'Khalaf',
        name: 'Khalaf \'an Hamzah',
        arabicName: 'خلف عن حمزة',
        qariArabicName: 'حمزة',
        rawiArabicName: 'خلف',
        description: 'Kufan recitation',
        colorCode: '#795548',
        folderPath: 'hamzah_khalaf',
        isDownloaded: true, // We have the images for this qiraat
      ),
      Qiraat(
        id: 'hamzah_khallad',
        qariName: 'Hamzah',
        rawiName: 'Khallad',
        name: 'Khallad \'an Hamzah',
        arabicName: 'خلاد عن حمزة',
        qariArabicName: 'حمزة',
        rawiArabicName: 'خلاد',
        description: 'Kufan recitation',
        colorCode: '#8D6E63',
        folderPath: 'Hamzah',
        isDownloaded: false,
      ),
      
      // 7. Al-Kisa'i from Kufa
      Qiraat(
        id: 'kisai_abu_harith',
        qariName: 'Al-Kisa\'i',
        rawiName: 'Abu al-Harith',
        name: 'Abu al-Harith \'an al-Kisa\'i',
        arabicName: 'أبو الحارث عن الكسائي',
        qariArabicName: 'الكسائي',
        rawiArabicName: 'أبو الحارث',
        description: 'Kufan recitation',
        colorCode: '#009688',
        folderPath: 'Al-Kisai',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'kisai_douri',
        qariName: 'Al-Kisa\'i',
        rawiName: 'Al-Douri',
        name: 'Al-Douri \'an al-Kisa\'i',
        arabicName: 'الدوري عن الكسائي',
        qariArabicName: 'الكسائي',
        rawiArabicName: 'الدوري',
        description: 'Kufan recitation',
        colorCode: '#00BCD4',
        folderPath: 'Al-Kisai',
        isDownloaded: false,
      ),
      
      // 8. Abu Ja'far from Madinah
      Qiraat(
        id: 'abu_jafar_ibn_wardan',
        qariName: 'Abu Ja\'far',
        rawiName: 'Ibn Wardan',
        name: 'Ibn Wardan \'an Abu Ja\'far',
        arabicName: 'ابن وردان عن أبي جعفر',
        qariArabicName: 'أبو جعفر',
        rawiArabicName: 'ابن وردان',
        description: 'Madinan recitation',
        colorCode: '#3F51B5',
        folderPath: 'Abu_Jafar',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'abu_jafar_ibn_jammaz',
        qariName: 'Abu Ja\'far',
        rawiName: 'Ibn Jammaz',
        name: 'Ibn Jammaz \'an Abu Ja\'far',
        arabicName: 'ابن جماز عن أبي جعفر',
        qariArabicName: 'أبو جعفر',
        rawiArabicName: 'ابن جماز',
        description: 'Madinan recitation',
        colorCode: '#673AB7',
        folderPath: 'Abu_Jafar',
        isDownloaded: false,
      ),
      
      // 9. Ya'qub from Basra
      Qiraat(
        id: 'yaqub_ruways',
        qariName: 'Ya\'qub',
        rawiName: 'Ruways',
        name: 'Ruways \'an Ya\'qub',
        arabicName: 'رويس عن يعقوب',
        qariArabicName: 'يعقوب',
        rawiArabicName: 'رويس',
        description: 'Basran recitation',
        colorCode: '#CDDC39',
        folderPath: 'yaqub_ruways',
        isDownloaded: true, // We have the images for this qiraat
      ),
      Qiraat(
        id: 'yaqub_rawh',
        qariName: 'Ya\'qub',
        rawiName: 'Rawh',
        name: 'Rawh \'an Ya\'qub',
        arabicName: 'روح عن يعقوب',
        qariArabicName: 'يعقوب',
        rawiArabicName: 'روح',
        description: 'Basran recitation',
        colorCode: '#FFEB3B',
        folderPath: 'Ya3qub',
        isDownloaded: false,
      ),
      
      // 10. Khalaf al-'Ashir
      Qiraat(
        id: 'khalaf_ishaq',
        qariName: 'Khalaf',
        rawiName: 'Ishaq',
        name: 'Ishaq \'an Khalaf',
        arabicName: 'إسحاق عن خلف',
        qariArabicName: 'خلف',
        rawiArabicName: 'إسحاق',
        description: 'Khalaf al-\'Ashir recitation',
        colorCode: '#FF6F00',
        folderPath: 'Khalaf',
        isDownloaded: false,
      ),
      Qiraat(
        id: 'khalaf_idris',
        qariName: 'Khalaf',
        rawiName: 'Idris',
        name: 'Idris \'an Khalaf',
        arabicName: 'إدريس عن خلف',
        qariArabicName: 'خلف',
        rawiArabicName: 'إدريس',
        description: 'Khalaf al-\'Ashir recitation',
        colorCode: '#F57C00',
        folderPath: 'Khalaf',
        isDownloaded: false,
      ),
    ];
  }

  Future<void> selectQiraat(String qiraatId) async {
    final qiraat = _availableQiraats.firstWhere((q) => q.id == qiraatId);
    
    if (!qiraat.isDownloaded) {
      // Need to download this qiraat first
      await downloadQiraat(qiraatId);
    }
    
    _selectedQiraat = qiraat;
    notifyListeners();
    
    // Save selection to preferences
    await _databaseService.saveSelectedQiraat(qiraatId);
  }

  Future<void> downloadQiraat(String qiraatId) async {
    final qiraatIndex = _availableQiraats.indexWhere((q) => q.id == qiraatId);
    if (qiraatIndex == -1) return;

    final qiraat = _availableQiraats[qiraatIndex];
    
    try {
      await _downloadService.downloadQiraat(
        qiraat,
        onProgress: (progress) {
          _availableQiraats[qiraatIndex] = qiraat.copyWith(
            downloadProgress: progress,
          );
          notifyListeners();
        },
      );

      _availableQiraats[qiraatIndex] = qiraat.copyWith(
        isDownloaded: true,
        downloadProgress: 1.0,
      );
      
      await _databaseService.updateQiraat(_availableQiraats[qiraatIndex]);
      notifyListeners();
    } catch (e) {
      debugPrint('Error downloading qiraat: $e');
      // Reset progress on error
      _availableQiraats[qiraatIndex] = qiraat.copyWith(
        downloadProgress: 0.0,
      );
      notifyListeners();
    }
  }

  Future<void> deleteQiraat(String qiraatId) async {
    if (qiraatId == 'nafi_warsh') return; // Don't allow deleting default qiraat
    
    final qiraatIndex = _availableQiraats.indexWhere((q) => q.id == qiraatId);
    if (qiraatIndex == -1) return;

    try {
      await _downloadService.deleteQiraat(qiraatId);
      
      _availableQiraats[qiraatIndex] = _availableQiraats[qiraatIndex].copyWith(
        isDownloaded: false,
        downloadProgress: 0.0,
      );
      
      await _databaseService.updateQiraat(_availableQiraats[qiraatIndex]);
      
      // If this was the selected qiraat, switch to Warsh
      if (_selectedQiraat?.id == qiraatId) {
        await selectQiraat('nafi_warsh');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting qiraat: $e');
    }
  }

  double getQiraatSize(String qiraatId) {
    // Estimate size in MB - in real app, get from server
    return 50.0; // Approximate size for 604 pages
  }

  Future<void> _updateDownloadStatuses() async {
    bool hasChanges = false;
    
    try {
      for (int i = 0; i < _availableQiraats.length; i++) {
        final qiraat = _availableQiraats[i];
        
        try {
          final isDownloaded = await _downloadService.isQiraatDownloaded(qiraat.id);
          
          if (qiraat.isDownloaded != isDownloaded) {
            _availableQiraats[i] = qiraat.copyWith(isDownloaded: isDownloaded);
            await _databaseService.updateQiraat(_availableQiraats[i]);
            hasChanges = true;
          }
        } catch (e) {
          debugPrint('Error checking download status for ${qiraat.id}: $e');
          // For web compatibility, assume default status
        }
      }
    } catch (e) {
      debugPrint('Error updating download statuses: $e');
    }
    
    if (hasChanges) {
      notifyListeners();
    }
  }

  Future<void> refreshDownloadStatuses() async {
    await _updateDownloadStatuses();
  }
}