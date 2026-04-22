import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final moods = ["Calm", "Grounded", "Energized", "Sleepy"];

    return Wrap(
      spacing: 8,
      children: moods.map((mood) {
        final isSelected = selectedMood == mood;

        return ChoiceChip(
          label: Text(mood),
          selected: isSelected,
          onSelected: (_) => onSelected(mood),
          selectedColor: const Color(0xFF7C6FFF),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
          ),
          backgroundColor: const Color(0xFF1A1A28),
        );
      }).toList(),
    );
  }
}
