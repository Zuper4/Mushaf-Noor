import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../providers/app_state.dart';
import '../providers/qiraat_provider.dart';
import '../providers/audio_provider.dart';
import '../services/ayah_bounds_service.dart';
import '../widgets/page_viewer.dart';
import '../widgets/reading_controls.dart';
import '../widgets/page_indicator.dart';
import '../widgets/floating_audio_player.dart';
import '../widgets/ayah_audio_selector.dart';
import '../models/surah.dart';
import '../l10n/app_localizations.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late PageController _pageController;
  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    // Arabic reading: page 1 is at index 605, page 2 at index 604, etc.
    // Formula: index = 606 - page
    final arabicIndex = 606 - appState.currentPage;
    _pageController = PageController(initialPage: arabicIndex);
    
    // Hide system UI for fullscreen reading
    _updateSystemUI();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _updateSystemUI() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer2<AppState, QiraatProvider>(
        builder: (context, appState, qiraatProvider, child) {
          final audioProvider = Provider.of<AudioProvider>(context, listen: false);
          return Stack(
            children: [
              // Main page viewer
              PageViewer(
                pageController: _pageController,
                onPageChanged: (index) {
                  // Arabic reading: convert index back to page number
                  // index 0 = page 606, index 1 = page 605, etc.
                  final actualPage = 606 - index;
                  appState.goToPage(actualPage);
                  appState.addToHistory(actualPage);
                },
                onTap: () {
                  setState(() {
                    _isControlsVisible = !_isControlsVisible;
                  });
                },
              ),
              
              // Top controls
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _isControlsVisible ? 0 : -100.h,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: PageIndicator(
                              currentPage: appState.currentPage,
                              totalPages: 606,
                              onPageSelected: (pageNumber) {
                                final arabicIndex = 606 - pageNumber;
                                _pageController.jumpToPage(arabicIndex);
                                appState.goToPage(pageNumber);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              appState.isBookmarked(appState.currentPage)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: appState.isBookmarked(appState.currentPage)
                                  ? Colors.amber
                                  : Colors.white,
                            ),
                            onPressed: () {
                              appState.toggleBookmark(appState.currentPage);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              appState.isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              appState.toggleFullScreen();
                              _updateSystemUI();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Bottom controls
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: _isControlsVisible ? 0 : -150.h,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: ReadingControls(
                      pageController: _pageController,
                      onQiraatPressed: () => _showQiraatSelector(context, qiraatProvider),
                      onMicPressed: () => _handleMicPressed(context, appState, qiraatProvider, audioProvider),
                    ),
                  ),
                ),
              ),
              
              // Side navigation areas (invisible touch zones) - Arabic style
              // Tap zones removed - users can only navigate by swiping or using buttons
              
              // Floating audio player
              const FloatingAudioPlayer(),
            ],
          );
        },
      ),
    );
  }

  void _handleMicPressed(BuildContext context, AppState appState, QiraatProvider qiraatProvider, AudioProvider audioProvider) async {
    final pageNumber = appState.currentPage;
    final selectedQiraat = qiraatProvider.selectedQiraat;
    
    if (selectedQiraat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appState.languageCode == 'ar' 
                ? 'الرجاء اختيار قراءة أولاً' 
                : 'Please select a Qiraat first',
            style: const TextStyle(fontFamily: 'Amiri'),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Determine current surah(s) on this page by loading the bounds
    final boundsService = AyahBoundsService();
    final bounds = await boundsService.getBoundsForPage(selectedQiraat.id, pageNumber);
    
    // Get all unique surahs on this page
    Set<int> surahsOnPage = {};
    if (bounds != null && bounds.ayahs.isNotEmpty) {
      surahsOnPage = bounds.ayahs.map((ayah) => ayah.surahNumber).toSet();
    }
    
    // If multiple surahs on page, let user choose which one
    // If only one surah, use that automatically
    // If no bounds data, fallback to basic mapping
    int currentSurah = 1; // Default fallback
    
    if (surahsOnPage.isEmpty) {
      // Fallback: proper page-to-surah mapping using Surah model
      currentSurah = _getSurahForPage(pageNumber);
    } else if (surahsOnPage.length == 1) {
      // Only one surah on this page
      currentSurah = surahsOnPage.first;
    } else {
      // Multiple surahs on this page - show selection dialog
      currentSurah = await _showSurahSelector(context, surahsOnPage.toList()..sort()) ?? surahsOnPage.first;
    }
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: AyahAudioSelector(
          pageNumber: pageNumber,
          qiraatId: selectedQiraat.id,
          currentSurah: currentSurah,
        ),
      ),
    );
  }

  /// Map a page number to the correct surah using the Surah model data
  int _getSurahForPage(int pageNumber) {
    // Find the surah that contains this page
    for (final surah in Surah.allSurahs) {
      if (pageNumber >= surah.startPage && pageNumber <= surah.endPage) {
        print('DEBUG: Page $pageNumber maps to Surah ${surah.number} (${surah.englishName})');
        return surah.number;
      }
    }
    
    // Fallback - if page is before any surah, default to Al-Fatiha
    // If page is after all surahs, default to An-Nas
    if (pageNumber < Surah.allSurahs.first.startPage) {
      return 1; // Al-Fatiha
    } else {
      return 114; // An-Nas
    }
  }

  Future<int?> _showSurahSelector(BuildContext context, List<int> surahNumbers) async {
    final localizations = AppLocalizations.of(context);
    
    // Surah names mapping
    final surahNames = {
      1: 'الفاتحة', 2: 'البقرة', 3: 'آل عمران', 4: 'النساء', 5: 'المائدة',
      6: 'الأنعام', 7: 'الأعراف', 8: 'الأنفال', 9: 'التوبة', 10: 'يونس',
      11: 'هود', 12: 'يوسف', 13: 'الرعد', 14: 'إبراهيم', 15: 'الحجر',
      16: 'النحل', 17: 'الإسراء', 18: 'الكهف', 19: 'مريم', 20: 'طه',
      21: 'الأنبياء', 22: 'الحج', 23: 'المؤمنون', 24: 'النور', 25: 'الفرقان',
      26: 'الشعراء', 27: 'النمل', 28: 'القصص', 29: 'العنكبوت', 30: 'الروم',
      31: 'لقمان', 32: 'السجدة', 33: 'الأحزاب', 34: 'سبأ', 35: 'فاطر',
      36: 'يس', 37: 'الصافات', 38: 'ص', 39: 'الزمر', 40: 'غافر',
      41: 'فصلت', 42: 'الشورى', 43: 'الزخرف', 44: 'الدخان', 45: 'الجاثية',
      46: 'الأحقاف', 47: 'محمد', 48: 'الفتح', 49: 'الحجرات', 50: 'ق',
      51: 'الذاريات', 52: 'الطور', 53: 'النجم', 54: 'القمر', 55: 'الرحمن',
      56: 'الواقعة', 57: 'الحديد', 58: 'المجادلة', 59: 'الحشر', 60: 'الممتحنة',
      61: 'الصف', 62: 'الجمعة', 63: 'المنافقون', 64: 'التغابن', 65: 'الطلاق',
      66: 'التحريم', 67: 'الملك', 68: 'القلم', 69: 'الحاقة', 70: 'المعارج',
      71: 'نوح', 72: 'الجن', 73: 'المزمل', 74: 'المدثر', 75: 'القيامة',
      76: 'الإنسان', 77: 'المرسلات', 78: 'النبأ', 79: 'النازعات', 80: 'عبس',
      81: 'التكوير', 82: 'الانفطار', 83: 'المطففين', 84: 'الانشقاق', 85: 'البروج',
      86: 'الطارق', 87: 'الأعلى', 88: 'الغاشية', 89: 'الفجر', 90: 'البلد',
      91: 'الشمس', 92: 'الليل', 93: 'الضحى', 94: 'الشرح', 95: 'التين',
      96: 'العلق', 97: 'القدر', 98: 'البينة', 99: 'الزلزلة', 100: 'العاديات',
      101: 'القارعة', 102: 'التكاثر', 103: 'العصر', 104: 'الهمزة', 105: 'الفيل',
      106: 'قريش', 107: 'الماعون', 108: 'الكوثر', 109: 'الكافرون', 110: 'النصر',
      111: 'المسد', 112: 'الإخلاص', 113: 'الفلق', 114: 'الناس',
    };

    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.chooseSurah,
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: surahNumbers.map((surahNum) {
            return ListTile(
              title: Text(
                surahNames[surahNum] ?? 'سورة $surahNum',
                style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.of(context).pop(surahNum),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showQiraatSelector(BuildContext context, QiraatProvider qiraatProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'اختر القراءة',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: qiraatProvider.availableQiraats.length,
                  itemBuilder: (context, index) {
                    final qiraat = qiraatProvider.availableQiraats[index];
                    final isSelected = qiraatProvider.selectedQiraat?.id == qiraat.id;
                    
                    return ListTile(
                      title: Text(
                        qiraat.arabicName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Amiri',
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        qiraat.name,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      leading: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF${qiraat.colorCode.substring(1)}')),
                          shape: BoxShape.circle,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                          : qiraat.isDownloaded
                              ? const Icon(Icons.download_done, color: Colors.green)
                              : const Icon(Icons.download, color: Colors.grey),
                      onTap: () async {
                        if (qiraat.isDownloaded) {
                          await qiraatProvider.selectQiraat(qiraat.id);
                          Navigator.pop(context);
                        } else {
                          // Check connectivity first before allowing selection
                          final connectivityResult = await Connectivity().checkConnectivity();
                          final isOffline = connectivityResult != ConnectivityResult.wifi && 
                                            connectivityResult != ConnectivityResult.mobile &&
                                            connectivityResult != ConnectivityResult.ethernet;
                          
                          if (isOffline) {
                            // Show offline error - cannot access undownloaded riwayat
                            if (!context.mounted) return;
                            final localizations = AppLocalizations.of(context);
                            final appState = Provider.of<AppState>(context, listen: false);
                            
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  localizations.noInternetConnection,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                  ),
                                ),
                                content: Text(
                                  localizations.offlineRiwayatMessage,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      localizations.connectToInternet,
                                      style: TextStyle(
                                        fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Online - show download dialog
                            _showDownloadDialog(context, qiraat, qiraatProvider);
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDownloadDialog(BuildContext context, qiraat, QiraatProvider qiraatProvider) {
    // Show download dialog (connectivity already checked before calling this)
    showDialog(
      context: context,
      builder: (context) => Consumer<AppState>(
        builder: (context, appState, child) {
          final localizations = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(
              localizations.downloadQiraat,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            ),
            content: Text(
              '${localizations.downloadConfirmation} ${appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name}?\nSize: approximately ${qiraatProvider.getQiraatSize(qiraat.id).toStringAsFixed(1)} MB',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localizations.cancel,
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context); // Close qiraat selector
                  await qiraatProvider.downloadQiraat(qiraat.id);
                },
                child: Text(
                  localizations.download,
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}