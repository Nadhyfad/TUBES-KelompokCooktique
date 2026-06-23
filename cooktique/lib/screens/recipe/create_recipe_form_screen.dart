import 'package:flutter/material.dart';

class CreateRecipeFormScreen extends StatefulWidget {
  final String recipeType; // Menerima tipe 'Regular' atau 'Signature'

  const CreateRecipeFormScreen({super.key, required this.recipeType});

  @override
  State<CreateRecipeFormScreen> createState() => _CreateRecipeFormScreenState();
}

class _CreateRecipeFormScreenState extends State<CreateRecipeFormScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedDifficulty;

  // List dinamis untuk menampung controller text field
  final List<TextEditingController> _ingredients = [TextEditingController()];
  final List<TextEditingController> _steps = [TextEditingController()];

  // ================= PERBAIKAN PALET WARNA (EARTH TONE) =================
  final Color _bgColor = const Color(0xffF0EBE1);         // Latar belakang cream lembut
  final Color _primaryDark = const Color(0xff362215);     // Cokelat tua untuk teks utama & tombol publish
  final Color _hintColor = const Color(0xff7A756E);       // Abu-abu kecokelatan untuk petunjuk/sub-judul
  final Color _addBtnColor = const Color(0xffD56C33);     // Terracotta/Orange hangat untuk tombol '+ Add'
  // =====================================================================

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    for (var c in _ingredients) {
      c.dispose();
    }
    for (var c in _steps) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _primaryDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.recipeType == 'Regular' ? 'Upload Regular Recipe' : 'Upload Signature Menu',
          style: TextStyle(color: _primaryDark, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share your recipe', style: TextStyle(color: _hintColor, fontSize: 13)),
              const SizedBox(height: 16),
              
              // Kotak Wadah Upload Foto / Placeholder Gambar Terpilih
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload, size: 32, color: _primaryDark.withValues(alpha: 0.6)),
                    const SizedBox(height: 8),
                    Text('Tap to upload photo', style: TextStyle(color: _hintColor, fontSize: 12)),
                  ],
                ),
              ),
              
              _buildLabel('Recipe Name'),
              _buildTextField(_nameController, 'Enter recipe name'),
              
              _buildLabel('Description'),
              _buildTextField(_descController, 'Enter description', maxLines: 3),

              _buildLabel('Category'),
              _buildDropdown(
                value: _selectedCategory,
                hint: 'Select Category',
                items: ['Breakfast', 'Appetizer', 'Main Course', 'Dessert'],
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),

              _buildLabel('Difficulty'),
              _buildDropdown(
                value: _selectedDifficulty,
                hint: 'Select Difficulty',
                items: ['Easy', 'Medium', 'Hard'],
                onChanged: (val) => setState(() => _selectedDifficulty = val),
              ),

              // Bagian Penambahan Bahan (+ Add)
              _buildSectionHeader('Ingredients', () {
                setState(() => _ingredients.add(TextEditingController()));
              }),
              ..._ingredients.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildTextField(entry.value, 'Ingredient'),
                );
              }),

              // Bagian Penambahan Langkah Kerja (+ Add)
              _buildSectionHeader('Step', () {
                setState(() => _steps.add(TextEditingController()));
              }),
              ..._steps.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildTextField(
                    entry.value, 
                    'Step', 
                    prefixText: '${entry.key + 1}. ',
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Tombol Konfirmasi Publish
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.recipeType} recipe successfully published!'),
                        backgroundColor: Colors.black87,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Publish Recipe', 
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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

  // Komponen pembantu Label Judul Input Field
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text, 
        style: TextStyle(fontWeight: FontWeight.bold, color: _primaryDark, fontSize: 14),
      ),
    );
  }

  // Komponen Pembantu Text Input Box
  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, String? prefixText}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: _primaryDark, fontSize: 14),
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixStyle: TextStyle(color: _primaryDark, fontWeight: FontWeight.bold),
        hintText: hint,
        hintStyle: TextStyle(color: _hintColor.withValues(alpha: 0.7), fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  // Komponen Pembantu Pilihan Dropdown Menu
  Widget _buildDropdown({required String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: _hintColor.withValues(alpha: 0.7), fontSize: 13)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: _hintColor),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: _primaryDark)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Judul section sub-kategori (Ingredients / Steps) dengan tombol tambah (+ Add)
  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: _primaryDark, fontSize: 15)),
          TextButton(
            onPressed: onAdd,
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            child: Text(
              '+ Add', 
              style: TextStyle(
                color: _addBtnColor, // SEKARANG MENGGUNAKAN WARNA TERRACOTTA YANG VALID SESUAI DESAIN MOCKUP
                fontWeight: FontWeight.bold, 
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}