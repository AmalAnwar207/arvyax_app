import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:flutter/material.dart';
import 'player_state.dart';
import '../../../data/models/ambience.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState());

  final ja.AudioPlayer _player = ja.AudioPlayer();
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  Future<void> startSession(Ambience ambience) async {
    debugPrint("🚀 startSession called: ${ambience.title}");
    try {
      final duration = Duration(minutes: int.parse(ambience.duration));
      _elapsed = Duration.zero;

      emit(state.copyWith(
        ambience: ambience,
        status: PlayerStatus.playing,
        duration: duration,
        position: Duration.zero,
        showMiniPlayer: true,
      ));

      await _player.setAsset(ambience.audioPath);
      await _player.setLoopMode(ja.LoopMode.one);
      await _player.play();

      debugPrint("✅ Audio playing: ${ambience.audioPath}");

      _startTimer(duration);
    } catch (e) {
      debugPrint("❌ Audio Error: $e");
    }
  }

  void _startTimer(Duration maxDuration) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed += const Duration(seconds: 1);
      emit(state.copyWith(position: _elapsed));

      if (_elapsed >= maxDuration) {
        endSession();
      }
    });
  }

  void togglePlayPause() {
    HapticFeedback.mediumImpact();
    if (_player.playing) {
      _player.pause();
      _timer?.cancel();
      emit(state.copyWith(status: PlayerStatus.paused));
    } else {
      _player.play();
      _startTimer(state.duration - _elapsed);
      emit(state.copyWith(status: PlayerStatus.playing));
    }
  }

  void seekTo(Duration position) {
    _elapsed = position;
    _player.seek(position);
    emit(state.copyWith(position: position));
  }

  Future<void> endSession() async {
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;

    await _player.stop();
    await _player.seek(Duration.zero);

    emit(state.copyWith(
      status: PlayerStatus.completed,
      showMiniPlayer: false,
      position: Duration.zero,
    ));
  }

  @override
  Future<void> close() {
    _player.dispose();
    _timer?.cancel();
    return super.close();
  }
}