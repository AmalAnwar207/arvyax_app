import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ambienceTitle;

  @HiveField(2)
  final String mood;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
    required this.createdAt,
  });
}