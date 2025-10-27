import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/qiraat.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class QiraatCard extends StatefulWidget {
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
  State<QiraatCard> createState() => _QiraatCardState();
}

class _QiraatCardState extends State<QiraatCard> {
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          _isOnline = result == ConnectivityResult.wifi || 
                      result == ConnectivityResult.mobile ||
                      result == ConnectivityResult.ethernet;
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isOnline = connectivityResult == ConnectivityResult.wifi || 
                    connectivityResult == ConnectivityResult.mobile ||
                    connectivityResult == ConnectivityResult.ethernet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.isSelected ? 4 : 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: widget.isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: InkWell(
          onTap: widget.onTap,
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
                        color: Color(int.parse('0xFF${widget.qiraat.colorCode.substring(1)}')),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // WiFi indicator
                    if (_isOnline)
                      Icon(Icons.wifi, color: Colors.green, size: 20.sp),
                    SizedBox(width: 8.w),
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
                                    appState.languageCode == 'ar' ? widget.qiraat.arabicName : widget.qiraat.name,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                      color: widget.isSelected ? Theme.of(context).primaryColor : null,
                                    ),
                                  ),
                                  Text(
                                    appState.languageCode == 'ar' ? widget.qiraat.name : widget.qiraat.arabicName,
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
                    // Info button
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                      tooltip: 'Info',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Consumer<AppState>(
                              builder: (context, appState, child) {
                                final localizations = AppLocalizations.of(context);
                                return AlertDialog(
                                  title: Text(
                                    appState.languageCode == 'ar' ? 'الوصول للقراءات' : 'Qiraat Access',
                                    style: TextStyle(
                                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                    ),
                                  ),
                                  content: Text(
                                    appState.languageCode == 'ar' 
                                      ? 'أيقونة الواي فاي الخضراء تعني أنه يمكنك الوصول لهذه القراءة عبر الإنترنت بدون تنزيل. يمكنك أيضاً تنزيلها للاستخدام بدون إنترنت.'
                                      : 'A green WiFi icon means you can access this Qiraat online without downloading. You can also download it for offline use.',
                                    style: TextStyle(
                                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(dialogContext).pop(),
                                      child: Text(
                                        localizations.ok,
                                        style: TextStyle(
                                          fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    // Status and actions
                    Column(
                      children: [
                        if (widget.isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 24.sp,
                          )
                        else if (widget.qiraat.isDownloaded)
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 24.sp,
                          )
                        else if (_isOnline)
                          Icon(
                            Icons.cloud_download,
                            color: Colors.grey,
                            size: 24.sp,
                          )
                        else
                          Icon(
                            Icons.cloud_off,
                            color: Colors.red,
                            size: 24.sp,
                          ),
                        SizedBox(height: 8.h),
                        // Action buttons
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'download':
                                widget.onDownload?.call();
                                break;
                              case 'delete':
                                widget.onDelete?.call();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            if (!widget.qiraat.isDownloaded && widget.onDownload != null)
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
                            if (widget.qiraat.isDownloaded && widget.onDelete != null)
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
                      widget.qiraat.description,
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
                if (widget.qiraat.downloadProgress > 0 && widget.qiraat.downloadProgress < 1)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: widget.qiraat.downloadProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          return Text(
                            'Downloading: ${(widget.qiraat.downloadProgress * 100).round()}%',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
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
                        widget.qiraat.isDownloaded ? Icons.storage : Icons.cloud,
                        size: 14.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          final text = appState.languageCode == 'ar'
                              ? (widget.qiraat.isDownloaded 
                                  ? 'محمل محلياً - ${widget.qiraat.totalPages} صفحة'
                                  : 'غير محمل - ${widget.qiraat.totalPages} صفحة')
                              : (widget.qiraat.isDownloaded 
                                  ? 'Downloaded - ${widget.qiraat.totalPages} pages'
                                  : 'Not downloaded - ${widget.qiraat.totalPages} pages');
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