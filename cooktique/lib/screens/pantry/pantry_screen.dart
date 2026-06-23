import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cooktique/screens/pantry/pantry_card.dart';
import 'package:cooktique/screens/pantry/add_item_dialog.dart';
import 'package:cooktique/screens/pantry/edit_item_dialog.dart';

import 'package:cooktique/screens/profile/edit_profile_screen.dart';
import 'package:cooktique/screens/auth/login_screen.dart';

import 'package:cooktique/screens/recipe/home_screen.dart';
import 'package:cooktique/screens/recipe/create_recipe_menu_screen.dart';

// --- PLACEHOLDER HALAMAN LAIN (Agar project tidak error) ---
// Sesuaikan import aslinya jika file-file di bawah ini sudah kamu buat secara terpisah.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("Home Screen"));
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text("Create Screen"));
}
// -----------------------------------------------------------

class PantryPage extends StatefulWidget {
  const PantryPage({super.key});

  @override
  State<PantryPage> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  // 1. STATE UNTUK KONTROL HALAMAN AKTIF
  int _currentIndex =
      1; // Default ke 1 supaya aplikasi langsung menampilkan isi Pantry utama

  // --- State & Variabel Data Pantry ---
  final List<Map<String, dynamic>> _pantryItems = [
    {"title": "Pasta", "quantity": "500g", "expiryDate": "30/12/2026"},
    {"title": "Tomatoes", "quantity": "6 pieces", "expiryDate": "23/06/2026"},
  ];

  // --- State & Variabel Data Profil ---
  String profileImage = "https://i.pravatar.cc/300";
  String name = "Irul hobby masak";
  String username = "@kingirul";
  String email = "kingirul@gmail.com";
  String location = "Indonesia";
  String bio =
      "Home cook & food enthusiast 🍳\nSharing my favorite recipes and restaurant finds";

  final List<String> galleryImages = const [
    "https://i.pravatar.cc/300?img=1",
    "https://i.pravatar.cc/300?img=2",
    "https://i.pravatar.cc/300?img=3",
  ];

  // --- Fungsi-Fungsi Helper Logika Pantry ---
  bool _checkIsWarning(String dateStr) {
    if (dateStr.isEmpty) return false;
    try {
      List<String> parts = dateStr.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      DateTime expiryDateTime = DateTime(year, month, day);
      DateTime today = DateTime.now();
      int difference = expiryDateTime
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;
      return difference <= 3;
    } catch (e) {
      return false;
    }
  }

  String _getExpiryText(String dateStr) {
    if (dateStr.isEmpty) return "No expiry date";
    try {
      List<String> parts = dateStr.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      DateTime expiryDateTime = DateTime(year, month, day);
      DateTime today = DateTime.now();
      int difference = expiryDateTime
          .difference(DateTime(today.year, today.month, today.day))
          .inDays;

      if (difference < 0) {
        return "Expired $dateStr";
      } else if (difference == 0) {
        return "Expires Today!";
      } else if (difference <= 3) {
        return "$difference days left ($dateStr)";
      } else {
        return "Expires $dateStr";
      }
    } catch (e) {
      return "Expires $dateStr";
    }
  }

