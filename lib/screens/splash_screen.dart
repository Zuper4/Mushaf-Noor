import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({
    Key? key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Hide status bar for full screen effect
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // Start initialization immediately
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash for at least 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    widget.onInitializationComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/icons/app_loading.png'),
            fit: BoxFit.cover, // This will make it fill the entire screen!
          ),
        ),
      ),
    );
  }
}