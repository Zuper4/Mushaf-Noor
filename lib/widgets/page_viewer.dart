import 'package:flutter/material.dart';
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
          itemBuilder: (context, index) {
            final pageNumber = index + 1;
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

    return FutureBuilder<String?>(
      future: _getPagePath(selectedQiraat.id, pageNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        
        if (snapshot.hasError) {
          return _buildErrorState('خطأ في تحميل الصفحة');
        }
        
        final imagePath = snapshot.data;
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
    return await downloadService.getPagePath(qiraatId, pageNumber);
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
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorState('فشل في تحميل صورة الصفحة');
                },
              ),
            ),
          ),
        ),
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