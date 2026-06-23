import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final bool initialFavorite;
  const FavoriteButton({super.key, this.initialFavorite = false});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white.withValues(alpha: 0.6),
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.black,
        ),
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite;
          });
          // Integrasikan ke API / Database lokal di sini jika diperlukan
        },
      ),
    );
  }
}