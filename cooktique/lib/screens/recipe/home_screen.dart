import 'package:flutter/material.dart';
import 'recipe_model.dart'; 
import 'recipe_detail_screen.dart'; 

import '../profile/profile_screen.dart'; 
import 'search_screen.dart'; 
import 'package:cooktique/screens/pantry/pantry_screen.dart';
import 'package:cooktique/screens/recipe/create_recipe_menu_screen.dart';
import 'package:cooktique/screens/assistant/ai_assistant_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool showSuccessSnackbar;
  const HomeScreen({super.key, this.showSuccessSnackbar = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = ""; 
  String selectedTab = "Regular";

  final List<String> categories = [
    "Pasta",
    "Healthy",
    "Quick",
    "Asian",
    "Dessert",
    "Vegetarian",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.showSuccessSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Recipe uploaded successfully! 🎉',
              style: TextStyle(fontFamily: 'Inter', color: Colors.white),
            ),
            backgroundColor: const Color(0xFF3C2415),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = dummyRecipes.where((recipe) {
      if (selectedCategory.isNotEmpty) {
        return recipe.category == selectedCategory || recipe.title.contains(selectedCategory);
      }
      
      if (selectedTab == "Signature") {
        return recipe.category == "Signature"; 
      }
      
      return recipe.category == "Regular" || recipe.category == "Popular";
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFECE8E1),
      
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 16,
        notchMargin: 10,
        padding: EdgeInsets.zero,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
        ),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _navItem(Icons.home_filled, "Home", true)),
                Expanded(child: _navItem(Icons.kitchen_outlined, "Pantry", false)),
                const SizedBox(width: 68), 
                Expanded(child: _navItem(Icons.add_box_outlined, "Create", false)),
                Expanded(child: _navItem(Icons.person_outline, "Profile", false)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
      width: 68,
      height: 68,
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF321B11),
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: () {
          // Sekarang kita memanggil AiAssistantScreen (UI), bukan Service-nya
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AiAssistantScreen()),
          );
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 28),
            Text(
              "AI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Cooktique',
                  style: TextStyle(
                    color: Color(0xFF3C2415),
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hi, Agung Ramadhan\nDiscover delicious recipe and signature menu',
                  style: TextStyle(
                    color: Color(0xFF6C6F7F),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  readOnly: true, 
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(), 
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "Search for recipes or accounts...",
                    hintStyle: const TextStyle(
                      color: Color(0xFFA0A3B1),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFA0A3B1)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.80),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        width: 1.36,
                        color: Color(0x4CC4B5A0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        width: 1.36,
                        color: Color(0xFF3C2415),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Popular Searches',
                  style: TextStyle(
                    color: Color(0xFF3C2415),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
                    stops: [0.0, 0.04, 0.96, 1.0], 
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20), 
                    child: Row(
                      children: categories.map((e) {
                        final isSelected = e == selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = isSelected ? "" : e; 
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: ShapeDecoration(
                              color: isSelected 
                                  ? const Color(0xFF3C2415) 
                                  : Colors.white.withOpacity(0.90),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.36,
                                  color: isSelected ? const Color(0xFF3C2415) : const Color(0x66C4B5A0),
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                  spreadRadius: -1,
                                ),
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF3C2415),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.43,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Recommended for You",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C2415),
                    fontFamily: 'Inter',
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    selectedTab == "Regular" && selectedCategory.isEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF685B4F),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {},
                            child: const Text("Regular", style: TextStyle(color: Colors.white)),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF685B4F)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedTab = "Regular";
                                selectedCategory = ""; 
                              });
                            },
                            child: const Text("Regular", style: TextStyle(color: Color(0xFF685B4F))),
                          ),
                    const SizedBox(width: 10),
                    selectedTab == "Signature" && selectedCategory.isEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF685B4F),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {},
                            child: const Text("Signature", style: TextStyle(color: Colors.white)),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF685B4F)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedTab = "Signature";
                                selectedCategory = ""; 
                              });
                            },
                            child: const Text("Signature", style: TextStyle(color: Color(0xFF685B4F))),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
                    stops: [0.0, 0.05, 0.95, 1.0], 
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  height: 390,
                  child: filteredRecipes.isEmpty
                      ? const Center(
                          child: Text(
                            "No recipes found in this category.",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF6C6F7F),
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20), 
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                                  ),
                                );
                              },
                              child: Container(
                                width: 280,
                                margin: const EdgeInsets.only(right: 15, bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                      child: Image.network(
                                        recipe.image, 
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 180,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFECE8E1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              recipe.category, 
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3C2415),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.orange, size: 18),
                                              const SizedBox(width: 4),
                                              Text(
                                                recipe.rating.toString(), 
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            recipe.title, 
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          Text(
                                            "By ${recipe.author}", 
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            recipe.description, 
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 13, color: Color(0xFF6C6F7F)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          if (label == "Profile") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()), 
            );
          } else if (label == "Pantry") {
            // ✨ SEKARANG AMAN: Kata kunci 'const' sudah dihapus di sini
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PantryPage()), 
            );
          } else if (label == "Create") {
            // ✨ SEKARANG AMAN: Kata kunci 'const' sudah dihapus di sini
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CreateRecipeMenuScreen()), 
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF2E1A0F) : const Color(0xFF6A7282),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF2E1A0F) : const Color(0xFF6A7282),
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}