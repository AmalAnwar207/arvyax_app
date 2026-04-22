import '../../../data/models/ambience.dart';

abstract class AmbienceState {}

class AmbienceInitial extends AmbienceState {}

class AmbienceLoading extends AmbienceState {}

class AmbienceLoaded extends AmbienceState {
  final List<Ambience> all;
  final List<Ambience> filtered;
  final String? selectedTag;

  AmbienceLoaded(this.all, this.filtered, {this.selectedTag});
}

class AmbienceError extends AmbienceState {
  final String message;

  AmbienceError(this.message);
}