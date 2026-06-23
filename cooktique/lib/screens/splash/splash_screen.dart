import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'loading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoadingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE8E1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              "Cooktique",
              style: TextStyle(
                color: Color(0xFF3C2415),
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Discover & Share Amazing Recipes",
              style: TextStyle(
                color: Color(0xFF697282),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }
}