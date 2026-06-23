import 'package:flutter/material.dart';
import 'package:cooktique/screens/pantry/delete_item_dialog.dart';

class PantryCard extends StatelessWidget {
  final String title;
  final String quantity;
  final String expiry;
  final bool isWarning;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PantryCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.expiry,
    required this.isWarning,
    required this.onDelete,
    required this.onEdit,
  });

  void _openDeleteDialog(BuildContext context) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteItemDialog(itemName: title),
    );
    if (isConfirmed == true) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFFEE2E2) : const Color(0xFFF0FDF4),
        // Lengkungan dikurangi menjadi 16 untuk kesan persegi panjang
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWarning ? const Color(0xFFFCA5A5) : const Color(0xFFB8F7CF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF3C2415),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18, color: Colors.black54),
                onSelected: (value) {
                  if (value == 'delete') {
                    _openDeleteDialog(context);
                  } else if (value == 'edit') onEdit();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          Text(quantity, style: const TextStyle(color: Color(0xFF3C2415), fontSize: 11)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isWarning ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isWarning ? const Color(0xFFFFD6A7) : const Color(0xFFB8F7CF),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isWarning ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                  size: 14,
                  color: isWarning ? const Color(0xFFF54900) : const Color(0xFF008236),
                ),
                const SizedBox(width: 6),
                Text(
                  expiry,
                  style: TextStyle(
                    color: isWarning ? const Color(0xFFF54900) : const Color(0xFF008236),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}