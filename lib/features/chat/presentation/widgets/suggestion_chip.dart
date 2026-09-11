import 'package:flutter/material.dart';

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: null,
      avatar: Icon(icon, size: 18, color: const Color(0xFF6750A4)),
      label: Text(label),
      labelStyle: const TextStyle(
        color: Color(0xFF544B60),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE7E2EF)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }
}
