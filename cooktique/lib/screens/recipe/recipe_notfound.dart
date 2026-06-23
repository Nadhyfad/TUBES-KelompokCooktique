import 'package:flutter/material.dart';

class RecipeNotFoundScreen extends StatelessWidget {
  const RecipeNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECE8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xffECE8E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff3C2415),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TextField(
              decoration: InputDecoration(
                hintText: "es podeng",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xffD4C5B0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.search_off,
                size: 40,
                color: Color(0xff3C2415),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Recipe not found",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xff3C2415),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}