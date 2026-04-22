import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/player/cubit/player_cubit.dart';
import '../../features/player/cubit/player_state.dart';
import '../../features/player/screens/player_screen.dart';
import '../../features/journal/cubit/journal_cubit.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        if (state.ambience == null ||
            state.status == PlayerStatus.initial ||
            state.status == PlayerStatus.completed) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<PlayerCubit>();

        final progress = state.duration.inSeconds == 0
            ? 0.0
            : (state.position.inSeconds / state.duration.inSeconds)
                .clamp(0.0, 1.0);

        return GestureDetector(
          onTap: () {
            final playerCubit = context.read<PlayerCubit>();
            final journalCubit = context.read<JournalCubit>();

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
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A28),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      // Ambience icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C6FFF)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.self_improvement,
                          color: Color(0xFF7C6FFF),
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Title
                      Expanded(
                        child: Text(
                          state.ambience!.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Play/Pause button
                      IconButton(
                        onPressed: cubit.togglePlayPause,
                        icon: Icon(
                          state.status == PlayerStatus.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== Thin Progress Bar =====
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    color: const Color(0xFF7C6FFF),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}