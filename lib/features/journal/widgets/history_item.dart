import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String mood;
  final String date;
  final VoidCallback onTap;

  const HistoryItem({
    super.key,
    required this.title,
    required this.mood,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A28),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "$mood • $date",
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white38, size: 16),
      ),
    );
  }
}
