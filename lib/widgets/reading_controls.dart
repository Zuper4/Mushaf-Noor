import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ReadingControls extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onSettingsPressed;
  final VoidCallback onQiraatPressed;
  final VoidCallback onMicPressed;

  const ReadingControls({
    super.key,
    required this.pageController,
    required this.onSettingsPressed,
    required this.onQiraatPressed,
    required this.onMicPressed,
  });

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
              ),
              
              // Settings
              _buildControlButton(
                icon: Icons.settings,
                onPressed: onSettingsPressed,
                tooltip: appState.languageCode == 'ar' ? 'الإعدادات' : 'Settings',
              ),
              
              // Mic button (voice recording/playback)
              _buildControlButton(
                icon: Icons.mic,
                onPressed: onMicPressed,
                tooltip: appState.languageCode == 'ar' ? 'تشغيل الصوت' : 'Play Audio',
                isPrimary: true, // Make it stand out
              ),
              
              // Qiraat selector
              _buildControlButton(
                icon: Icons.library_books,
                onPressed: onQiraatPressed,
                tooltip: appState.languageCode == 'ar' ? 'اختيار القراءة' : 'Select Qiraat',
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
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary 
            ? Colors.green.withOpacity(0.7)  // Highlight mic button
            : Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: isPrimary ? 28.sp : 24.sp,  // Slightly larger mic icon
        ),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.all(12.w),
      ),
    );
  }
}