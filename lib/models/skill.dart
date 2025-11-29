class Skill {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final int orderIndex;
  final bool isUnlocked;
  final int lessonsCount;
  final double progress;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    required this.orderIndex,
    required this.isUnlocked,
    required this.lessonsCount,
    this.progress = 0.0,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      iconEmoji: json["iconEmoji"] ?? "📘",
      orderIndex: json["orderIndex"] ?? 0,
      isUnlocked: json["isUnlocked"] ?? false,
      lessonsCount: json["lessonsCount"] ?? 0,
      progress: (json["progress"] as num?)?.toDouble() ?? 0.0,
    );
  }
}
