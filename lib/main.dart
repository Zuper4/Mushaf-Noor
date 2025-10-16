import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/qiraat_provider.dart';
import 'providers/download_provider.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MushafNoorApp());
}

class MushafNoorApp extends StatelessWidget {
  const MushafNoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppState()),
            ChangeNotifierProvider(create: (_) => QiraatProvider()),
            ChangeNotifierProvider(create: (_) => DownloadProvider()),
          ],
          child: Consumer<AppState>(
            builder: (context, appState, child) {
              return MaterialApp(
                title: 'Mushaf Noor',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                home: Directionality(
                  textDirection: appState.languageCode == 'ar' 
                      ? TextDirection.rtl 
                      : TextDirection.ltr,
                  child: const HomeScreen(),
                ),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}