import 'package:flutter/material.dart';
import 'package:final_project/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Banking App',
      debugShowCheckedModeBanner: false,
      theme : ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white)),
      home: const LoadingScreen(),
    );
  }
}