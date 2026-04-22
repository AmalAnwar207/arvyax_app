class Ambience {
  final String id;
  final String title;
  final String tag;
  final String duration;
  final String description;
  final String imagePath;
  final String audioPath;
  final List<String> sensoryRecipe;

  const Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.duration,
    required this.description,
    required this.imagePath,
    required this.audioPath,
    required this.sensoryRecipe,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'],
      title: json['title'],
      tag: json['tag'],
      duration: json['duration'],
      description: json['description'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      sensoryRecipe: List<String>.from(json['sensoryRecipe']),
    );
  }
}
