import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk mengecek kustomisasi platform (kPub/Web)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentScreen;
  final String profileImage;
  final String editName;
  final String editUsername;
  final String editEmail;
  final String editLocation;
  final String editBio;
  final List<String> galleryImages; // Sudah pas sesuai dengan data dari profile_screen

  final Function(
    String name,
    String username,
    String email,
    String location,
    String bio,
    String image,
  ) onUpdate;

  final VoidCallback onBack;
  final VoidCallback onAiTap;
  final VoidCallback onBackToDashboard;
  final Function(String screen) onScreenChanged;

  const EditProfileScreen({
    super.key,
    required this.currentScreen,
    required this.profileImage,
    required this.editName,
    required this.editUsername,
    required this.editEmail,
    required this.editLocation,
    required this.editBio,
    required this.galleryImages, // Ditambahkan 'required' agar aman & sinkron saat compile
    required this.onUpdate,
    required this.onBack,
    required this.onAiTap,
    required this.onBackToDashboard,
    required this.onScreenChanged,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  String? _selectedImageDraft;

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController locationController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.editName);
    usernameController = TextEditingController(text: widget.editUsername);
    emailController = TextEditingController(text: widget.editEmail);
    locationController = TextEditingController(text: widget.editLocation);
    bioController = TextEditingController(text: widget.editBio);
  }

  // 📸 PICK IMAGE CAMERA / GALLERY
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _selectedImageDraft = image.path;
        });
      }
    } catch (e) {
      debugPrint("Image error: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal membuka kamera/galeri"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // BOTTOM SHEET PILIH FOTO
  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Pilih Foto Profil",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // SAVE PROFILE
  void _saveProfile() {
    widget.onUpdate(
      nameController.text,
      usernameController.text,
      emailController.text,
      locationController.text,
      bioController.text,
      _selectedImageDraft ?? widget.profileImage,
    );
  }

  // Helper untuk menampilkan gambar secara aman baik di Web maupun Mobile
  ImageProvider _getProfileImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    }
    
    if (kIsWeb) {
      return NetworkImage(path);
    }
    
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final String displayImage =
        _selectedImageDraft ?? widget.profileImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE IMAGE (CLICKABLE)
            GestureDetector(
              onTap: _showImageSourceBottomSheet,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: _getProfileImage(displayImage),
                backgroundColor: Colors.grey[300],
              ),
            ),

            const SizedBox(height: 20),

            // NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 10),

            // USERNAME
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),

            const SizedBox(height: 10),

            // EMAIL
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 10),

            // LOCATION
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),

            const SizedBox(height: 10),

            // BIO
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Bio"),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}