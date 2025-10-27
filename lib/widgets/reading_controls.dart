import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ReadingControls extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onQiraatPressed;
  final VoidCallback onMicPressed;

  const ReadingControls({
    super.key,
    required this.pageController,
    required this.onQiraatPressed,
    required this.onMicPressed,
  });

  void _showTranslationComingSoon(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          appState.languageCode == 'ar' ? 'الترجمة' : 'Translation',
          style: TextStyle(
            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
          ),
        ),
        content: Text(
          appState.languageCode == 'ar' 
              ? 'الترجمة ستأتي قريباً إن شاء الله' 
              : 'Translation coming soon inshaAllah',
          style: TextStyle(
            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appState.languageCode == 'ar' ? 'حسناً' : 'OK',
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous page (for Arabic reading, this goes RIGHT)
              _buildControlButton(
                icon: Icons.keyboard_arrow_left, // Left arrow for previous in Arabic
                onPressed: () {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                tooltip: appState.languageCode == 'ar' ? 'الصفحة السابقة' : 'Previous Page',
                appState: appState,
              ),
              
              // Translation button
              _buildControlButton(
                icon: Icons.translate,
                onPressed: () {
                  _showTranslationComingSoon(context, appState);
                },
                tooltip: appState.languageCode == 'ar' ? 'الترجمة' : 'Translation',
                appState: appState,
              ),
              
              // Play audio button
              _buildControlButton(
                icon: Icons.play_circle_outline,
                onPressed: onMicPressed,
                tooltip: appState.languageCode == 'ar' ? 'تشغيل الصوت' : 'Play Audio',
                isPrimary: true, // Make it stand out
                appState: appState,
              ),
              
              // Qiraat selector
              _buildControlButton(
                icon: Icons.library_books,
                onPressed: onQiraatPressed,
                tooltip: appState.languageCode == 'ar' ? 'اختيار الرواية' : 'Select Riwayat',
                appState: appState,
              ),
              
              // Next page (for Arabic reading, this goes LEFT)
              _buildControlButton(
                icon: Icons.keyboard_arrow_right, // Right arrow for next in Arabic
                onPressed: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                tooltip: appState.languageCode == 'ar' ? 'الصفحة التالية' : 'Next Page',
                appState: appState,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required AppState appState,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary 
            ? Colors.green.withOpacity(0.7)  // Highlight mic button
            : (appState.isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: appState.isDarkMode ? Colors.white : Colors.white,
          size: isPrimary ? 28.sp : 24.sp,  // Slightly larger mic icon
        ),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.all(12.w),
      ),
    );
  }
}