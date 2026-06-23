import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Hapus '../recipe/' dan gunakan import langsung
import 'home_screen.dart';
import 'recipe_model.dart';

class UploadRegularRecipeScreen extends StatefulWidget {
  const UploadRegularRecipeScreen({super.key});

  @override
  State<UploadRegularRecipeScreen> createState() => _UploadRegularRecipeScreenState();
}

class _UploadRegularRecipeScreenState extends State<UploadRegularRecipeScreen> {
  // State for dynamic lists
  List<TextEditingController> _ingredientControllers = [TextEditingController()];
  List<TextEditingController> _stepControllers = [TextEditingController()];

  // State for basic info
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  String? _selectedCategory;
  String? _selectedDifficulty;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    _titleController.dispose();
    _descController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _publishRecipe() {
    // Create new recipe object
    final newRecipe = Recipe(
      title: _titleController.text.isNotEmpty ? _titleController.text : "New Recipe",
      category: _selectedCategory ?? "Regular",
      image: _imageFile != null ? _imageFile!.path : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
      description: _descController.text.isNotEmpty ? _descController.text : "Delicious new recipe.",
      author: "Agus Khan", // Assuming current user is Agus Khan
      rating: 0.0, // New recipe has 0 rating initially
      cookTime: _cookTimeController.text.isNotEmpty ? _cookTimeController.text : "30 min",
      servings: _servingsController.text.isNotEmpty ? _servingsController.text : "2",
      difficulty: _selectedDifficulty ?? "Easy",
      ingredients: _ingredientControllers.map((c) => c.text).where((text) => text.isNotEmpty).toList(),
      instructions: _stepControllers.map((c) => c.text).where((text) => text.isNotEmpty).toList(),
    );

    // Add to top of dummy list
    dummyRecipes.insert(0, newRecipe);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(showSuccessSnackbar: true),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECE5), // Beige background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: Color(0xFF78909C), size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF78909C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              const Text(
                'Regular Recipe',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Share your recipe',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF78909C),
                ),
              ),
              const SizedBox(height: 24),

              // Image Upload Area
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.file_upload_outlined, color: Color(0xFF78909C), size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Tap to upload photo',
                              style: TextStyle(
                                color: Color(0xFF78909C),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Recipe Name
              _buildLabel('Recipe Name'),
              _buildTextField(hint: 'Recipe Name', controller: _titleController),
              const SizedBox(height: 16),

              // Description
              _buildLabel('Description'),
              _buildTextField(hint: 'Description', controller: _descController, maxLines: 3),
              const SizedBox(height: 16),

              // Category
              _buildLabel('Category'),
              _buildDropdown(
                hint: 'Select Category',
                value: _selectedCategory,
                items: ['Appetizer', 'Main Course', 'Dessert', 'Breakfast'],
                onChanged: (val) {
                  setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              // Difficulty
              _buildLabel('Difficulty'),
              _buildDropdown(
                hint: 'Select Difficulty',
                value: _selectedDifficulty,
                items: ['Easy', 'Medium', 'Hard'],
                onChanged: (val) {
                  setState(() => _selectedDifficulty = val);
                },
              ),
              const SizedBox(height: 16),

              // Cook Time & Servings
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Cook Time'),
                        _buildTextField(hint: 'Cook Time', controller: _cookTimeController),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Servings'),
                        _buildTextField(hint: 'Servings', controller: _servingsController),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ingredients
              _buildSectionHeader(title: 'Ingredients', onAdd: _addIngredient),
              const SizedBox(height: 8),
              ..._ingredientControllers.map((controller) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildTextField(hint: 'Ingredient', controller: controller),
                );
              }).toList(),
              const SizedBox(height: 12),

              // Steps
              _buildSectionHeader(title: 'Step', onAdd: _addStep),
              const SizedBox(height: 8),
              ..._stepControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0, right: 12.0),
                        child: Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            color: Color(0xFF78909C),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildTextField(hint: 'Step', controller: controller),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),

              // Publish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publishRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723), // Dark brown
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Publish Recipe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF607D8B),
        ),
      ),
    );
  }

  Widget _buildTextField({String? hint, TextEditingController? controller, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF78909C)),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel(title),
        GestureDetector(
          onTap: onAdd,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
            child: Row(
              children: const [
                Icon(Icons.add, color: Color(0xFFE64A19), size: 16), // Orange color
                SizedBox(width: 4),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE64A19),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