  void _openAddItemDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );
    if (result != null && result['title'] != null) {
      setState(() {
        _pantryItems.add({
          "title": result['title'],
          "quantity": result['quantity'],
          "expiryDate": result['expiry'].toString().replaceAll("Expires ", ""),
        });
      });
    }
  }

  void _openEditItemDialog(BuildContext context, int index) async {
    final item = _pantryItems[index];
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditItemDialog(
        existingItem: {
          "title": item['title'],
          "quantity": item['quantity'],
          "expiry": "Expires ${item['expiryDate']}",
        },
      ),
    );
    if (result != null && result['title'] != null) {
      setState(() {
        _pantryItems[index] = {
          "title": result['title'],
          "quantity": result['quantity'],
          "expiryDate": result['expiry'].toString().replaceAll("Expires ", ""),
        };
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _pantryItems.removeAt(index);
    });
  }

  // --- Fungsi-Fungsi Helper Logika Profil ---
  ImageProvider _getProfileImage(String path) {
    if (path.startsWith('http') || path.startsWith('https'))
      return NetworkImage(path);
    if (kIsWeb) return NetworkImage(path);
    return FileImage(File(path));
  }

  void _showSharePopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFECE8E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.link,
                      size: 28,
                      color: Color(0xFF3C2415),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Share with Friends",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C2415),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Cooking is more fun when you connect with friends!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share your link",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "https://cooktique.app/$username",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Link copied to clipboard!"),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 18,
                            color: Color(0xFF3C2415),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share to",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _socialIcon(
                        Icons.facebook,
                        "Facebook",
                        Colors.blue[800]!,
                      ),
                      _socialIcon(Icons.alternate_email, "X", Colors.black),
                      _socialIcon(
                        Icons.chat_bubble_outline,
                        "WhatsApp",
                        Colors.green,
                      ),
                      _socialIcon(Icons.send, "Telegram", Colors.blue[400]!),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _socialIcon(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }

  void openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          currentScreen: "Profile",
          profileImage: profileImage,
          editName: name,
          editUsername: username,
          editEmail: email,
          editLocation: location,
          editBio: bio,
          galleryImages: galleryImages,
          onUpdate:
              (newName, newUsername, newEmail, newLocation, newBio, newImage) {
                setState(() {
                  name = newName;
                  username = newUsername;
                  email = newEmail;
                  location = newLocation;
                  bio = newBio;
                  profileImage = newImage;
                });
                Navigator.pop(context);
              },
          onBack: () => Navigator.pop(context),
          onAiTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("AI feature clicked")));
          },
          onBackToDashboard: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          onScreenChanged: (String screen) {
            if (screen == "Profile") Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // --- SUB-WIDGET 1: KONTEN UTAMA HALAMAN PANTRY ---
  Widget _buildPantryContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Pantry",
              style: TextStyle(
                color: Color(0xFF3C2415),
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Keep track of your ingredients",
              style: TextStyle(color: Color(0xFF6C6F7F), fontSize: 14),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Ingredients",
                  style: TextStyle(
                    color: Color(0xFF3C2415),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddItemDialog(context),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    "Add Item",
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C2415),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _pantryItems.isEmpty
                  ? const Center(child: Text("Your pantry is empty."))
                  : ListView.builder(
                      itemCount: _pantryItems.length,
                      itemBuilder: (context, index) {
                        final item = _pantryItems[index];
                        String rawDate = item['expiryDate'] ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: PantryCard(
                            title: item['title'],
                            quantity: item['quantity'],
                            expiry: _getExpiryText(rawDate),
                            isWarning: _checkIsWarning(rawDate),
                            onDelete: () => _deleteItem(index),
                            onEdit: () => _openEditItemDialog(context, index),
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

  // --- SUB-WIDGET 2: KONTEN UTAMA HALAMAN PROFIL ---
  Widget _buildProfileContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Color(0xFF706C67)),
                    label: const Text(
                      "Sign Out",
                      style: TextStyle(color: Color(0xFF706C67), fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundImage: _getProfileImage(profileImage),
                    backgroundColor: Colors.grey[400],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F1828),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF706C67),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF706C67),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                bio,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1C1C1E),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFC7C1B8), thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(value: "24", title: "Recipes"),
                    _StatItem(value: "1.2k", title: "Followers"),
                    _StatItem(value: "342", title: "Following"),
                    _StatItem(value: "4.9", title: "Rating"),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFC7C1B8), thickness: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C2415),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: openEditProfile,
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _showSharePopup,
                        child: const Text(
                          "Share Profile",
                          style: TextStyle(
                            color: Color(0xFF3C2415),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search recipes",
                  hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                  filled: true,
                  fillColor: const Color(0xFFDCD4C9),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF1C1C1E),
                    size: 26,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Center(
                child: Icon(
                  Icons.menu_book,
                  size: 100,
                  color: Color(0xFF685B4F),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Easily save your cooking notes\nsafely and securely on Cooktique. 🍳✨",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF685B4F), fontSize: 13),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // --- BUILD UTAMA ---
  @override
  Widget build(BuildContext context) {
    // Memilih halaman body yang aktif berdasarkan index navbar
    Widget currentBody;
    switch (_currentIndex) {
      case 0:
        currentBody = const HomePage();
        break;
      case 1:
        currentBody = _buildPantryContent();
        break;
      case 2:
        currentBody = const CreatePage();
        break;
      case 3:
        currentBody = _buildProfileContent();
        break;
      default:
        currentBody = _buildPantryContent();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFECE8E1),
      body: currentBody, // Menampilkan halaman terpilih
      // Desain BottomAppBar Kustom Gabungan dengan notch FloatingActionButton
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
              // HOME
              Expanded(
                child: navItem(Icons.home_outlined, "Home", false, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                }),
              ),
              // PANTRY
              Expanded(
                child: navItem(Icons.kitchen_outlined, "Pantry", true, () {}),
              ),
              const SizedBox(width: 68), // Spacer FAB
              // CREATE
              Expanded(
                child: navItem(Icons.add_box_outlined, "Create", false, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateRecipeMenuScreen()));
                }),
              ),
              // PROFILE
              Expanded(
                child: navItem(Icons.person_outline, "Profile", false, () {
                  // Jika ingin tetap di halaman ini untuk profil, biarkan kosong atau atur setState
                }),
              ),
            ],
          ),
        ),
      ),
    ),

      // Tombol AI Mengambang di Tengah (Floating Action Button)
      floatingActionButton: SizedBox(
        width: 68,
        height: 68,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF321B11),
          shape: const CircleBorder(),
          elevation: 4,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("AI feature clicked")));
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
    );
  }

  // Widget Helper NavItem Lokal yang sudah mendukung Callback Klik (onTap)
  Widget navItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF2E1A0F) : const Color(0xFF6A7282),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? const Color(0xFF2E1A0F) : const Color(0xFF6A7282),
              fontWeight: active ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget StatItem Komponen Profil Pendukung diluar Class State Utama
class _StatItem extends StatelessWidget {
  final String value;
  final String title;
  const _StatItem({required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Color(0xFF706C67)),
        ),
      ],
    );
  }
}
