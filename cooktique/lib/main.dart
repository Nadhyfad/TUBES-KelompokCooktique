import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const CooktiqueApp());
}

class CooktiqueApp extends StatelessWidget {
  const CooktiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cooktique',
      home: const SplashScreen(),
    );
  }
}