import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../auth/login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int activeDot = 0;
  Timer? _dotTimer;

  @override
  void initState() {
    super.initState();

    // Animasi loading dots
    _dotTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        if (!mounted) return;

        setState(() {
          activeDot = (activeDot + 1) % 3;
        });
      },
    );

    // Pindah ke Login Screen setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: activeDot == index ? 1.0 : 0.3,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Color(0xFF3B1D14),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE8E1),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Logo
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0xFF3B1D14),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 50,
                    offset: Offset(0, 4),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/chef_hat.svg',
                  width: 58,
                  height: 58,
                ),
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'Cooktique',
              style: TextStyle(
                color: Color(0xFF3C2415),
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Discover & Share Amazing Recipes',
              style: TextStyle(
                color: Color(0xFF697282),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),

            const Spacer(),

            // Loading dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDot(0),
                const SizedBox(width: 8),
                buildDot(1),
                const SizedBox(width: 8),
                buildDot(2),
              ],
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}