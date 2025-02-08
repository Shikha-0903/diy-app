import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'pageview_screens.dart';
import "bottom_navigation/Navigation.dart";

class splash_screen extends StatelessWidget {
  const splash_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(child: Lottie.asset('animations/Animation - 1718900860691.json',)),
      nextScreen: next(),
      splashIconSize: 400,
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}

class splash_screen1 extends StatelessWidget {
  const splash_screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(child: Lottie.asset('animations/Animation - 1718900860691.json',)),
      nextScreen: HomePage(),
      splashIconSize: 400,
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}