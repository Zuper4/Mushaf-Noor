import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';
import '../models/surah.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int)? onPageSelected;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final localizations = AppLocalizations.of(context);
        return GestureDetector(
          onTap: onPageSelected != null ? () => _showPageSelector(context, localizations, appState) : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.pageLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
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
                  localizations.ofLabel,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
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
          ),
        );
      },
    );
  }

  void _showPageSelector(BuildContext context, AppLocalizations localizations, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  localizations.selectPage,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: 20.h + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: totalPages,
                  itemBuilder: (context, index) {
                    final pageNum = index + 1;
                    final surahsOnPage = _getSurahsStartingOnPage(pageNum);
                    final isCurrentPage = pageNum == currentPage;
                    
                    return ListTile(
                      selected: isCurrentPage,
                      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      leading: Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: isCurrentPage 
                              ? Theme.of(context).primaryColor 
                              : Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            '$pageNum',
                            style: TextStyle(
                              color: isCurrentPage ? Colors.white : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      title: surahsOnPage.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: surahsOnPage.map((surah) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 4.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          surah.getDisplayName(appState.languageCode),
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        surah.nameArabic,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Amiri',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        onPageSelected?.call(pageNum);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Surah> _getSurahsStartingOnPage(int pageNumber) {
    return Surah.allSurahs.where((surah) => surah.startPage == pageNumber).toList();
  }
}