import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous page
          _buildControlButton(
            icon: Icons.keyboard_arrow_right,
            onPressed: () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            tooltip: 'الصفحة السابقة',
          ),
          
          // Settings
          _buildControlButton(
            icon: Icons.settings,
            onPressed: onSettingsPressed,
            tooltip: 'الإعدادات',
          ),
          
          // Qiraat selector
          _buildControlButton(
            icon: Icons.library_books,
            onPressed: onQiraatPressed,
            tooltip: 'اختيار القراءة',
          ),
          
          // Next page
          _buildControlButton(
            icon: Icons.keyboard_arrow_left,
            onPressed: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            tooltip: 'الصفحة التالية',
          ),
        ],
      ),
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