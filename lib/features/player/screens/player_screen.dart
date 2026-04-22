import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/player_cubit.dart';
import '../cubit/player_state.dart';
import '../../journal/cubit/journal_cubit.dart';
import '../../journal/screens/reflection_screen.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerCubit, PlayerState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.status == PlayerStatus.completed,
      listener: (context, state) {
        final journalCubit = context.read<JournalCubit>();
        final playerCubit = context.read<PlayerCubit>();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: journalCubit),
                BlocProvider.value(value: playerCubit),
              ],
              child: const ReflectionScreen(),
            ),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D12),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            final cubit = context.read<PlayerCubit>();

            final progress = state.duration.inSeconds == 0
                ? 0.0
                : (state.position.inSeconds / state.duration.inSeconds)
                    .clamp(0.0, 1.0);

            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // ===== Title =====
                  Text(
                    state.ambience?.title ?? "No Session",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    state.ambience?.tag ?? "",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ===== Breathing Animation + Play Button =====
                  AnimatedBuilder(
                    animation: _breathAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse ring
                          Transform.scale(
                            scale: _breathAnimation.value * 1.3,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF7C6FFF)
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          // Middle pulse ring
                          Transform.scale(
                            scale: _breathAnimation.value * 1.15,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF7C6FFF)
                                    .withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                          // Play button
                          GestureDetector(
                            onTap: cubit.togglePlayPause,
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF7C6FFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7C6FFF)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: Icon(
                                state.status == PlayerStatus.playing
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  // ===== Seek Bar =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14),
                            activeTrackColor: const Color(0xFF7C6FFF),
                            inactiveTrackColor: Colors.white10,
                            thumbColor: Colors.white,
                            overlayColor:
                                const Color(0xFF7C6FFF).withValues(alpha: 0.2),
                          ),
                          child: Slider(
                            value: state.position.inSeconds
                                .toDouble()
                                .clamp(
                                    0,
                                    state.duration.inSeconds
                                        .toDouble()),
                            min: 0,
                            max: state.duration.inSeconds > 0
                                ? state.duration.inSeconds.toDouble()
                                : 1,
                            onChanged: (value) {
                              cubit.seekTo(
                                  Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _format(state.position),
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12),
                              ),
                              Text(
                                _format(state.duration),
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ===== End Session Button =====
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A28),
                          title: const Text(
                            "End Session?",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style:
                                    TextStyle(color: Colors.white54),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                final journalCubit =
                                    context.read<JournalCubit>();
                                final playerCubit =
                                    context.read<PlayerCubit>();

                                playerCubit.endSession();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                            value: journalCubit),
                                        BlocProvider.value(
                                            value: playerCubit),
                                      ],
                                      child: const ReflectionScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "End",
                                style:
                                    TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "End Session",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}