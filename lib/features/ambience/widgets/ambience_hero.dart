import 'package:flutter/material.dart';

class AmbienceHero extends StatelessWidget {
  final String imagePath;

  const AmbienceHero({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(24),
      ),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0D0D12).withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
