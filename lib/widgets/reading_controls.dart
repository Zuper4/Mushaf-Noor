import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ReadingControls extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onSettingsPressed;
  final VoidCallback onQiraatPressed;

  const ReadingControls({
    super.key,
    required this.pageController,
    required this.onSettingsPressed,
    required this.onQiraatPressed,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
        ),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.all(12.w),
      ),
    );
  }
}