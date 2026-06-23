import 'package:flutter/material.dart';
import 'create_recipe_form_screen.dart';

class CreateRecipeMenuScreen extends StatelessWidget {
  const CreateRecipeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xffECE8E1);
    const Color primaryDark = Color(0xff3C2415);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Create Recipe',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryDark),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose recipe type',
                style: TextStyle(color: Color(0xff6C6F7F), fontSize: 14),
              ),
              const SizedBox(height: 36),
              
              // Pilihan Regular Recipe
              _buildTypeCard(
                context,
                title: 'Regular Recipe',
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateRecipeFormScreen(recipeType: 'Regular'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Pilihan Signature Menu
              _buildTypeCard(
                context,
                title: 'Signature Menu',
                icon: Icons.workspace_premium_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateRecipeFormScreen(recipeType: 'Signature'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xffD4C5B0),
              radius: 22,
              child: Icon(icon, color: const Color(0xff3C2415), size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff3C2415)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xff6C6F7F)),
          ],
        ),
      ),
    );
  }
}