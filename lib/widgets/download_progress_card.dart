import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/qiraat.dart';

class DownloadProgressCard extends StatelessWidget {
  final Qiraat qiraat;
  final double progress;
  final String status;
  final VoidCallback? onCancel;
  final VoidCallback? onPause;

  const DownloadProgressCard({
    super.key,
    required this.qiraat,
    required this.progress,
    required this.status,
    this.onCancel,
    this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${qiraat.colorCode.substring(1)}')),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qiraat.arabicName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onPause != null)
                      IconButton(
                        icon: const Icon(Icons.pause, size: 20),
                        onPressed: onPause,
                        visualDensity: VisualDensity.compact,
                      ),
                    if (onCancel != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: onCancel,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Progress bar
            Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      '${((progress * qiraat.totalPages).round())}/${qiraat.totalPages} صفحة',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}