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
  void initState() {
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
    final bool isEditing = widget.existingItem != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? "Edit Item" : "Add Item",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Item Name", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  hintText: "Example: Pasta",
                  filled: true,
                  fillColor: const Color(0xFFFFF6F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Quantity", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: "500g",
                  filled: true,
                  fillColor: const Color(0xFFFFF6F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Expiry Date", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: expiryDateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  hintText: "Select date",
                  suffixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: const Color(0xFFFFF6F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (itemNameController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                      Navigator.pop(context, {
                        'title': itemNameController.text,
                        'quantity': quantityController.text,
                        'expiry': expiryDateController.text.isNotEmpty 
                            ? "Expires ${expiryDateController.text}" 
                            : "No expiry date",
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF685B4F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text(
                    isEditing ? "Confirm Changes" : "Add to Pantry",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
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