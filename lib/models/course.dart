class Course {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final String languageCode;
  final int totalSkills;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.languageCode,
    required this.totalSkills,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      iconEmoji: json["iconEmoji"] ?? "📘",
      languageCode: json["languageCode"] ?? "",
      totalSkills: json["totalSkills"] ?? 0,
    );
  }
}
