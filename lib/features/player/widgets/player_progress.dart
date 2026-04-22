import 'package:flutter/material.dart';

class PlayerProgress extends StatelessWidget {
  final Duration position;
  final Duration duration;

  const PlayerProgress({
    super.key,
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inSeconds == 0
        ? 0.0
        : position.inSeconds / duration.inSeconds;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white10,
            color: const Color(0xFF7C6FFF),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${_format(position)} / ${_format(duration)}",
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}