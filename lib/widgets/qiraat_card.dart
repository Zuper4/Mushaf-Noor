import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/qiraat.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class QiraatCard extends StatelessWidget {
  final Qiraat qiraat;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const QiraatCard({
    super.key,
    required this.qiraat,
    required this.isSelected,
    required this.onTap,
    this.onDownload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Color indicator
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: Color(int.parse('0xFF${qiraat.colorCode.substring(1)}')),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    
                    // Qiraat name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<AppState>(
                            builder: (context, appState, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                      color: isSelected ? Theme.of(context).primaryColor : null,
                                    ),
                                  ),
                                  Text(
                                    appState.languageCode == 'ar' ? qiraat.name : qiraat.arabicName,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                      fontFamily: appState.languageCode == 'en' ? 'Amiri' : null,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Status and actions
                    Column(
                      children: [
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 24.sp,
                          )
                        else if (qiraat.isDownloaded)
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 24.sp,
                          )
                        else
                          Icon(
                            Icons.cloud_download,
                            color: Colors.grey,
                            size: 24.sp,
                          ),
                        
                        SizedBox(height: 8.h),
                        
                        // Action buttons
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'download':
                                onDownload?.call();
                                break;
                              case 'delete':
                                onDelete?.call();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            if (!qiraat.isDownloaded)
                              PopupMenuItem(
                                value: 'download',
                                child: Consumer<AppState>(
                                  builder: (context, appState, child) {
                                    final localizations = AppLocalizations.of(context);
                                    return Row(
                                      children: [
                                        const Icon(Icons.download),
                                        const SizedBox(width: 8),
                                        Text(
                                          localizations.download, 
                                          style: TextStyle(
                                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            if (qiraat.isDownloaded && onDelete != null)
                              PopupMenuItem(
                                value: 'delete',
                                child: Consumer<AppState>(
                                  builder: (context, appState, child) {
                                    final localizations = AppLocalizations.of(context);
                                    return Row(
                                      children: [
                                        const Icon(Icons.delete, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(
                                          localizations.delete, 
                                          style: TextStyle(
                                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                          ],
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey[600],
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                // Description
                Consumer<AppState>(
                  builder: (context, appState, child) {
                    return Text(
                      qiraat.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                        fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 12.h),
                
                // Download progress or status
                if (qiraat.downloadProgress > 0 && qiraat.downloadProgress < 1)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: qiraat.downloadProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          final localizations = AppLocalizations.of(context);
                          final text = appState.languageCode == 'ar' 
                              ? 'تنزيل: ${(qiraat.downloadProgress * 100).round()}%'
                              : 'Downloading: ${(qiraat.downloadProgress * 100).round()}%';
                          return Text(
                            text,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Icon(
                        qiraat.isDownloaded ? Icons.storage : Icons.cloud,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          final text = appState.languageCode == 'ar'
                              ? (qiraat.isDownloaded 
                                  ? 'محمل محلياً - ${qiraat.totalPages} صفحة'
                                  : 'غير محمل - ${qiraat.totalPages} صفحة')
                              : (qiraat.isDownloaded 
                                  ? 'Downloaded - ${qiraat.totalPages} pages'
                                  : 'Not downloaded - ${qiraat.totalPages} pages');
                          return Text(
                            text,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}