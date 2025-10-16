import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_state.dart';
import '../providers/qiraat_provider.dart';
import '../models/surah.dart';

class ImageReaderScreen extends StatefulWidget {
  final String qiraatId;
  final int? initialPage;
  final int? surahNumber;

  const ImageReaderScreen({
    super.key,
    required this.qiraatId,
    this.initialPage,
    this.surahNumber,
  });

  @override
  State<ImageReaderScreen> createState() => _ImageReaderScreenState();
}

class _ImageReaderScreenState extends State<ImageReaderScreen> {
  late PageController _pageController;
  int _currentPage = 1;
  final int _totalPages = 606;
  bool _showControls = true;

  // Base URL for the mushaf-qiraats repository
  static const String baseUrl = 'https://zuper4.github.io/mushaf-qiraats';

  @override
  void initState() {
    super.initState();
    final initialPage = widget.initialPage ?? 
        (widget.surahNumber != null ? _getSurahStartPage(widget.surahNumber!) : 1);
    _currentPage = initialPage;
    _pageController = PageController(initialPage: initialPage - 1);
  }

  /// Map Qiraat ID to the correct folder name in the repository
  String _getQiraatFolderName(String qiraatId) {
    // The repository uses specific folder naming convention
    switch (qiraatId) {
      case 'asim_hafs':
        return 'asim_hafs';
      case 'asim_shuba':
        return 'asim_shuba';
      case 'nafi_qalun':
        return 'nafi_qalun';
      case 'nafi_warsh':
        return 'nafi_warsh';
      case 'ibn_kathir_bazzi':
        return 'ibn_kathir_bazzi';
      case 'ibn_kathir_qunbul':
        return 'ibn_kathir_qunbul';
      case 'abu_amr_duri':
        return 'abu_amr_duri';
      case 'abu_amr_sussi':
        return 'abu_amr_sussi';
      case 'ibn_amir_hisham':
        return 'ibn_amir_hisham';
      case 'ibn_amir_dhakwan':
        return 'ibn_amir_dhakwan';
      case 'hamzah_khalaf':
        return 'hamzah_khalaf';
      case 'hamzah_khalaad':
        return 'hamzah_khalaad';
      case 'kisai_abu_harith':
        return 'kisai_abu_harith';
      case 'kisai_duri':
        return 'kisai_duri';
      case 'abu_jafar_ibn_wardan':
        return 'abu_jafar_ibn_wardan';
      case 'abu_jafar_ibn_jammaz':
        return 'abu_jafar_ibn_jammaz';
      case 'yaqub_rawh':
        return 'yaqub_rawh';
      case 'yaqub_ruways':
        return 'yaqub_ruways';
      case 'khalaf_ishaq':
        return 'khalaf_ishaq';
      case 'khalaf_idris':
        return 'khalaf_idris';
      default:
        return qiraatId; // fallback to original ID
    }
  }

  /// Get image URL for a specific page
  String _getPageImageUrl(int pageNumber) {
    final folderName = _getQiraatFolderName(widget.qiraatId);
    // Pages are numbered with leading zeros (001.jpg, 002.jpg, etc.)
    final paddedPageNumber = pageNumber.toString().padLeft(3, '0');
    return '$baseUrl/$folderName/$paddedPageNumber.jpg';
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _goToPage() {
    showDialog(
      context: context,
      builder: (context) => _GoToPageDialog(
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPageSelected: (page) {
          _pageController.animateToPage(
            page - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  void _showSurahList() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SurahListSheet(
        onSurahSelected: (surah) {
          final startPage = _getSurahStartPage(surah.number);
          _pageController.animateToPage(
            startPage - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Calculate which page a specific Surah starts on
  int _getSurahStartPage(int surahNumber) {
    // This is a simplified mapping - should be updated with accurate page numbers
    const Map<int, int> surahStartPages = {
      1: 1,    // Al-Fatiha
      2: 2,    // Al-Baqarah
      3: 50,   // Ali 'Imran
      4: 77,   // An-Nisa
      5: 106,  // Al-Ma'idah
      6: 128,  // Al-An'am
      7: 151,  // Al-A'raf
      8: 177,  // Al-Anfal
      9: 187,  // At-Tawbah
      10: 208, // Yunus
      // Add more mappings as needed
    };
    return surahStartPages[surahNumber] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final qiraatProvider = context.watch<QiraatProvider>();
    final selectedQiraat = qiraatProvider.selectedQiraat;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Page Viewer
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index + 1;
                });
              },
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                final imageUrl = _getPageImageUrl(pageNumber);
                
                return GestureDetector(
                  onTap: _toggleControls,
                  child: InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Loading page $pageNumber...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48.sp,
                                  color: Colors.red[300],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Failed to load page $pageNumber',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Please check your internet connection',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Top Controls
            if (_showControls)
              Positioned(
                top: 0,
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
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedQiraat?.name ?? 'Mushaf',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Page $_currentPage of $_totalPages',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _showSurahList,
                        icon: Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: _goToPage,
                        icon: Icon(
                          Icons.pages,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom Controls
            if (_showControls)
              Positioned(
                bottom: 0,
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
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1 ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } : null,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: _currentPage > 1 ? Colors.white : Colors.white30,
                          size: 20.sp,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '$_currentPage / $_totalPages',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _currentPage < _totalPages ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: _currentPage < _totalPages ? Colors.white : Colors.white30,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Go to Page Dialog
class _GoToPageDialog extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const _GoToPageDialog({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  State<_GoToPageDialog> createState() => _GoToPageDialogState();
}

class _GoToPageDialogState extends State<_GoToPageDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Go to Page'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '1 - ${widget.totalPages}',
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final page = int.tryParse(_controller.text);
            if (page != null && page >= 1 && page <= widget.totalPages) {
              widget.onPageSelected(page);
              Navigator.pop(context);
            }
          },
          child: const Text('Go'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Surah List Sheet
class _SurahListSheet extends StatelessWidget {
  final Function(Surah) onSurahSelected;

  const _SurahListSheet({
    required this.onSurahSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Select Surah',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Surah.allSurahs.length,
              itemBuilder: (context, index) {
                final surah = Surah.allSurahs[index];
                return ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        surah.number.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    surah.getDisplayName(appState.languageCode),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    '${surah.numberOfAyahs} verses',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  onTap: () => onSurahSelected(surah),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}