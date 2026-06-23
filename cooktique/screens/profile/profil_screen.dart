import 'dart:io';
import 'dart:ui'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profileImage = "https://i.pravatar.cc/300";
  String name = "Irul hobby masak";
  String username = "@kingirul";
  String email = "kingirul@gmail.com";
  String location = "Indonesia";
  String bio = "Home cook & food enthusiast 🍳\nSharing my favorite recipes and restaurant finds";

  final List<String> galleryImages = const [
    "https://i.pravatar.cc/300?img=1",
    "https://i.pravatar.cc/300?img=2",
    "https://i.pravatar.cc/300?img=3",
  ];

  ImageProvider _getProfileImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    }
    if (kIsWeb) {
      return NetworkImage(path);
    }
    return FileImage(File(path));
  }

  // Dialog Pop-up "Share with Friends" dengan Efek Latar Belakang Blur
  void _showSharePopup() {
    showDialog(
      context: context,
      barrierDismissible: true, // Pengguna bisa menutup pop-up dengan menekan area luar
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), // Menghasilkan efek blur pada background utama
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Membuat tinggi pop-up fleksibel mengikuti isi
                children: [
                  // Tombol Close (X) di pojok kanan atas dialog
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
                        child: const Icon(Icons.close, size: 18, color: Colors.black54),
                      ),
                    ),
                  ),
                  
                  // Link di bagian atas tengah
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECE8E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.link, size: 28, color: Color(0xFF3C2415)),
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
                  
                  // Bagian Share your link
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share your link",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                          style: const TextStyle(fontSize: 13, color: Colors.black87), 
                        ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Link copied to clipboard!")),
                            );
                          },
                          child: const Icon(Icons.copy, size: 18, color: Color(0xFF3C2415)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Bagian Share to Media Sosial
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share to",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _socialIcon(Icons.facebook, "Facebook", Colors.blue[800]!),
                      _socialIcon(Icons.alternate_email, "X", Colors.black),
                      _socialIcon(Icons.chat_bubble_outline, "WhatsApp", Colors.green),
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

  // Helper Widget untuk membuat ikon media sosial di dalam pop-up share
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
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
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
          onUpdate: (
            String newName,
            String newUsername,
            String newEmail,
            String newLocation,
            String newBio,
            String newImage,
          ) {
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
          onBack: () {
            Navigator.pop(context);
          },
          onAiTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("AI feature clicked")),
            );
          },
          onBackToDashboard: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          onScreenChanged: (String screen) {
            if (screen == "Profile") {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(child: _navItem(Icons.home_outlined, "Home", false)),
                Expanded(child: _navItem(Icons.kitchen_outlined, "Pantry", false)),
                const SizedBox(width: 68), 
                Expanded(child: _navItem(Icons.add_box_outlined, "Create", false)),
                Expanded(child: _navItem(Icons.person_outline, "Profile", true)),
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
                // Hanya menyisakan tombol Sign Out 
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sign Out clicked")),
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

                // PROFILE INFO
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

                // BIO TEXT
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

                // STATS BAR
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

                // Edit Profile & Share Profile
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
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          onPressed: _showSharePopup, // Diarahkan ke fungsi pop-up blur kustom
                          child: const Text(
                            "Share Profile",
                            style: TextStyle(color: Color(0xFF3C2415), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // SEARCH BAR
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search recipes",
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                    filled: true,
                    fillColor: const Color(0xFFDCD4C9),
                    suffixIcon: const Icon(Icons.search, color: Color(0xFF1C1C1E), size: 26),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                    style: TextStyle(
                      color: Color(0xFF685B4F),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 60), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {},
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
              fontSize: 11,
              color: isActive ? const Color(0xFF2E1A0F) : const Color(0xFF6A7282),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String title;

  const _StatItem({
    required this.value,
    required this.title,
  });

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
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF706C67),
          ),
        ),
      ],
    );
  }
}