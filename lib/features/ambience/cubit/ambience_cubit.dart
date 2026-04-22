import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ambience.dart';
import '../../../data/repositories/ambiences_repository.dart';
import 'ambience_state.dart';

class AmbienceCubit extends Cubit<AmbienceState> {
  final AmbiencesRepository repository;

  List<Ambience> _all = [];

  AmbienceCubit(this.repository) : super(AmbienceInitial());

  Future<void> loadAmbiences() async {
    emit(AmbienceLoading());

    try {
      final data = await repository.getAmbiences();
      _all = data;
      emit(AmbienceLoaded(_all, _all));
    } catch (e) {
      emit(AmbienceError(e.toString()));
    }
  }

  void search(String query) {
    if (state is AmbienceLoaded) {
      final currentTag = (state as AmbienceLoaded).selectedTag;

      final filtered = _all
          .where((a) =>
              a.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(AmbienceLoaded(_all, filtered, selectedTag: currentTag));
    }
  }

  void filterByTag(String tag) {
    if (state is AmbienceLoaded) {
      final filtered = _all.where((a) => a.tag == tag).toList();
      emit(AmbienceLoaded(_all, filtered, selectedTag: tag));
    }
  }

  void clearFilters() {
    emit(AmbienceLoaded(_all, _all));
  }
}