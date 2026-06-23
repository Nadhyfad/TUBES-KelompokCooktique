import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedType = 'Regular'; // Default tab resep

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === BAGIAN CUSTOM NAVBAR DARIPADA TEMPLATE ANDA ===
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 16,
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
                Expanded(child: _navItem(Icons.home, "Home", true)), // Home Aktif
                Expanded(child: _navItem(Icons.kitchen_outlined, "Pantry", false)),
                const SizedBox(width: 68), // Spacer untuk FloatingActionButton AI
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI feature clicked")),
            );
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 28),
              Text("AI", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP BAR: Sign Out & Hamburger Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      icon: const Icon(Icons.logout, color: Color(0xFF706C67)),
                      label: const Text(
                        "Sign Out",
                        style: TextStyle(color: Color(0xFF706C67), fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Color(0xFF321B11), size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Judul Aplikasi & Nama User
                const Text('Cooktique', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF321B11))),
                const Text('Hi, [Member Name]', style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                const Text('Discover delicious recipe and signature menu', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),

                // Search Bar Trigger
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 12),
                        Text('Search for recipes or accounts...', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Popular Searches Section
                const Row(
                  children: [
                    Icon(Icons.trending_up, size: 20, color: Color(0xFF321B11)),
                    SizedBox(width: 8),
                    Text('Popular Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF321B11))),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Pasta', 'Healthy', 'Quick', 'Asian', 'Dessert'].map((tag) => _buildChip(tag)).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Recommended Menu Section (Regular / Signature)
                const Text('Recommended for You', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF321B11))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildToggleButton('Regular', Icons.restaurant),
                    const SizedBox(width: 12),
                    _buildToggleButton('Signature', Icons.local_see_outlined),
                  ],
                ),
                const SizedBox(height: 16),

                // Horizontal Recipe Cards Carousel
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildRecipeCard('Creamy Garlic Pasta', 'By Mukmin', '4.6', 'Pasta'),
                      _buildRecipeCard('Honey Grilled Salmon', 'By Teh Na', '4.9', 'Healthy'),
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

  Widget _navItem(IconData icon, String label, bool isActive) {
    final color = isActive ? const Color(0xFF321B11) : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildToggleButton(String type, IconData icon) {
    bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF63564F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 18),
            const SizedBox(width: 6),
            Text(type, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(String title, String author, String rating, String tag) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Mockup background box gambar asli
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                      child: Text(tag, style: const TextStyle(fontSize: 11)),
                    ),
                    Row(children: [const Icon(Icons.star, color: Colors.orange, size: 16), Text(rating, style: const TextStyle(fontSize: 12))]),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(author, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}