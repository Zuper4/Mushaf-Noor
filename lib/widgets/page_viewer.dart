import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';
import '../providers/qiraat_provider.dart';
import '../services/download_service.dart';

class PageViewer extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;
  final VoidCallback onTap;

  const PageViewer({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, QiraatProvider>(
      builder: (context, appState, qiraatProvider, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Right-to-left for Arabic
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: 606, // Total Mushaf pages
            reverse: true, // Arabic reading: right-to-left, page 1 on far right
            scrollDirection: Axis.horizontal, // Horizontal scrolling for Arabic books
            physics: const BouncingScrollPhysics(), // Smooth scrolling physics
            pageSnapping: true, // Snap to pages for clean navigation
            itemBuilder: (context, index) {
              // For Arabic reading: reverse the page mapping
              // index 0 = page 606, index 1 = page 605, ..., index 605 = page 1
              final pageNumber = 606 - index;
            return GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: appState.isDarkMode ? Colors.black : Colors.white,
                child: _buildPageContent(
                  context,
                  pageNumber,
                  appState,
                  qiraatProvider,
                ),
              ),
            );
          },
        ),
        );
      },
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    int pageNumber,
    AppState appState,
    QiraatProvider qiraatProvider,
  ) {
    final selectedQiraat = qiraatProvider.selectedQiraat;
    
    if (selectedQiraat == null) {
      return _buildErrorState('لم يتم اختيار قراءة');
    }

    // Debug: Print qiraat info
    print('DEBUG: Selected qiraat: ${selectedQiraat.id}, page: $pageNumber');

    return FutureBuilder<String?>(
      future: _getPagePath(selectedQiraat.id, pageNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('DEBUG: Loading page path...');
          return _buildLoadingState();
        }
        
        if (snapshot.hasError) {
          print('DEBUG: Error loading page: ${snapshot.error}');
          return _buildErrorState('خطأ في تحميل الصفحة');
        }
        
        final imagePath = snapshot.data;
        print('DEBUG: Got image path: $imagePath');
        
        if (imagePath != null) {
          return _buildImagePage(imagePath, appState);
        } else {
          return _buildPlaceholderPage(context, pageNumber, selectedQiraat, appState);
        }
      },
    );
  }

  Future<String?> _getPagePath(String qiraatId, int pageNumber) async {
    final downloadService = DownloadService();
    final isDownloaded = await downloadService.isQiraatDownloaded(qiraatId);
    print('DEBUG: Is qiraat $qiraatId downloaded? $isDownloaded');
    
    final path = await downloadService.getPagePath(qiraatId, pageNumber);
    print('DEBUG: getPagePath returned: $path');
    return path;
  }

  Widget _buildImagePage(String imagePath, AppState appState) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20.w),
          minScale: 0.5,
          maxScale: 3.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildImageWidget(imagePath),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // Debug: Print the image path
    print('DEBUG PageViewer: Attempting to load image: $imagePath');
    
    // Handle different types of image sources
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // For GitHub/network URLs - use cached network image
      print('DEBUG PageViewer: Loading as network image: $imagePath');
      return CachedNetworkImage(
        imageUrl: imagePath,
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
                SizedBox(height: 16),
                Text(
                  'Loading page...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          print('DEBUG PageViewer: Network loading failed for $imagePath');
          print('DEBUG PageViewer: Error: $error');
          return Container(
            color: Colors.grey[900],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load page',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please check your internet connection',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (imagePath.startsWith('assets/')) {
      // For asset images
      print('DEBUG PageViewer: Loading as asset: $imagePath');
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('DEBUG PageViewer: Asset loading failed for $imagePath');
          print('DEBUG PageViewer: Error: $error');
          return _buildErrorState('فشل في تحميل صورة الصفحة');
        },
      );
    } else if (imagePath.startsWith('/')) {
      // For local file paths (mobile)
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorState('فشل في تحميل صورة الصفحة');
        },
      );
    } else {
      // Default to asset loading
      print('DEBUG PageViewer: Loading as default asset: $imagePath');
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('DEBUG PageViewer: Default asset loading failed for $imagePath');
          print('DEBUG PageViewer: Error: $error');
          return _buildErrorState('فشل في تحميل صورة الصفحة');
        },
      );
    }
  }

  Widget _buildPlaceholderPage(BuildContext context, int pageNumber, qiraat, AppState appState) {
    final localizations = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: appState.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: appState.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with surah info
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: appState.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${localizations.pageNumber} $pageNumber',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    color: appState.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${qiraat.colorCode.substring(1)}')).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    qiraat.arabicName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Amiri',
                      color: Color(int.parse('0xFF${qiraat.colorCode.substring(1)}')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Placeholder content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 64.sp,
                    color: appState.isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontSize: appState.fontSize + 4,
                      fontFamily: appState.fontFamily,
                      color: appState.isDarkMode ? Colors.white : Colors.black,
                      height: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: (appState.isDarkMode ? Colors.grey[800] : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          localizations.pageContentUnavailable,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                            color: appState.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          localizations.getEnsureQiraatDownloadedText(appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: appState.isDarkMode ? Colors.grey[400] : Colors.grey[500],
                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل الصفحة...',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Amiri',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Amiri',
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}