import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppState>(
          builder: (context, appState, child) {
            final localizations = AppLocalizations.of(context);
            return Text(
              localizations.settings,
              style: TextStyle(
                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final localizations = AppLocalizations.of(context);
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text(
                    localizations.darkMode,
                    style: TextStyle(
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  ),
                  subtitle: Text(
                    localizations.darkModeDesc,
                    style: TextStyle(
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  ),
                  trailing: Switch(
                    value: appState.isDarkMode,
                    onChanged: (value) {
                      appState.setDarkMode(value);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Card(
                child: ListTile(
                  leading: Icon(Icons.language),
                  title: Text(
                    localizations.language,
                    style: TextStyle(
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  ),
                  subtitle: Text(
                    appState.languageCode == 'en' 
                        ? localizations.english 
                        : localizations.arabic,
                    style: TextStyle(
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  ),
                  trailing: Switch(
                    value: appState.languageCode == 'ar',
                    onChanged: (value) {
                      appState.toggleLanguage();
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Card(
                child: ListTile(
                  leading: Icon(Icons.cleaning_services),
                  title: Text(
                    appState.languageCode == 'ar' 
                        ? 'مسح ذاكرة التخزين المؤقت' 
                        : 'Clear Cache',
                    style: TextStyle(
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  ),
                  subtitle: Text(
                    appState.languageCode == 'ar'
                        ? 'مسح الصور المخزنة مؤقتاً لتحميل أحدث النسخ'
                        : 'Clear cached images to load latest versions',
                    style: TextStyle(
                      fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                  onTap: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          appState.languageCode == 'ar'
                              ? 'مسح ذاكرة التخزين المؤقت'
                              : 'Clear Cache',
                          style: TextStyle(
                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                          ),
                        ),
                        content: Text(
                          appState.languageCode == 'ar'
                              ? 'هل تريد مسح جميع الصور المخزنة مؤقتاً؟ سيتم تحميل الصور من جديد عند عرضها.'
                              : 'Do you want to clear all cached images? Images will be reloaded when viewed.',
                          style: TextStyle(
                            fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              appState.languageCode == 'ar' ? 'إلغاء' : 'Cancel',
                              style: TextStyle(
                                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              appState.languageCode == 'ar' ? 'مسح' : 'Clear',
                              style: TextStyle(
                                fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      // Show loading indicator
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      try {
                        // Clear the cache
                        await DefaultCacheManager().emptyCache();
                        
                        // Close loading dialog
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                appState.languageCode == 'ar'
                                    ? 'تم مسح ذاكرة التخزين المؤقت بنجاح'
                                    : 'Cache cleared successfully',
                                style: TextStyle(
                                  fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        // Close loading dialog
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                appState.languageCode == 'ar'
                                    ? 'حدث خطأ أثناء مسح ذاكرة التخزين المؤقت'
                                    : 'Error clearing cache',
                                style: TextStyle(
                                  fontFamily: appState.languageCode == 'ar' ? 'Amiri' : null,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}