import 'package:hive/hive.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  final Box<JournalEntry> box;

  JournalRepository(this.box);

  Future<void> saveEntry(JournalEntry entry) async {
    await box.put(entry.id, entry);
  }

  List<JournalEntry> getAllEntries() {
    return box.values.toList();
  }
}