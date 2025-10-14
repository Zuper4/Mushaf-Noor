import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
            ],
          );
        },
      ),
    );
  }
}