import 'package:flutter/material.dart';
import 'package:final_project/userLogin_screen.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen ({super.key});

  @override
  State <StatefulWidget> createState() {
    return LoadingState();
  }
}

class LoadingState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_)=> LoginPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(), 
            ]
          )
        )
      );
  }
}