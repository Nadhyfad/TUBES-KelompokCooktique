import 'package:flutter/material.dart';
import 'recipe_notfound.dart';
import 'recipe_detail_screen.dart';
import 'recipe_model.dart'; 

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  
  // Tampilkan semua data dari model sebagai "History" di awal
  List<Recipe> filteredRecipes = dummyRecipes;

  void searchRecipe() {
    final keyword = searchController.text.trim().toLowerCase();
    
    if (keyword.isEmpty) {
      setState(() => filteredRecipes = dummyRecipes);
      return;
    }

    final results = dummyRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(keyword) || 
             recipe.category.toLowerCase().contains(keyword);
    }).toList();

    if (results.isEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipeNotFoundScreen()));
    } else {
      setState(() => filteredRecipes = results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECE8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xffECE8E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff6C6F7F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onSubmitted: (_) => searchRecipe(), 
              decoration: InputDecoration(
                hintText: "Search recipes...",
                prefixIcon: const Icon(Icons.search, color: Color(0xff9A9AAA)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Color(0xff9A9AAA)),
                  onPressed: searchRecipe,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: filteredRecipes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .75, crossAxisSpacing: 12, mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(image: NetworkImage(recipe.image), fit: BoxFit.cover),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                              child: Text(recipe.category, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                            const SizedBox(height: 8),
                            Text(recipe.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}