import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/models/journal_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(JournalEntryAdapter());

  await Hive.openBox<JournalEntry>('journalBox');

  runApp(const MyApp());
}