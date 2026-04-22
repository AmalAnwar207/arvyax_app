import 'package:flutter/material.dart';

class SensoryChips extends StatelessWidget {
  final List<String> items;

  const SensoryChips({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A28),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            e,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }
}