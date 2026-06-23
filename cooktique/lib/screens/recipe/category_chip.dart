import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;

  const CategoryChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xffC4B5A0),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xff3C2415),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}