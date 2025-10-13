import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'صفحة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$currentPage',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'من',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '$totalPages',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}