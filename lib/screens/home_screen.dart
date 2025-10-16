import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/qiraat_provider.dart';
import '../models/surah.dart';
import 'reading_screen.dart';
import 'qiraat_selection_screen.dart';
import 'settings_screen.dart';

import '../widgets/custom_app_bar.dart';
import '../services/pdf_service.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        title: Consumer<AppState>(
          builder: (context, appState, child) {
            final localizations = AppLocalizations.of(context);
            return Text(
              localizations.appTitle,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            );
          },
        ),
        actions: [
          // Qiraat Status and Selection
          Consumer2<AppState, QiraatProvider>(
            builder: (context, appState, qiraatProvider, child) {
              final localizations = AppLocalizations.of(context);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QiraatSelectionScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.menu_book,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              qiraatProvider.selectedQiraat?.name ?? 'Hafs',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${qiraatProvider.availableQiraats.length} available',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 8.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Language Toggle
          Consumer<AppState>(
            builder: (context, appState, child) {
              return GestureDetector(
                onTap: () {
                  appState.toggleLanguage();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appState.languageCode == 'en' ? 'عربي' : 'EN',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.language,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final localizations = AppLocalizations.of(context);
          
          return Column(
            children: [
              // Continue Reading Banner (if applicable)
              _buildContinueReadingBanner(context, appState),
              
              // Search Bar
              Container(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search surahs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
              
              // Surahs List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: Surah.allSurahs.length,
                  itemBuilder: (context, index) {
                    final surah = Surah.allSurahs[index];
                    return _buildSurahCard(context, surah, appState);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContinueReadingBanner(BuildContext context, AppState appState) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.continueReading,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${localizations.pageNumber} ${appState.currentPage}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReadingScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, Surah surah, AppState appState) {
    final localizations = AppLocalizations.of(context);
    
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: () async {
          final qiraatProvider = context.read<QiraatProvider>();
          final currentQiraat = qiraatProvider.selectedQiraat?.id ?? 'hafs';
          
          // Always use ReadingScreen instead of PDFReaderScreen for web compatibility
          appState.goToPage(surah.startPage);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ReadingScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Surah Number
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '${surah.number}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Surah Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.getDisplayName(appState.languageCode),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      appState.languageCode == 'ar' 
                          ? surah.englishName
                          : surah.nameArabic,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontFamily: appState.languageCode == 'ar' ? null : 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Surah Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: surah.revelationType == 'Meccan'
                          ? Colors.orange[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      surah.revelationType,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: surah.revelationType == 'Meccan'
                            ? Colors.orange[700]
                            : Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${surah.numberOfAyahs} verses',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



}