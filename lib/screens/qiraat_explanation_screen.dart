import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../l10n/app_localizations.dart';

class QiraatExplanationScreen extends StatelessWidget {
  const QiraatExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward : Icons.arrow_back,
            color: const Color(0xFF2C5F2D),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              localizations.whatAreQiraats,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C5F2D),
                fontFamily: isArabic ? 'Amiri' : null,
              ),
            ),
            SizedBox(height: 16.h),

            // Main Explanation
            Text(
              localizations.qiraatsExplanation,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.8,
                color: Colors.black87,
                fontFamily: isArabic ? 'Amiri' : null,
              ),
            ),
            SizedBox(height: 24.h),

            // Riwayat Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2C5F2D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.riwayatTitle,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C5F2D),
                      fontFamily: isArabic ? 'Amiri' : null,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localizations.riwayatExplanation,
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.8,
                      color: Colors.black87,
                      fontFamily: isArabic ? 'Amiri' : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // App Feature Note
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF8B7355).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFF8B7355).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(0xFF8B7355),
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        localizations.appFeatureNote,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B7355),
                          fontFamily: isArabic ? 'Amiri' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localizations.appFeatureExplanation,
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.8,
                      color: Colors.black87,
                      fontFamily: isArabic ? 'Amiri' : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
