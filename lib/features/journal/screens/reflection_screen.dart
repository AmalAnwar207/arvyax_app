import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../cubit/journal_cubit.dart';
import '../../player/cubit/player_cubit.dart';
import '../../../data/models/journal_entry.dart';
import '../widgets/mood_selector.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final TextEditingController controller = TextEditingController();
  String mood = "Calm";

  @override
  Widget build(BuildContext context) {
    final playerState = context.read<PlayerCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        title: const Text(
          "Reflection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Ambience label
            Text(
              playerState.ambience?.title ?? "",
              style: const TextStyle(
                color: Color(0xFF7C6FFF),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

            // Prompt
            const Text(
              "What is gently present\nwith you right now?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Text Input
            TextField(
              controller: controller,
              maxLines: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write your thoughts...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A1A28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "How do you feel?",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Mood Selector
            MoodSelector(
              selectedMood: mood,
              onSelected: (m) => setState(() => mood = m),
            ),

            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  final entry = JournalEntry(
                    id: const Uuid().v4(),
                    ambienceTitle:
                        playerState.ambience?.title ?? "",
                    mood: mood,
                    text: controller.text,
                    createdAt: DateTime.now(),
                  );

                  context.read<JournalCubit>().save(entry);

                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C6FFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save Reflection",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}