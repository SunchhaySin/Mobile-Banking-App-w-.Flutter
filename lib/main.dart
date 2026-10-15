import 'package:flutter/material.dart';
import 'package:final_project/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen =
        MediaQuery.sizeOf(context).width > 450; // for mobile phones

    return MaterialApp(
      title: 'Mobile Banking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      builder: (context, child) {
        // Constrain the width and height of the app when opened on bigger screens (web)
        if (isLargeScreen) {
          return MobileFrameWrapper(child: child ?? const SizedBox());
        }

        return child ?? const SizedBox();
      },
      home: const LoadingScreen(),
    );
  }
}

class MobileFrameWrapper extends StatelessWidget {
  final Widget child;
  const MobileFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), 
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400, 
            maxHeight: 850, 
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade800, width: 4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: child, 
          ),
        ),
      ),
    );
  }
}