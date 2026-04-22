import '../../../data/models/journal_entry.dart';

abstract class JournalState {}

class JournalInitial extends JournalState {}

class JournalLoaded extends JournalState {
  final List<JournalEntry> entries;

  JournalLoaded(this.entries);
}