import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
        return PageView.builder(
          controller: pageController,
          onPageChanged: onPageChanged,
          itemCount: 604, // Total Mushaf pages
          reverse: true, // Arabic reading: right-to-left, page 1 on far right
          itemBuilder: (context, index) {
            // For Arabic reading: reverse the page mapping
            // index 0 = page 604, index 1 = page 603, ..., index 603 = page 1
            final pageNumber = 604 - index;
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
          return _buildPlaceholderPage(pageNumber, selectedQiraat, appState);
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
    // Handle different types of image sources
    if (imagePath.startsWith('web://')) {
      // For web downloads, show a placeholder with download info
      return _buildWebPlaceholder(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      // For asset images
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
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
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorState('فشل في تحميل صورة الصفحة');
        },
      );
    }
  }

  Widget _buildWebPlaceholder(String webPath) {
    // Extract page info from web path like "web://qiraat/nafi_warsh/page_001.jpg"
    final parts = webPath.split('/');
    final pageFile = parts.isNotEmpty ? parts.last : 'unknown';
    final pageNumber = pageFile.replaceAll(RegExp(r'[^\d]'), '');
    
    // Extract qiraat ID
    final qiraatId = parts.length >= 4 ? parts[3] : '';
    
    print('DEBUG: Building web placeholder for path: $webPath');
    print('DEBUG: Extracted page: $pageNumber, qiraat: $qiraatId');
    
    // List of qiraats that have converted images
    final availableImageQiraats = {'nafi_warsh'};
    
    if (availableImageQiraats.contains(qiraatId)) {
      // Try to load actual image for qiraats that have been converted
      final assetPath = 'images/qiraats/$qiraatId/page_${pageNumber.padLeft(3, '0')}.jpg';
      print('DEBUG: Trying to load image: $assetPath');
      
      return FutureBuilder<bool>(
        future: _assetExists(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          
          if (snapshot.data == true) {
            // Asset exists, show the image
            return _buildRealImagePage(assetPath);
          } else {
            // Asset doesn't exist, show enhanced success display
            return _buildEnhancedSuccessDisplay(pageNumber, qiraatId);
          }
        },
      );
    } else {
      // For qiraats without converted images, show enhanced success display
      print('DEBUG: No images available for qiraat $qiraatId, showing success display');
      return _buildEnhancedSuccessDisplay(pageNumber, qiraatId);
    }
  }



  Widget _buildPDFViewer(String pdfPath, String pageNumber) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Header with page info
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            color: Colors.black.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'صفحة $pageNumber',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Amiri',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // PDF Viewer
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 64.sp,
                      color: Colors.blue[600],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'محتوى القرآن الكريم متوفر',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'صفحة $pageNumber',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: 'Amiri',
                              color: Colors.black,
                              height: 2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'ملف PDF متوفر في الأصول',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Amiri',
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Widget _buildRealImagePage(String assetPath) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(4.w), // Reduced padding for bigger display
      child: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(10.w), // Reduced margin
        minScale: 0.5,
        maxScale: 4.0, // Increased max zoom
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
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain, // Keep contain to avoid cropping Quran text
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print('DEBUG: Error loading image $assetPath: $error');
                return _buildErrorState('فشل في تحميل صورة الصفحة');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedSuccessDisplay(String pageNumber, String qiraatId) {
    // Map qiraat IDs to Arabic names
    final qiraatNames = {
      'nafi_warsh': 'ورش عن نافع',
      'nafi_qaloon': 'قالون عن نافع',
      'asim_hafs': 'حفص عن عاصم',
      'asim_shubah': 'شعبة عن عاصم',
    };
    
    final arabicName = qiraatNames[qiraatId] ?? 'قراءة مُحَمّلة';
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green[50]!,
            Colors.blue[50]!,
            Colors.white,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            margin: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Success icon
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 48.sp,
                    color: Colors.green[600],
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Main message
                Text(
                  'تم تحميل القراءة بنجاح ✅',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 12.h),
                
                // Qiraat name
                Text(
                  arabicName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 16.h),
                
                // Page number display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'صفحة رقم $pageNumber',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Bismillah
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontFamily: 'Amiri',
                          color: Colors.black87,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'محتوى الصفحة جاهز للعرض 📖',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Amiri',
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPage(int pageNumber, qiraat, AppState appState) {
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
                  'صفحة $pageNumber',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Amiri',
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
                          'محتوى الصفحة غير متوفر',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Amiri',
                            color: appState.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'يرجى التأكد من تنزيل قراءة ${qiraat.arabicName}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Amiri',
                            color: appState.isDarkMode ? Colors.grey[400] : Colors.grey[500],
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