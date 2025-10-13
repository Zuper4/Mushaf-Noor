import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/qiraat_provider.dart';
import '../widgets/page_viewer.dart';
import '../widgets/reading_controls.dart';
import '../widgets/page_indicator.dart';
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
    _pageController = PageController(initialPage: appState.currentPage - 1);
    
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
          return Stack(
            children: [
              // Main page viewer
              PageViewer(
                pageController: _pageController,
                onPageChanged: (page) {
                  appState.goToPage(page + 1);
                  appState.addToHistory(page + 1);
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
                              totalPages: 604,
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
                      onSettingsPressed: () => _showQuickSettings(context, appState),
                      onQiraatPressed: () => _showQiraatSelector(context, qiraatProvider),
                    ),
                  ),
                ),
              ),
              
              // Side navigation areas (invisible touch zones)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 80.w,
                child: GestureDetector(
                  onTap: () {
                    if (appState.currentPage > 1) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 80.w,
                child: GestureDetector(
                  onTap: () {
                    if (appState.currentPage < 604) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showQuickSettings(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<AppState>(
                builder: (context, appState, child) {
                  final localizations = AppLocalizations.of(context);
                  return Text(
                    localizations.quickSettings,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              
              // Font size slider
              Row(
                children: [
                  Text(
                    'حجم الخط',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Amiri',
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: appState.fontSize,
                      min: 12.0,
                      max: 32.0,
                      divisions: 10,
                      label: appState.fontSize.round().toString(),
                      onChanged: (value) {
                        appState.setFontSize(value);
                      },
                    ),
                  ),
                ],
              ),
              
              // Dark mode toggle
              SwitchListTile(
                title: Text(
                  'الوضع الليلي',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Amiri',
                  ),
                ),
                value: appState.isDarkMode,
                onChanged: (value) {
                  appState.setDarkMode(value);
                },
              ),
              
              // Translation toggle
              SwitchListTile(
                title: Text(
                  'إظهار الترجمة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Amiri',
                  ),
                ),
                value: appState.showTranslation,
                onChanged: (value) {
                  appState.setShowTranslation(value);
                },
              ),
              
              SizedBox(height: 20.h),
            ],
          ),
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
                          // Show download dialog
                          _showDownloadDialog(context, qiraat, qiraatProvider);
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تنزيل القراءة',
          style: TextStyle(fontFamily: 'Amiri', fontSize: 18.sp),
        ),
        content: Text(
          'هل تريد تنزيل قراءة ${qiraat.arabicName}؟\nحجم التنزيل تقريباً: ${qiraatProvider.getQiraatSize(qiraat.id).toStringAsFixed(1)} ميجابايت',
          style: TextStyle(fontFamily: 'Amiri', fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Amiri')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context); // Close qiraat selector
              await qiraatProvider.downloadQiraat(qiraat.id);
            },
            child: const Text('تنزيل', style: TextStyle(fontFamily: 'Amiri')),
          ),
        ],
      ),
    );
  }
}