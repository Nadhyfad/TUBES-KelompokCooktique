import 'package:flutter/material.dart';

class RecipeRatingWidget extends StatefulWidget {
  final int initialRating;
  const RecipeRatingWidget({super.key, this.initialRating = 4});

  @override
  State<RecipeRatingWidget> createState() => _RecipeRatingWidgetState();
}

class _RecipeRatingWidgetState extends State<RecipeRatingWidget> {
  late int userRating;

  @override
  void initState() {
    super.initState();
    userRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  userRating = index + 1;
                });
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  index < userRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Terima kasih! Rating $userRating bintang dikirim.')),
            );
          },
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF9E9A94),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}