import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/qiraat_provider.dart';
import 'providers/download_provider.dart';
import 'providers/audio_provider.dart';
import 'services/ayah_bounds_service.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MushafNoorApp());
}

class MushafNoorApp extends StatefulWidget {
  const MushafNoorApp({super.key});

  @override
  State<MushafNoorApp> createState() => _MushafNoorAppState();
}

class _MushafNoorAppState extends State<MushafNoorApp> {
  bool _isInitialized = false;

  Future<void> _initializeApp() async {
    // Initialize services
    await AyahBoundsService().initialize();
    
    setState(() {
      _isInitialized = true;
    });
  }

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
            ChangeNotifierProvider(create: (_) => AudioProvider()),
          ],
          child: MaterialApp(
            title: 'Mushaf Noor',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system, // Use system preference instead of forcing dark
            home: _isInitialized 
                ? Consumer<AppState>(
                    builder: (context, appState, child) {
                      return MaterialApp(
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
                  )
                : SplashScreen(
                    onInitializationComplete: _initializeApp,
                  ),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}