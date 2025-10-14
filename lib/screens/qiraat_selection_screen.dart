import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/qiraat_provider.dart';
import '../providers/download_provider.dart';
import '../providers/app_state.dart';
import '../widgets/qiraat_card.dart';
import '../widgets/download_progress_card.dart';
import '../l10n/app_localizations.dart';

class QiraatSelectionScreen extends StatelessWidget {
  const QiraatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppState>(
          builder: (context, appState, child) {
            final localizations = AppLocalizations.of(context);
            return Text(
              localizations.availableQiraats,
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer3<QiraatProvider, DownloadProvider, AppState>(
        builder: (context, qiraatProvider, downloadProvider, appState, child) {
          if (qiraatProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              // Current downloads section
              if (downloadProvider.activeDownloads.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Consumer<AppState>(
                      builder: (context, appState, child) {
                        final localizations = AppLocalizations.of(context);
                        return Text(
                          localizations.activeDownloads,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final qiraatId = downloadProvider.activeDownloads.elementAt(index);
                        final qiraat = qiraatProvider.availableQiraats
                            .firstWhere((q) => q.id == qiraatId);
                        
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: DownloadProgressCard(
                            qiraat: qiraat,
                            progress: downloadProvider.getProgress(qiraatId),
                            status: downloadProvider.getStatus(qiraatId),
                            onCancel: () {
                              downloadProvider.cancelDownload(qiraatId);
                            },
                            onPause: () {
                              downloadProvider.pauseDownload(qiraatId);
                            },
                          ),
                        );
                      },
                      childCount: downloadProvider.activeDownloads.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 32.h,
                    thickness: 1,
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
                ),
              ],

              // Available qiraats section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          final localizations = AppLocalizations.of(context);
                          return Text(
                            localizations.availableQiraats,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                            ),
                          );
                        },
                      ),
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          final localizations = AppLocalizations.of(context);
                          return TextButton.icon(
                            onPressed: () => _showStorageInfo(context, downloadProvider),
                            icon: const Icon(Icons.storage),
                            label: Text(
                              localizations.storage,
                              style: TextStyle(
                                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final qiraat = qiraatProvider.availableQiraats[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: QiraatCard(
                          qiraat: qiraat,
                          isSelected: qiraatProvider.selectedQiraat?.id == qiraat.id,
                          onTap: () async {
                            if (qiraat.isDownloaded) {
                              await qiraatProvider.selectQiraat(qiraat.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Consumer<AppState>(
                                    builder: (context, appState, child) {
                                      final localizations = AppLocalizations.of(context);
                                      return Text(
                                        localizations.qiraatDownloaded.replaceAll('{0}', 
                                          appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name),
                                        style: TextStyle(
                                          fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              _showDownloadConfirmation(
                                context,
                                qiraat,
                                qiraatProvider,
                                downloadProvider,
                              );
                            }
                          },
                          onDownload: () {
                            _showDownloadConfirmation(
                              context,
                              qiraat,
                              qiraatProvider,
                              downloadProvider,
                            );
                          },
                          onDelete: qiraat.id != 'asim_hafs'
                              ? () => _showDeleteConfirmation(
                                    context,
                                    qiraat,
                                    qiraatProvider,
                                  )
                              : null,
                        ),
                      );
                    },
                    childCount: qiraatProvider.availableQiraats.length,
                  ),
                ),
              ),

              // Info section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<AppState>(
                            builder: (context, appState, child) {
                              final localizations = AppLocalizations.of(context);
                              return Text(
                                localizations.importantInfo,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          Consumer<AppState>(
                            builder: (context, appState, child) {
                              final localizations = AppLocalizations.of(context);
                              return Text(
                                localizations.qiraatInfo,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: appState.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                                  fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDownloadConfirmation(
    BuildContext context,
    qiraat,
    QiraatProvider qiraatProvider,
    DownloadProvider downloadProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => Consumer<AppState>(
        builder: (context, appState, child) {
          final localizations = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(
              localizations.downloadQiraat,
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                fontSize: 18.sp,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${localizations.downloadConfirmation} ${appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name}?',
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16.sp, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Text(
                      'Size: ${qiraatProvider.getQiraatSize(qiraat.id).toStringAsFixed(1)} MB approximately',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.storage, size: 16.sp, color: Colors.grey[600]),
                    SizedBox(width: 8.w),
                    Text(
                      '606 pages',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localizations.cancel,
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await downloadProvider.startDownload(
                    qiraat.id, 
                    qiraat.name,
                    onComplete: () async {
                      // Update the qiraat provider when download completes
                      await qiraatProvider.refreshDownloadStatuses();
                    },
                  );
                },
                child: Text(
                  localizations.download,
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    qiraat,
    QiraatProvider qiraatProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => Consumer<AppState>(
        builder: (context, appState, child) {
          final localizations = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(
              localizations.deleteQiraat,
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                fontSize: 18.sp,
              ),
            ),
            content: Text(
              localizations.deleteConfirmation.replaceAll('{0}', 
                appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name),
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                fontSize: 16.sp,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localizations.cancel,
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await qiraatProvider.deleteQiraat(qiraat.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Consumer<AppState>(
                        builder: (context, appState, child) {
                          final localizations = AppLocalizations.of(context);
                          return Text(
                            localizations.qiraatDeleted.replaceAll('{0}', 
                              appState.languageCode == 'ar' ? qiraat.arabicName : qiraat.name),
                            style: TextStyle(
                              fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  localizations.delete,
                  style: TextStyle(
                    fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStorageInfo(BuildContext context, DownloadProvider downloadProvider) {
    showDialog(
      context: context,
      builder: (context) => Consumer<AppState>(
        builder: (context, appState, child) {
          final localizations = AppLocalizations.of(context);
          return AlertDialog(
            title: Text(
              localizations.storageInfoTitle,
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            ),
            content: FutureBuilder<double>(
              future: downloadProvider.getTotalStorageUsed(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final totalSize = snapshot.data ?? 0.0;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.getTotalStorageUsedText(totalSize.toStringAsFixed(1)),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      localizations.estimatedSizePerQiraat,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
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
      ),
    );
  }
}