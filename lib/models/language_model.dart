class LanguageModel {
  final String id;
  final String name;
  final String code;
  final String emoji;
  final String description;

  LanguageModel({
    required this.id,
    required this.name,
    required this.code,
    required this.emoji,
    required this.description,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      code: json["code"] ?? "",
      emoji: json["emoji"] ?? "💻",
      description: json["description"] ?? "",
    );
  }
}
