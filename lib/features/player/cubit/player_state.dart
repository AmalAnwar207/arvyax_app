import '../../../data/models/ambience.dart';

enum PlayerStatus { initial, playing, paused, completed }

class PlayerState {
  final Ambience? ambience;
  final PlayerStatus status;
  final Duration position;
  final Duration duration;
  final bool showMiniPlayer; // ← ده المفقود

  const PlayerState({
    this.ambience,
    this.status = PlayerStatus.initial,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.showMiniPlayer = false,
  });

  PlayerState copyWith({
    Ambience? ambience,
    PlayerStatus? status,
    Duration? position,
    Duration? duration,
    bool? showMiniPlayer,
  }) {
    return PlayerState(
      ambience: ambience ?? this.ambience,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      showMiniPlayer: showMiniPlayer ?? this.showMiniPlayer,
    );
  }
}