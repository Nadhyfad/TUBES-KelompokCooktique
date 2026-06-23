import 'package:flutter/material.dart';
import 'favorite_button.dart';      
import 'recipe_rating_widget.dart'; 
import 'recipe_model.dart'; // Impor model resep

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe; // Variabel penerima data dinamis

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE9),
      body: SafeArea(
        top: true,
        bottom: true,
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: true),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            physics: const AlwaysScrollableScrollPhysics(), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24, top: 20, bottom: 12),
                  child: Text("Cooktique", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF000000))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      Container(
                        height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          image: DecorationImage(image: NetworkImage(recipe.image), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)]),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
                          child: Text(recipe.category, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Row(
                          children: [
                            const FavoriteButton(), 
                            const SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: Colors.white.withValues(alpha: 0.6),
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.black),
                                onPressed: () {
                                  if (Navigator.canPop(context)) Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(recipe.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
                              child: Text("by ${recipe.author}", style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(recipe.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          recipe.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1.4),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoCard(Icons.access_time, "Cook Time", recipe.cookTime),
                          _infoCard(Icons.people_outline, "Servings", recipe.servings),
                          _infoCard(Icons.restaurant_menu, "Difficulty", recipe.difficulty),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text("Rate this recipe", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E1A0F))),
                      const SizedBox(height: 8),
                      const RecipeRatingWidget(), 
                      const SizedBox(height: 24),
                      const Text("Ingredients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E1A0F))),
                      const SizedBox(height: 10),
                      ...recipe.ingredients.map((item) => _ingredientItem(item)),
                      const SizedBox(height: 24),
                      const Text("Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E1A0F))),
                      const SizedBox(height: 12),
                      ...recipe.instructions.asMap().entries.map((entry) => _instructionItem(entry.key + 1, entry.value)),
                      const SizedBox(height: 40), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      width: 105, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: const Color(0xFFEFEAE2), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.6))),
      child: Column(children: [Icon(icon, color: const Color(0xFF5A4A42), size: 24), const SizedBox(height: 6), Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)), const SizedBox(height: 2), Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E1A0F)))]),
    );
  }

  Widget _ingredientItem(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 10.0), child: Icon(Icons.brightness_1, size: 6, color: Colors.black)), Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)))]));
  }

  Widget _instructionItem(int stepNumber, String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 12, backgroundColor: const Color(0xFF2E1A0F), child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)))]));
  }
}