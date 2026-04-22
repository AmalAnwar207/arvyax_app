import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/repositories/journal_repository.dart';
import 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  final JournalRepository repo;

  JournalCubit(this.repo) : super(JournalInitial());

  void load() {
    final data = repo.getAllEntries();
    emit(JournalLoaded(data));
  }

  Future<void> save(JournalEntry entry) async {
    await repo.saveEntry(entry);
    load();
  }
}