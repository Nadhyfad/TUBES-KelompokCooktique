import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  final Map<String, dynamic>? existingItem;
  const AddItemDialog({super.key, this.existingItem});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  @override
  void initState(){
    super.initState();
    if (widget.existingItem != null) {
      itemNameController.text = widget.existingItem!['title'] ?? '';
      quantityController.text = widget.existingItem!['quantity'] ?? '';

      String fullExpired = widget.existingItem!['expiry'] ?? '';
      RegExp regExp = RegExp(r'\d{1,2}/\d{1,2}/\d{4}');
      Match? match = regExp.firstMatch(fullExpired);
      if (match != null) {
        expiryDateController.text = match.group(0)!;
      }
    }
  }
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      expiryDateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Item",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Item Name
              const Text(
                "Item Name",
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  hintText: "Example: Pasta",
                  filled: true,
                  fillColor: const Color(0xFFFFF6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quantity
              const Text(
                "Quantity",
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: "500g",
                  filled: true,
                  fillColor: const Color(0xFFFFF6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Expiry Date
              const Text(
                "Expiry Date",
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: expiryDateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  hintText: "Select date",
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFF6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (itemNameController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                      // Mengembalikan data map ke page yang memanggilnya
                      Navigator.pop(context, {
                        'title': itemNameController.text,
                        'quantity': quantityController.text,
                        // Format kembali teks expirynya
                        'expiry': expiryDateController.text.isNotEmpty 
                            ? "Expires ${expiryDateController.text}" 
                            : "No expiry date",
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF685B4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Add to Pantry",
                    style: TextStyle(
                      color: Color(0xFF3C2415),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}