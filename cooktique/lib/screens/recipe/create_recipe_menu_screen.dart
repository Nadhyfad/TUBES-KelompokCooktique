import 'package:flutter/material.dart';
import 'upload_regular_recipe_screen.dart';
import '../recipe/home_screen.dart';

class CreateRecipeMenuScreen extends StatefulWidget {
  const CreateRecipeMenuScreen({super.key});

  @override
  State<CreateRecipeMenuScreen> createState() => _CreateRecipeMenuScreenState();
}

class _CreateRecipeMenuScreenState extends State<CreateRecipeMenuScreen> {
  // Colors exactly as in edit_profile_screen
  static const Color primaryBrown = Color(0xFF3C2415);
  static const Color textDark = Color(0xFF2E1A0F);

  Widget _navItem(IconData icon, String label, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE2E4E9), // Light grey circle for active Create icon
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: textDark,
                size: 24,
              ),
            )
          else
            Icon(
              icon,
              color: const Color(0xFF6A7282),
              size: 24,
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? textDark : const Color(0xFF6A7282),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECE5), // Warna background krem sesuai desain
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
                Expanded(
                  child: _navItem(Icons.home_outlined, "Home", false, () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  }),
                ),
                Expanded(child: _navItem(Icons.inventory_2_outlined, "Pantry", false, null)),
                const SizedBox(width: 68), // Space for FAB
                Expanded(child: _navItem(Icons.add_circle_outline, "Create", true, null)),
                Expanded(child: _navItem(Icons.person_outline, "Profile", false, null)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          backgroundColor: primaryBrown,
          shape: const CircleBorder(),
          elevation: 6,
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(height: 2),
              Text(
                'AI',
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
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create Recipe',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723), // Warna coklat gelap
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose recipe type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF78909C), // Warna abu-abu kebiruan
                ),
              ),
              const SizedBox(height: 32),
              
              // Card Regular Recipe
              _buildRecipeTypeCard(
                context: context,
                title: 'Regular Recipe',
                icon: Icons.add,
                iconColor: const Color(0xFF455A64),
                iconBgColor: const Color(0xFFF1F3F4),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadRegularRecipeScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Card Signature Menu
              _buildRecipeTypeCard(
                context: context,
                title: 'Signature Menu',
                icon: Icons.workspace_premium_outlined, // Mirip ikon pita/award
                iconColor: Colors.white,
                iconBgColor: const Color(0xFF3E2723), // Coklat gelap
                onTap: () {
                  // TODO: Navigasi ke halaman form Signature Menu
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeTypeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
