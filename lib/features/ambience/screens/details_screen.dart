import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/ambience.dart';
import '../../player/cubit/player_cubit.dart';
import '../../player/screens/player_screen.dart';
import '../../journal/cubit/journal_cubit.dart';
import '../widgets/ambience_hero.dart';
import '../widgets/sensory_chips.dart';
import '../widgets/start_session_button.dart';
import '../../../shared/widgets/mini_player.dart';

class DetailsScreen extends StatelessWidget {
  final Ambience ambience;

  const DetailsScreen({super.key, required this.ambience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Session",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // ===== Scrollable Content =====
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AmbienceHero(imagePath: ambience.imagePath),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ambience.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${ambience.tag} • ${ambience.duration} min",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ambience.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SensoryChips(items: ambience.sensoryRecipe),
                      const SizedBox(height: 180), // space for bottom buttons
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== Start Session Button =====
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              child: StartSessionButton(
                onPressed: () {
                  final playerCubit = context.read<PlayerCubit>();
                  final journalCubit = context.read<JournalCubit>();

                  playerCubit.startSession(ambience);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: playerCubit),
                          BlocProvider.value(value: journalCubit),
                        ],
                        child: const PlayerScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== Mini Player =====
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}