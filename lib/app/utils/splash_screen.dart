import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: 250,
            height: 250,
            child: Lottie.asset("assets/lottie/hello.json"),
          ),
        ),
      ),
    );
  }
}
